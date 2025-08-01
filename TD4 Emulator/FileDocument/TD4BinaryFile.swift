//
//  TD4_EmulatorDocument.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var td4Binary: UTType {
        UTType(exportedAs: "com.example.td4bin")
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

@Observable
class TD4BinaryFile: FileDocument {
    static var readableContentTypes: [UTType] { [.td4Binary] }
    var contents: [Instruction]
    var asArray: [UInt8] {
        contents.map{$0.hex}
    }

    init(text: [UInt8] = Array(repeating: 0, count: 1)) {
        let size = text.count
        self.contents = text[0..<min(size, 16)]
            .enumerated()
            .map { (index, value) in
                Instruction(hex: value)
            }
    }

    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let bytes = data.bytes
            let size = bytes.count
            contents = bytes[0..<min(size, 16)]
                .enumerated()
                .map { (index, value) in
                    Instruction(hex: value)
                }
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(contents.map{x in x.hex})
        return .init(regularFileWithContents: data)
    }
    
    func insertEmptyInstruction(after id: Instruction.ID?) -> Instruction.ID? {
        guard contents.count < 16 else {
            return nil
        }
        
        let emptyInstruction = Instruction(hex: 0)
        guard let id else {
            contents.append(emptyInstruction)
            return emptyInstruction.id
        }
        if let idIndex = contents.firstIndex(where: {$0.id == id}) {
            contents.insert(emptyInstruction, at: idIndex + 1)
        } else {
            contents.append(emptyInstruction)
        }
        return emptyInstruction.id
    }
    
    func removeInstruction(at id: Instruction.ID?) {
        guard let id else {
            contents.removeLast()
            return
        }
        guard contents.count > 1 else {
            return
        }
        if let idIndex = contents.firstIndex(where: {$0.id == id}) {
            contents.remove(at: idIndex)
        } else {
            contents.removeLast()
        }
    }
}
