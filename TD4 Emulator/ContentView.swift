//
//  ContentView.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TD4_EmulatorDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(TD4_EmulatorDocument()))
}
