//
//  HexEditorView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import SwiftUI

struct HexEditorView: View {
    @ObservedObject var cpu: TD4CPU
    @Binding var document: TD4BinaryFile
    
    var body: some View {
        GroupBox("ROM") {
            ScrollView {
                LazyVStack {
                    ForEach(document.text.indices, id: \.self) { index in
                        HStack {
                            Text(String(format: "%02X", index))
                            Spacer().frame(width: 20)
                            Text(String(format: "%02X", document.text[Int(index)]))
                            Spacer().frame(width: 30)
                            Text(instructionToString(document.text[Int(index)]))
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            cpu.programCounter = UInt8(index)
                        }
                        .font(myFont)
                        .foregroundStyle(index == cpu.programCounter ? Color.white : Color.primary)
                        .background(index == cpu.programCounter ? Color.accentColor : (index % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear))
                        .bold(index == cpu.programCounter)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var cpu = TD4CPU([64, 144, 17, 224, 244])
    @Previewable @State var document = TD4BinaryFile(text: [64, 144, 17, 224, 244])
    HexEditorView(cpu: cpu, document: $document)
}
