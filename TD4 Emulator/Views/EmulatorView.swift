//
//  ContentView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI

struct EmulatorView: View {
    @Binding var document: TD4BinaryFile
    @StateObject private var cpu: TD4CPU
    @State private var error: Error?
    
    init(document: Binding<TD4BinaryFile>) {
        _document = document
        _cpu = StateObject(wrappedValue: TD4CPU(document.wrappedValue.text))
    }
    
    var body: some View {
        HStack {
            VStack {
                // Registers
                RegisterView(cpu: cpu)
                Divider()
                ProgramInputView(value: $cpu.rom[Int(cpu.programCounter)])
                // CPU Controls
                HStack {
                    Button("Step") {
                        do {
                            try cpu.step()
                        } catch {
                            self.error = error
                        }
                    }
                    Button("Reset") {
                        cpu.reset()
                    }
                }
                Spacer()
            }
            // Program listing
            HexEditorView(cpu: cpu)
        }
    }
}

#Preview {
    @Previewable @State var document = TD4BinaryFile(text: [64, 144, 17, 224, 244])
    EmulatorView(document: $document)
}
