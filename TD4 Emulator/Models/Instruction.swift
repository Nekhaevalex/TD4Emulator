//
//  BinaryParser.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import Foundation

struct Instruction: Identifiable {
    let id = UUID()
    var hex: UInt8
}

extension Instruction: CustomStringConvertible {
    var description: String {
        return instructionToString(hex)
    }
    
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
