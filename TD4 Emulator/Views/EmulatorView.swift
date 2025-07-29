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
    
    init(document: Binding<TD4BinaryFile>) {
        _document = document
        _cpu = StateObject(wrappedValue: TD4CPU(document.wrappedValue.asArray))
    }
    
    var body: some View {
        HStack {
            VStack {
                // Registers
                RegisterView(cpu: cpu)
                Divider()
                ProgramInputView(value: $document.contents[Int(cpu.programCounter)].hex)
                // CPU Controls
                HStack {
                    Button("Step") {
                        do {
                            try cpu.step(document)
                        } catch {
                            
                        }
                    }
                    Button("Reset") {
                        cpu.reset()
                    }
                }
                Spacer()
            }
            .padding(5)
            .frame(width: 200)
            // Program listing
            HexEditorView(cpu: cpu)
                .padding(5)
        }
        .frame(minWidth: 500)
    }
}

#Preview {
    @Previewable @State var document = TD4BinaryFile(text: [64, 144, 17, 224, 244])
    EmulatorView(document: $document)
}
