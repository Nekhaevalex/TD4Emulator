//
//  RegisterView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

/// SwiftUI view of current CPU registers state
struct RegisterView: View {
    /// Binded TD4 CPU instance
    @State var cpu: TD4CPU
    
    var body: some View {
        VStack {
            GroupBox(label: Text("General Purpose Registers")) {
                Group {
                    HStack {
                        HStack {
                            Text("A")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Register A Value", value: $cpu.regA, formatter: HexNumberFormatter())
                                .frame(width: 25, alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        HStack {
                            Text("B")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Register B Value", value: $cpu.regB, formatter: HexNumberFormatter())
                                .frame(width: 25, alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
                .font(monospaceFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("I/O Registers")) {
                Group {
                    HStack {
                        HStack {
                            Text("In")
                                .fixedSize(horizontal: true, vertical: true)
                                .font(monospaceFont)
                            TextField("Input value", value: $cpu.regIn, formatter: HexNumberFormatter())
                                .frame(width: 25, alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        HStack {
                            Text("Out")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Output value", value: $cpu.regOut, formatter: HexNumberFormatter())
                                .frame(width: 25, alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
                .font(monospaceFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("Special Registers")) {
                Group {
                    HStack {
                        HStack {
                            Text("PC")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Program Counter Value", value: $cpu.programCounter, formatter: HexNumberFormatter())
                                .frame(width: 25, alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        Toggle(isOn: $cpu.carryFlag) {
                            Text("CF")
                        }
#if os(macOS)
                        .toggleStyle(CheckboxToggleStyle())
#endif
                    }
                }
                .font(monospaceFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu: TD4CPU = .init()
    RegisterView(cpu: cpu)
}
