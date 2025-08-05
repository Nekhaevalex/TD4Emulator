//
//  Misc.swift
//  TD4 Emulator
//
//  Created by Alexander Nekhaev on 24/01/2025.
//

import Foundation
import SwiftUI

/// Monospace font used for displaying text in views.
let monospaceFont = Font
    .system(size: 12)
    .monospaced()

/// Formatter for displaying and parsing hexadecimal numbers as two-digit uppercase strings.
class HexNumberFormatter: Formatter {
    /// Converts a UInt8 value to a two-digit uppercase hexadecimal string.
    /// - Parameter obj: The object to format (expects UInt8).
    /// - Returns: Hexadecimal string representation or nil if conversion fails.
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? UInt8 else { return nil }
        return String(format: "%02X", number)
    }
    
    /// Parses a hexadecimal string into a UInt8 value.
    /// - Parameters:
    ///   - obj: Pointer to store the parsed value.
    ///   - string: The string to parse.
    ///   - error: Pointer to store error description if parsing fails.
    /// - Returns: True if parsing succeeds, false otherwise.
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard let value = UInt8(string, radix: 16) else {
            error?.pointee = "Invalid hexadecimal value" as NSString
            return false
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    /// Validates that a partial string contains only valid hexadecimal characters.
    /// - Parameters:
    ///   - partialString: The string being edited.
    ///   - newString: Pointer to store the new editing string.
    ///   - error: Pointer to store error description if validation fails.
    /// - Returns: True if the string is valid or empty, false otherwise.
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        return partialString.isEmpty || partialString.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}

/// Formatter for displaying and parsing binary numbers as 8-digit strings.
class BinNumberFormatter: Formatter {
    /// Converts a UInt8 value to an 8-digit binary string, padded with leading zeroes.
    /// - Parameter obj: The object to format (expects UInt8).
    /// - Returns: Binary string representation or nil if conversion fails.
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? UInt8 else { return nil }
        let formatted = String(number, radix: 2)
        let zeroes: [Character] = Array(repeating: "0", count: 8 - formatted.count)
        return String(zeroes) + formatted
    }
    
    /// Parses an 8-digit binary string into a UInt8 value.
    /// - Parameters:
    ///   - obj: Pointer to store the parsed value.
    ///   - string: The string to parse.
    ///   - error: Pointer to store error description if parsing fails.
    /// - Returns: True if parsing succeeds, false otherwise.
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard let value = UInt8(string, radix: 2) else {
            error?.pointee = "Invalid binary value" as NSString
            return false
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    /// Validates that a partial string contains only valid binary characters (0 or 1).
    /// - Parameters:
    ///   - partialString: The string being edited.
    ///   - newString: Pointer to store the new editing string.
    ///   - error: Pointer to store error description if validation fails.
    /// - Returns: True if the string is valid or empty, false otherwise.
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "01")
        return partialString.isEmpty || partialString.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}
