//
//  TD4CPU.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import Foundation

/// TD4CpuError defines possible errors for the TD4 CPU emulator.
/// - invalidOpcode: The opcode is not recognized by the CPU.
/// - immediateOverflow: The operand value exceeds the allowed range.
/// - romOverflow: The program counter exceeded ROM size.
/// - halted: Halt instruction detected, run to be finished
enum TD4CpuError: Error, CustomStringConvertible {
    case invalidOpcode(opcode: UInt8)
    case immediateOverflow(value: UInt8)
    case romOverflow
    case halted
    
    /// Returns a human-readable description of the error.
    var description: String {
        switch self {
        case .invalidOpcode(opcode: let opcode):
            return "Invalid opcode: \(String(opcode, radix: 16, uppercase: true))"
        case .immediateOverflow(value: let value):
            return "Immediate overflow: \(String(value, radix: 16, uppercase: true))"
        case .romOverflow:
            return "ROM overflow"
        case .halted:
            return "Halt instruction detected"
        }
    }
}

/// TD4CPU emulates the TD4 microcontroller, including registers, flags, and program execution.
/// Provides methods for running, stepping, and resetting the CPU state.
@Observable
class TD4CPU {
    // General purpose registers
    /// General purpose register A
    var regA: UInt8 = 0
    /// General purpose register B
    var regB: UInt8 = 0
    
    // I/O
    /// Input register
    var regIn: UInt8 = 0
    /// Output register
    var regOut: UInt8 = 0
    
    // Special registers
    /// Carry flag
    var carryFlag: Bool = false
    /// Current TD4 binary file instruction ID
    var selected: Instruction.ID? = nil
    
    // ROM – program storage
    /// Current TD4 binary file
    var rom: TD4BinaryFile
    
    private var execution: Task<(), any Error>?
    private var running = false
    private var carryFlagDrop: Bool = false
    /// The program counter register. Gets or sets the current instruction index.
    public var programCounter: UInt8 {
        get {
            guard let instruction = rom.contents.firstIndex(where: {$0.id == selected}) else {
                return 0
            }
            return UInt8(instruction)
        }
        set(value) {
            guard value < rom.contents.count else {
                selected = nil
                return
            }
            selected = rom.contents[Int(value)].id
        }
    }
    
    /// Fetches the instruction at the current program counter from the given binary file.
    /// - Parameter program: The TD4BinaryFile containing program instructions.
    /// - Returns: The instruction byte at the current program counter.
    private func fetch(_ program: TD4BinaryFile) -> UInt8 {
        return program.contents[Int(programCounter)].hex
    }
    
    /// Decodes an instruction byte into opcode and operand.
    /// - Parameter instruction: The instruction byte to decode.
    /// - Returns: A tuple containing the opcode and operand.
    private func decode(_ instruction: UInt8) -> (opcode: UInt8, operand: UInt8) {
        let opcode: UInt8 = (instruction >> 4)
        let operand: UInt8 = (instruction & 0x0F)
        return (opcode, operand)
    }
    
    /// Adds two 4-bit values and returns the result and carry flag.
    /// - Parameters:
    ///   - a: First operand (4-bit value).
    ///   - b: Second operand (4-bit value).
    /// - Returns: Tuple of (sum, carryFlag).
    private func sum(_ a: UInt8, _ b: UInt8) -> (UInt8, Bool) {
        return ((a + b) & 0x0F, a + b > 0x0F)
    }
    
    /// Executes a single instruction based on the opcode and operand.
    /// - Parameters:
    ///   - opcode: The operation code to execute.
    ///   - operand: The operand for the instruction.
    /// - Throws: TD4CpuError if an invalid opcode or operand is encountered.
    private func execute(opcode: UInt8, operand: UInt8) throws(TD4CpuError) {
        guard operand <= 0x0F else {
            throw .immediateOverflow(value: operand)
        }
        
        // Carry flag raised for next tick only
        if carryFlag && carryFlagDrop {
            carryFlagDrop = false
            carryFlag = false
        } else if carryFlag && !carryFlagDrop {
            carryFlagDrop = true
        }
        
        // Decoding
        switch opcode {
        case 0x0:
            (regA, carryFlag) = sum(regA, operand)
        case 0x1:
            (regA, carryFlag) = sum(regB, operand)
        case 0x2:
            (regA, carryFlag) = sum(regIn, operand)
        case 0x3:
            regA = operand
        case 0x4:
            (regB, carryFlag) = sum(regA, operand)
        case 0x5:
            (regB, carryFlag) = sum(regB, operand)
        case 0x6:
            (regB, carryFlag) = sum(regIn, operand)
        case 0x7:
            regB = operand
        case 0x9:
            (regOut, carryFlag) = sum(regB, operand)
        case 0b1011:
            regOut = operand
        case 0b1110:
            if !carryFlag {
                programCounter = operand
                return
            }
        case 0b1111:
            programCounter = operand
            return
        default:
            throw .invalidOpcode(opcode: opcode)
        }
        // Increment PC (with loop)
        programCounter = (programCounter + 1) & 0x0F
    }
    
    /// Initializes the CPU with an empty program.
    init() {
        self.rom = TD4BinaryFile()
        reset()
    }
    
    /// Initializes the CPU with a program from an array of bytes.
    /// - Parameter program: Array of instruction bytes.
    init(_ program: [UInt8]) {
        self.rom = TD4BinaryFile(text: program)
        reset()
    }
    
    /// Initializes the CPU with a TD4BinaryFile document.
    /// - Parameter document: The binary file containing program instructions.
    init(_ document: TD4BinaryFile) {
        self.rom = document
        reset()
    }
    
    // Methods
    /// Resets all registers, flags, and the program counter to their initial state.
    public func reset() {
        regA = 0
        regB = 0
        regIn = 0
        regOut = 0
        programCounter = 0
        carryFlag = false
        carryFlagDrop = false
    }
    
    /// Starts execution of the program in a background task.
    @MainActor
    public func run(onRunFinished: @escaping (_ err: TD4CpuError?) -> ()) {
        running = true
        var execError: TD4CpuError?
        self.execution = Task {
            while running {
                do throws(TD4CpuError) {
                    try step()
                } catch {
                    running = false
                    execError = error
                }
                try await Task.sleep(nanoseconds: 10)
            }
            onRunFinished(execError)
        }
    }
    
    /// Stops execution of the program and cancels the running task.
    @MainActor
    public func stop() {
        running = false
        self.execution?.cancel()
    }
    
    /// Executes a single instruction (step) of the program.
    /// - Throws: TD4CpuError if an error occurs during execution.
    public func step() throws(TD4CpuError) {
        let instruction: UInt8 = fetch(self.rom)
        
        let (opcode, operand) = decode(instruction)
        
        if detectHalt(opcode: opcode, immediate: operand) {
            throw .halted
        }
        
        do {
            try execute(opcode: opcode, operand: operand)
        } catch let error {
            throw error
        }
    }
    
    /// Returns true if halt (unconditional self jump) opcode detected
    /// - Parameter opcode: current instruction opcode
    /// - Parameter operand: current instruction immediate
    private func detectHalt(opcode: UInt8, immediate: UInt8) -> Bool {
        return opcode == 0b1111 && immediate == programCounter
    }
}
