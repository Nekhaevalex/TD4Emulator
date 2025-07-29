//
//  TD4CPU.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import Foundation

enum TD4CpuError: Error, CustomStringConvertible {
    case invalidOpcode(opcode: UInt8)
    case immediateOverflow(value: UInt8)
    case romOverflow
    
    var description: String {
        switch self {
        case .invalidOpcode(opcode: let opcode):
            return "Invalid opcode: \(String(opcode, radix: 16, uppercase: true))"
        case .immediateOverflow(value: let value):
            return "Immediate overflow: \(String(value, radix: 16, uppercase: true))"
        case .romOverflow:
            return "ROM overflow"
        }
    }
}

// TD4 CPU object
class TD4CPU: ObservableObject {
    // General purpose registers
    @Published var regA: UInt8 = 0
    @Published var regB: UInt8 = 0
    
    // I/O
    @Published var regIn: UInt8 = 0
    @Published var regOut: UInt8 = 0
    
    // Special registers
    @Published var carryFlag: Bool = false
    @Published var selected: Instruction.ID? = nil
    
    // ROM – program storage
    @Published var rom: TD4BinaryFile? = TD4BinaryFile()
    
    private var carryFlagDrop: Bool = false
    public var programCounter: UInt8 {
        get {
            guard let constRom = rom else {
                return 0
            }
            guard let instruction = constRom.contents.first(where: {$0.id == selected}) else {
                return 0
            }
            return instruction.index
        }
        set(value) {
            guard let constRom = rom else {
                selected = nil
                return
            }
            guard value < constRom.contents.count else {
                selected = nil
                return
            }
            selected = constRom.contents[Int(value)].id
        }
    }
    
    private func fetch(_ program: TD4BinaryFile) -> UInt8 {
        return program.contents[Int(programCounter)].hex
    }
    
    private func decode(_ instruction: UInt8) -> (opcode: UInt8, operand: UInt8) {
        let opcode: UInt8 = (instruction >> 4)
        let operand: UInt8 = (instruction & 0x0F)
        return (opcode, operand)
    }
    
    private func sum(_ a: UInt8, _ b: UInt8) -> (UInt8, Bool) {
        return ((a + b) & 0x0F, a + b > 0x0F)
    }
    
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
    
    init() {
        self.rom = TD4BinaryFile()
        reset()
    }
    
    init(_ program: [UInt8]) {
        self.rom = TD4BinaryFile(text: program)
        reset()
    }
    
    init(_ document: TD4BinaryFile) {
        self.rom = document
        reset()
    }
    
    // Methods
    public func reset() {
        regA = 0
        regB = 0
        regIn = 0
        regOut = 0
        programCounter = 0
        carryFlag = false
        carryFlagDrop = false
    }
    
    public func step(_ program: TD4BinaryFile) throws(TD4CpuError) {
        let instruction: UInt8 = fetch(program)
        
        let (opcode, operand) = decode(instruction)
        
        do {
            try execute(opcode: opcode, operand: operand)
        } catch let error {
            throw error
        }
    }
}
