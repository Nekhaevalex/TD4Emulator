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

struct TD4BinaryFile: FileDocument {
    var text: [UInt8]

    init(text: [UInt8] = Array(repeating: 0, count: 16)) {
        if text.count == 16 {
            self.text = text
        } else if text.count < 16{
            self.text = Array(repeating: 0, count: 16)
            for i in 0..<text.count {
                self.text[i] = UInt8(text[i])
            }
        } else {
            self.text = Array(text[0..<16])
        }
    }

    static var readableContentTypes: [UTType] { [.td4Binary] }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let text = data.bytes
            if text.count < 16 {
                self.text = Array(repeating: 0, count: 16)
                for i in 0..<text.count {
                    self.text[i] = UInt8(text[i])
                }
            } else {
                self.text = Array(text[0..<16])
            }
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text)
        return .init(regularFileWithContents: data)
    }
}
