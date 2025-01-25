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
            TextField("Instruction Hex", value: $value, formatter: HexNumberFormatter())
        }
    }
}

#Preview {
    @Previewable @State var value: UInt8 = 0x00
    ProgramInputView(value: $value)
}
