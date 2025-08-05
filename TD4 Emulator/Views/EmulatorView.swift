//
//  ContentView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI

/// SwiftUI view of main window 
struct EmulatorView: View {
    /// Binded TD4 binary file instance
    @Binding var document: TD4BinaryFile
    @State private var cpu: TD4CPU
    
    @State private var running = false
    @State private var runButtonText = "Run"
    @State private var runButtonImage = "play"
    
    /// Initializes the view with specified TD4BinaryFile
    /// - Parameter document: binding of TD4BinaryFile
    init(document: Binding<TD4BinaryFile>) {
        _document = document
        _cpu = State(wrappedValue: TD4CPU(document.wrappedValue))
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
                    Button(runButtonText, systemImage: runButtonImage) {
                        running.toggle()
                        if running {
                            runButtonText = "Stop"
                            runButtonImage = "stop"
                            cpu.run()
                        } else {
                            runButtonText = "Run"
                            runButtonImage = "play"
                            cpu.stop()
                        }
                    }
                    
                    Button("Step", systemImage: "arrow.turn.down.right") {
                        do {
                            try cpu.step()
                        } catch {
                            
                        }
                    }
                    .disabled(running)
                    
                    Button("Reset", systemImage: "restart.circle") {
                        cpu.reset()
                    }
                    .disabled(running)
                }
                Spacer()
            }
            .padding(5)
            .frame(width: 240)
            // Program listing
            HexEditorView(cpu: $cpu)
        }
        .frame(minWidth: 500)
    }
}

#Preview {
    @Previewable @State var document = TD4BinaryFile(text: [64, 144, 17, 224, 244])
    EmulatorView(document: $document)
}
