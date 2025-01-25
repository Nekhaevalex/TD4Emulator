//
//  BinaryParser.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import Foundation

func instructionToString(_ instruction: UInt8) -> String {
    let opcode = (instruction >> 4)
    let imm = instruction & 0x0F
    
    var opcodeString: String
    
    switch opcode {
    case 0b0000:
        opcodeString = "add a, "
    case 0b0001:
        opcodeString = "mov a, b"
    case 0b0010:
        opcodeString = "in a"
    case 0b0011:
        opcodeString = "mov a, "
    case 0b0100:
        opcodeString = "mov b, a"
    case 0b0101:
        opcodeString = "add b, "
    case 0b0110:
        opcodeString = "in b"
    case 0b0111:
        opcodeString = "mov b, "
    case 0b1001:
        opcodeString = "out b"
    case 0b1011:
        opcodeString = "out "
    case 0b1110:
        opcodeString = "jnc "
    case 0b1111:
        opcodeString = "jmp "
    default:
        opcodeString = "nop"
    }
    
    if opcodeString.hasSuffix(", ") {
        return opcodeString + String(imm).trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
        return opcodeString + "+" + String(imm).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
