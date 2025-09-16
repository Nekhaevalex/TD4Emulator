//
//  TD4_EmulatorDocument.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI
import UniformTypeIdentifiers


/// Extension to define a custom Uniform Type Identifier for TD4 binary files.
extension UTType {
    /// The custom UTType for TD4 binary files.
    static var td4Binary: UTType {
        UTType(exportedAs: "com.example.td4bin")
    }
    static var td4Text: UTType {
        UTType(exportedAs: "com.example.s")
    }
}


/// Extension to convert Data to an array of UInt8 bytes.
extension Data {
    /// Returns the contents of Data as an array of UInt8 bytes.
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}


/// Represents a TD4 binary file, supporting reading, writing, and manipulation of instructions.
@Observable
class TD4BinaryFile: FileDocument {
    /// The supported content types for TD4 binary files.
    static var readableContentTypes: [UTType] { [.td4Binary] }

    /// The array of instructions contained in the file.
    var contents: [Instruction]

    /// Returns the instructions as an array of raw UInt8 values.
    var asArray: [UInt8] {
        contents.map { $0.hex }
    }

    /// Initializes a TD4BinaryFile with an array of bytes.
    /// - Parameter text: The array of instruction bytes (max 16).
    init(text: [UInt8] = Array(repeating: 0, count: 1)) {
        let size = text.count
        self.contents = text[0..<min(size, 16)]
            .enumerated()
            .map { (index, value) in
                Instruction(hex: value)
            }
    }

    /// Initializes a TD4BinaryFile from a file document configuration.
    /// - Parameter configuration: The file read configuration.
    /// - Throws: CocoaError if the file is corrupt or unreadable.
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

    /// Converts the instructions to a file wrapper for saving.
    /// - Parameter configuration: The file write configuration.
    /// - Returns: A FileWrapper containing the binary data.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(contents.map { x in x.hex })
        return .init(regularFileWithContents: data)
    }

    /// Inserts an empty instruction (NOP) after the given instruction ID.
    /// - Parameter id: The ID after which to insert, or nil to append.
    /// - Returns: The ID of the newly inserted instruction, or nil if full.
    func insertEmptyInstruction(after id: Instruction.ID?) -> Instruction.ID? {
        guard contents.count < 16 else {
            return nil
        }

        let emptyInstruction = Instruction(hex: 0)
        guard let id else {
            contents.append(emptyInstruction)
            return emptyInstruction.id
        }
        if let idIndex = contents.firstIndex(where: { $0.id == id }) {
            contents.insert(emptyInstruction, at: idIndex + 1)
        } else {
            contents.append(emptyInstruction)
        }
        return emptyInstruction.id
    }

    /// Removes the instruction at the given ID, or the last instruction if ID is nil.
    /// - Parameter id: The ID of the instruction to remove, or nil to remove last.
    func removeInstruction(at id: Instruction.ID?) {
        guard let id else {
            contents.removeLast()
            return
        }
        guard contents.count > 1 else {
            return
        }
        if let idIndex = contents.firstIndex(where: { $0.id == id }) {
            contents.remove(at: idIndex)
        } else {
            contents.removeLast()
        }
    }
}
