//
//  HexEditorView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

struct HexEditorView: View {
    @StateObject var cpu: TD4CPU
    
    var body: some View {
        Table(cpu.rom?.contents ?? TD4BinaryFile().contents, selection: $cpu.selected) {
            TableColumn("Address") { instruction in
                Text(String(format: "%02X", instruction.index))
            }
            .width(50)
            .alignment(.trailing)
            
            TableColumn("Hex") {instruction in
                Text(String(format: "%02X", instruction.hex))
            }
            .width(40)
            .alignment(.center)
            
            TableColumn("Disasm") {instruction in
                Text(instruction.description)
                .font(myFont)
            }
        }
        .onChange(of: cpu.selected, initial: true) { prev, instruction  in
            guard let selection = instruction else {
                cpu.programCounter = 0
                cpu.selected = cpu.rom?.contents.first?.id
                return
            }
            let result = cpu.rom?.contents.first(where: {$0.id == selection})
            if let pureInstr = result {
                cpu.programCounter = UInt8(pureInstr.index)
            } else {
                cpu.programCounter = 0
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu = TD4CPU([64, 144, 17, 224, 244])
    HexEditorView(cpu: cpu)
}
