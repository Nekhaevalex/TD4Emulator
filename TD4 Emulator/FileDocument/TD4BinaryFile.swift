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

struct TD4BinaryFile: FileDocument {
    static var readableContentTypes: [UTType] { [.td4Binary] }
    var contents: [Instruction]

    init(text: [UInt8] = Array(repeating: 0, count: 16)) {
        let size = text.count
        self.contents = text[0..<min(size, 16)]
            .enumerated()
            .map { (index, value) in
                Instruction(index: UInt8(index), hex: value)
            }
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let bytes = data.bytes
            let size = bytes.count
            contents = bytes[0..<min(size, 16)]
                .enumerated()
                .map { (index, value) in
                    Instruction(index: UInt8(index), hex: value)
                }
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(contents.map{x in x.hex})
        return .init(regularFileWithContents: data)
    }
    
    var asArray: [UInt8] {
        contents.map{$0.hex}
    }
}
