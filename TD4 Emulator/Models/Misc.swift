//
//  Misc.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import Foundation
import SwiftUI

// Monospace font for views
let myFont = Font
    .system(size: 12)
    .monospaced()

// Custom hex number formatter
class HexNumberFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? UInt8 else { return nil }
        return String(format: "%02X", number)
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard let value = UInt8(string, radix: 16) else {
            error?.pointee = "Invalid hexadecimal value" as NSString
            return false
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        return partialString.isEmpty || partialString.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}

// Custom bin number formatter
class BinNumberFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? UInt8 else { return nil }
        return String(number, radix: 2)
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard let value = UInt8(string, radix: 2) else {
            error?.pointee = "Invalid binary value" as NSString
            return false
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "01")
        return partialString.isEmpty || partialString.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}
