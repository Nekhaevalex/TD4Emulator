//
//  HexEditorView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

/// SwiftUI view of program disassembly
struct HexEditorView: View {
    /// Binded TD4 CPU instance
    @Binding var cpu: TD4CPU
    
    fileprivate func addInstruction() {
        let newId = cpu.rom.insertEmptyInstruction(after: cpu.selected ?? nil)
        cpu.selected = newId ?? cpu.selected
    }
    
    fileprivate func removeInstruction() {
        guard let selectedIndex = cpu.selected else { return }
        
        var newIndex: Instruction.ID? = nil
        if selectedIndex == cpu.rom.contents.first?.id {
            if cpu.rom.contents.count > 1 {
                newIndex = cpu.rom.contents[1].id
            }
        } else if selectedIndex == cpu.rom.contents.last?.id {
            if cpu.rom.contents.count > 1 {
                newIndex = cpu.rom.contents[cpu.rom.contents.count - 2].id
            }
        } else {
            let index = cpu.rom.contents.firstIndex(where: {$0.id == selectedIndex})! - 1
            newIndex = cpu.rom.contents[index].id
        }
        
        cpu.rom.removeInstruction(at: cpu.selected ?? nil)
        cpu.selected = newIndex
    }
    
    var body: some View {
        VStack {
            Table(cpu.rom.contents, selection: $cpu.selected) {
                TableColumn("Address") { instruction in
                    Text(String(format: "%02X", cpu.rom.contents.firstIndex(where: {$0.id == instruction.id})!))
                        .font(monospaceFont)
                }
                .width(50)
                .alignment(.trailing)
                
                TableColumn("Hex") {instruction in
                    Text(String(format: "%02X", instruction.hex))
                        .font(monospaceFont)
                }
                .width(40)
                .alignment(.center)
                
                TableColumn("Disasm") {instruction in
                    Text(instruction.description)
                        .font(monospaceFont)
                }
            }
            .onChange(of: cpu.selected, initial: true) { prev, instruction  in
                guard let selection = instruction else {
                    cpu.programCounter = 0
                    cpu.selected = cpu.rom.contents.first?.id
                    return
                }
                let result = cpu.rom.contents.first(where: {$0.id == selection})
                if let pureInstr = result {
                    cpu.programCounter = UInt8(cpu.rom.contents.firstIndex(where: {$0.id == pureInstr.id})!)
                } else {
                    cpu.programCounter = 0
                }
            }
            .onKeyPress(keys: Set<KeyEquivalent>([
                .delete,
                .return,
                .init(Character(UnicodeScalar(127)))
            ])) { keyPress in
                switch keyPress.key {
                case .delete, .init(Character(UnicodeScalar(127))):
                    removeInstruction()
                case .return:
                    addInstruction()
                default:
                    break
                }
                return .handled
            }
            
            GlassEffectContainer(spacing: 20) {HStack {
                Spacer()
                Button {
                    addInstruction()
                    
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 10, height: 15)
                }
                .buttonStyle(.glass)
                
                Button {
                    removeInstruction()
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 10, height: 15)
                }
                .buttonStyle(.glass)
            }
            .padding()
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu = TD4CPU([64, 144, 17, 224, 244])
    HexEditorView(cpu: $cpu)
}
