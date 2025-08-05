//
//  BinaryParser.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import Foundation

/// Represents a single TD4 instruction, identified by a unique UUID and its hexadecimal value.
struct Instruction: Identifiable {
    /// Unique identifier for the instruction instance.
    let id = UUID()
    /// The raw 8-bit hexadecimal value of the instruction.
    var hex: UInt8
}


/// Provides a human-readable string representation for TD4 instructions.
extension Instruction: CustomStringConvertible {
    /// Converts the instruction to a readable assembly-like string.
    var description: String {
        return instructionToString(hex)
    }

    /// Converts a raw instruction byte to its string representation.
    /// - Parameter instruction: The raw instruction byte.
    /// - Returns: A string describing the instruction in TD4 assembly format.
    private func instructionToString(_ instruction: UInt8) -> String {
        if instruction == 0 {
            return "nop"
        }

        let opcode = (instruction >> 4)
        let imm = instruction & 0x0F

        let opcodeString: String = switch opcode {
            case 0b0000: "add a, "
            case 0b0001: "mov a, b"
            case 0b0010: "in a"
            case 0b0011: "mov a, "
            case 0b0100: "mov b, a"
            case 0b0101: "add b, "
            case 0b0110: "in b"
            case 0b0111: "mov b, "
            case 0b1001: "out b"
            case 0b1011: "out "
            case 0b1110: "jnc "
            case 0b1111: "jmp "
            default:     "nop"
        }

        if opcodeString.hasSuffix(", ") || [0b1011, 0b1110, 0b1111].contains(opcode) {
            return opcodeString + String(imm).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            if imm == 0 && !([0b1111, 0b1110, 0b1011].contains(opcode)) {
                return opcodeString
            }
            return opcodeString + "+" + String(imm).trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
