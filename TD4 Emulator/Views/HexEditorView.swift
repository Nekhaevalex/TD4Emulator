//
//  HexEditorView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

struct HexEditorView: View {
    @ObservedObject var cpu: TD4CPU
    
    var body: some View {
        GroupBox("ROM") {
            ScrollView {
                LazyVStack {
                    ForEach(cpu.rom.indices, id: \.self) { index in
                        HStack {
                            Text(String(format: "%04X", index))
                            Text(String(format: "0x%02X", cpu.rom[Int(index)]))
                            Text(instructionToString(cpu.rom[Int(index)]))
                        }
                        .onTapGesture {
                            cpu.programCounter = UInt8(index)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(myFont)
                        .foregroundStyle(index == cpu.programCounter ? Color.white : Color.primary)
                        .background(index == cpu.programCounter ? Color.blue : Color.clear)
                        .bold(index == cpu.programCounter)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu = TD4CPU([64, 144, 17, 224, 244])
    HexEditorView(cpu: cpu)
}
