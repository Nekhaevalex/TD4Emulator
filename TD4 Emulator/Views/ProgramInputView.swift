//
//  ProgramInputView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 25/01/2025.
//

import SwiftUI

struct ProgramInputView: View {
    @Binding var value: UInt8
    var body: some View {
        GroupBox("Program Input") {
            HStack{
                Text("Dec:")
                    .frame(width: 30, alignment: .leading)
                TextField("Instruction decimal", value: $value, formatter: NumberFormatter())
            }
            HStack{
                Text("Hex:")
                    .frame(width: 30, alignment: .leading)
                TextField("Instruction hex", value: $value, formatter: HexNumberFormatter())
            }
            HStack{
                Text("Bin:")
                    .frame(width: 30, alignment: .leading)
                TextField("Instruction hex", value: $value, formatter: BinNumberFormatter())
            }
        }
        .font(myFont)
    }
}

#Preview {
    @Previewable @State var value: UInt8 = 0x00
    ProgramInputView(value: $value)
}
