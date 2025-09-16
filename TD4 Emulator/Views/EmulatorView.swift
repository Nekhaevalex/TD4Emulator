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
    @State private var runButtonTint: Color = .green
    
    @State private var stepButtonPopoverIsPresented: Bool = false
    @State private var stepButtonPopoverText: String = ""
    
    @State private var runButtonPopoverIsPresented: Bool = false
    @State private var runButtonPopoverText: String = ""
    
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
                            runButtonTint = .red
                            cpu.run() {error in
                                guard let error else {
                                    return
                                }
                                runButtonPopoverIsPresented.toggle()
                                running.toggle()
                                runButtonPopoverText = error.description
                                runButtonText = "Run"
                                runButtonImage = "play"
                                runButtonTint = .green
                            }
                        } else {
                            runButtonText = "Run"
                            runButtonImage = "play"
                            runButtonTint = .green
                            cpu.stop()
                        }
                    }
                    .popover(isPresented: $runButtonPopoverIsPresented) {
                        Text(runButtonPopoverText)
                            .padding()
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .tint(runButtonTint)
                    
                    Button("Step", systemImage: "arrow.turn.down.right") {
                        do throws(TD4CpuError) {
                            try cpu.step()
                        } catch {
                            stepButtonPopoverText = error.description
                            stepButtonPopoverIsPresented.toggle()
                        }
                    }
                    .disabled(running)
                    .popover(isPresented: $stepButtonPopoverIsPresented) {
                        Text(stepButtonPopoverText)
                            .padding()
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    
                    Button("Reset", systemImage: "restart.circle") {
                        cpu.reset()
                    }
                    .disabled(running)
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
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
