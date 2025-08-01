//
//  RegisterView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

struct RegisterView: View {
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
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        HStack {
                            Text("B")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Register B Value", value: $cpu.regB, formatter: HexNumberFormatter())
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
                .font(myFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("I/O Registers")) {
                Group {
                    HStack {
                        HStack {
                            Text("In")
                                .fixedSize(horizontal: true, vertical: true)
                                .font(myFont)
                            TextField("Input value", value: $cpu.regIn, formatter: HexNumberFormatter())
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        HStack {
                            Text("Out")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Output value", value: $cpu.regOut, formatter: HexNumberFormatter())
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
                .font(myFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("Special Registers")) {
                Group {
                    HStack {
                        HStack {
                            Text("PC")
                                .fixedSize(horizontal: true, vertical: true)
                            TextField("Program Counter Value", value: $cpu.programCounter, formatter: HexNumberFormatter())
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
                .font(myFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu: TD4CPU = .init()
    RegisterView(cpu: cpu)
}
