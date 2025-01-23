//
//  TD4_EmulatorApp.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 23/01/2025.
//

import SwiftUI

@main
struct TD4_EmulatorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TD4_EmulatorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
