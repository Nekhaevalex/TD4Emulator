//
//  RegisterView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var cpu: TD4CPU
    
    var body: some View {
        VStack {
            GroupBox(label: Text("General Purpose Registers")) {
                Group {
                    VStack {
                        HStack {
                            Text("A")
                                .frame(width: 50)
                            TextField("Register A Value", value: $cpu.regA, formatter: HexNumberFormatter())
                        }
                        HStack {
                            Text("B")
                                .frame(width: 50)
                            TextField("Register B Value", value: $cpu.regB, formatter: HexNumberFormatter())
                        }
                    }
                }
                .font(myFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("I/O Registers")) {
                Group {
                    VStack {
                        HStack {
                            Text("In")
                                .frame(width: 50)
                                .font(myFont)
                            TextField("Input value", value: $cpu.regIn, formatter: HexNumberFormatter())
                        }
                        HStack {
                            Text("Out")
                                .frame(width: 50)
                            TextField("Output value", value: $cpu.regOut, formatter: HexNumberFormatter())
                        }
                    }
                }
                .font(myFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Text("Special Registers")) {
                Group {
                    VStack {
                        HStack {
                            Text("PC")
                                .frame(width: 50)
                            TextField("Program Counter Value", value: $cpu.programCounter, formatter: HexNumberFormatter())
                        }
                        Toggle(isOn: $cpu.carryFlag) {
                            Text("CF")
                        }
                        .toggleStyle(CheckboxToggleStyle())
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
