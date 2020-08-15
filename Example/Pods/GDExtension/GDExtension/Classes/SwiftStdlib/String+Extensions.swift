//
//  String+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Foundation)
import Foundation
#endif
#if canImport(CommonCrypto)
import CommonCrypto
#endif
#if canImport(UIKit)
import UIKit

#endif

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - Properties
public extension String {

    #if canImport(Foundation)
    /// GDExtension: String decoded from base64 (if applicable).
    ///
    ///		"SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: String encoded in base64 (if applicable).
    ///
    ///		"Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
   
    #endif
    
    /// GDExtension: return the md5 string
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    /// aes256 encrypt
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String
    func aes256Encrypt(key: String?, iv: String?) -> String? {
        let contentData = self.data(using: .utf8)
        let keyData = key?.data(using: .utf8)
        let encrptedData = contentData?.aes256Encrypt(keyData: keyData, iv: iv)
        
        return encrptedData?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    /// aes256 decrypt
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String?
    func aes256Decrypt(key: String?, iv: String?) -> String? {
        let contentData = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        let keyData = key?.data(using: .utf8)
        
        if let decryptedData = contentData?.aes256Decrypt(keyData: keyData, iv: iv) {
            return String.init(data: decryptedData, encoding: .utf8)
        }
        return nil
    }
    
    /// GDExtension: Array of characters of a string.
    var charactersArray: [Character] {
        return Array(self)
    }

    #if canImport(Foundation)
    /// GDExtension: CamelCase of string.
    ///
    ///		"sOme vAriable naMe".camelCased -> "someVariableName"
    ///
    var camelCased: String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    #endif

    /// GDExtension: Check if string contains one or more emojis.
    ///
    ///		"Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// GDExtension: First character of string (if applicable).
    ///
    ///		"Hello".firstCharacterAsString -> Optional("H")
    ///		"".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    /// GDExtension: Check if string contains one or more letters.
    ///
    ///		"123abc".hasLetters -> true
    ///		"123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// GDExtension: Check if string contains one or more numbers.
    ///
    ///		"abcd".hasNumbers -> false
    ///		"123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// GDExtension: Check if string contains only letters.
    ///
    ///		"abc".isAlphabetic -> true
    ///		"123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// GDExtension: Check if string contains at least one letter and one number.
    ///
    ///		// useful for passwords
    ///		"123abc".isAlphaNumeric -> true
    ///		"abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    #if canImport(Foundation)
    /// GDExtension: Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///		"john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid URL.
    ///
    ///		"https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid schemed URL.
    ///
    ///		"https://google.com".isValidSchemedUrl -> true
    ///		"google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid https URL.
    ///
    ///		"https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid http URL.
    ///
    ///		"http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid file URL.
    ///
    ///		"file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string is a valid Swift number.
    ///
    /// Note:
    /// In North America, "." is the decimal separator,
    /// while in many parts of Europe "," is used,
    ///
    ///		"123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///		"abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if string only contains digits.
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    #endif

    /// GDExtension: Last character of string (if applicable).
    ///
    ///		"Hello".lastCharacterAsString -> Optional("o")
    ///		"".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }

    #if canImport(Foundation)
    /// GDExtension: Latinized string.
    ///
    ///		"Hèllö Wórld!".latinized -> "Hello World!"
    ///
    var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Bool value from string (if applicable).
    ///
    ///		"1".bool -> true
    ///		"False".bool -> false
    ///		"Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Date object from "yyyy-MM-dd" formatted string.
    ///
    ///		"2007-06-29".date -> Optional(Date)
    ///
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///		"2007-06-29 14:23:09".dateTime -> Optional(Date)
    ///
    var dateTime: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    #endif

    /// GDExtension: Integer value from string (if applicable).
    ///
    ///		"101".int -> 101
    ///
    var int: Int? {
        return Int(self)
    }
    
    /// Gets the individual characters and puts them in an array as Strings.
    var array: [String] {
        return description.map { String($0) }
    }
    
    /// Returns the Float value
    var floatValue: Float {
        return NSString(string: self).floatValue
    }
    
    /// Returns the Int value
    var intValue: Int {
        return Int(NSString(string: self).intValue)
    }
    
    /// Creates a substring to the given character.
    ///
    /// - Parameter character: The character.
    /// - Returns: Returns the substring to character.
    func substring(to character: Character) -> String {
        let index: Int = self.index(of: character)
        guard index > -1 else {
            return ""
        }
        return substring(to: index)
    }
    
    /// Creates a substring with a given range.
    ///
    /// - Parameter range: The range.
    /// - Returns: Returns the string between the range.
    func substring(with range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        
        return String(self[start..<end])
    }
    
    /// Convert a String to a NSAttributedString.
    /// With that variable you can customize a String with a style.
    ///
    /// Example:
    ///
    ///     string.attributedString.font(UIFont(fontName: .helveticaNeue, size: 20))
    ///
    /// You can even concatenate two or more styles:
    ///
    ///     string.attributedString.font(UIFont(fontName: .helveticaNeue, size: 20)).backgroundColor(UIColor.red)
    var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// Returns the index of the given character.
    ///
    /// - Parameter character: The character to search.
    /// - Returns: Returns the index of the given character, -1 if not found.
    func index(of character: Character) -> Int {
        guard let index: Index = firstIndex(of: character) else {
            return -1
        }
        
        return distance(from: startIndex, to: index)
    }
    
    func substring(to index: Int) -> String {
        guard index <= count else {
            return ""
        }
        return String(self[..<self.index(startIndex, offsetBy: index)])
    }
    
    
    /// GDExtension: Lorem ipsum string of given length.
    ///
    /// - Parameter length: number of characters to limit lorem ipsum to (default is 445 - full lorem ipsum).
    /// - Returns: Lorem ipsum dolor sit amet... string.
    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://gaodun.com/
        let loremIpsum = """
		Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		"""
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    #if canImport(Foundation)
    /// GDExtension: URL from string (if applicable).
    ///
    ///		"https://gaodun.com".url -> URL(string: "https://gaodun.com")
    ///		"not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: String with no spaces or new lines in beginning and end.
    ///
    ///		"   hello  \n".trimmed -> "hello"
    ///
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Readable string from a URL string.
    ///
    ///		"it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: URL escaped string.
    ///
    ///		"it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: String without spaces and new lines.
    ///
    ///		"   \n GDExtension   \n  GDExtension  ".replaceSpacesAndNewLines -> "GDUtilsGDExtension"
    ///
    var replaceSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Check if the given string contains only white spaces
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// GDExtension: Check if the given string spelled correctly
    var isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)

        let misspelledRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: Locale.preferredLanguages.first ?? "en")
        return misspelledRange.location == NSNotFound
    }
    #endif

}

// MARK: - Methods
public extension String {

    #if canImport(Foundation)
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    #endif

    #if canImport(Foundation)
    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    #endif

    #if canImport(CoreGraphics) && canImport(Foundation)
    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Array of strings separated by new lines.
    ///
    ///		"Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns: Strings separated by new lines.
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    #endif

    /// GDExtension: The most common character in string.
    ///
    ///		"This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns: The most common character.
    func mostCommonCharacter() -> Character? {
        let mostCommon = replaceSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key

        return mostCommon
    }

    /// GDExtension: Array with unicodes for all characters in a string.
    ///
    ///		"GDExtension".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: The unicodes for all characters in a string.
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }

    #if canImport(Foundation)
    /// GDExtension: an array of all words in a string
    ///
    ///		"Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Count of words in a string.
    ///
    ///		"Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Transforms the string into a slug string.
    ///
    ///        "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: The string in slug format.
    func toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }
    #endif

    /// GDExtension: Safely subscript string with index.
    ///
    ///		"Hello World!"[safe: 3] -> "l"
    ///		"Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// GDExtension: Safely subscript string within a half-open range.
    ///
    ///		"Hello World!"[safe: 6..<11] -> "World"
    ///		"Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }

    /// GDExtension: Safely subscript string within a closed range.
    ///
    ///		"Hello World!"[safe: 6...11] -> "World!"
    ///		"Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex...upperIndex])
    }

    #if os(iOS) || os(macOS)
    /// GDExtension: Copy string to global pasteboard.
    ///
    ///		"SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
    #endif

    /// GDExtension: Converts string format to CamelCase.
    ///
    ///		var str = "sOme vaRiabLe Name"
    ///		str.camelize()
    ///		print(str) // prints "someVariableName"
    ///
    @discardableResult
    mutating func camelize() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            self = first + rest
            return self
        }
        let rest = String(source.dropFirst())

        self = first + rest
        return self
    }

    /// GDExtension: First character of string uppercased(if applicable) while keeping the original string.
    ///
    ///        "hello world".firstCharacterUppercased() -> "Hello world"
    ///        "".firstCharacterUppercased() -> ""
    ///
    mutating func firstCharacterUppercased() {
        guard let first = first else { return }
        self = String(first).uppercased() + dropFirst()
    }

    /// GDExtension: Check if string contains only unique characters.
    ///
    func hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    #if canImport(Foundation)
    /// GDExtension: Check if string contains one or more instance of substring.
    ///
    ///		"Hello World!".contains("O") -> false
    ///		"Hello World!".contains("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Count of substring in string.
    ///
    ///		"Hello World!".count(of: "o") -> 2
    ///		"Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    #endif

    /// GDExtension: Check if string ends with substring.
    ///
    ///		"Hello World!".ends(with: "!") -> true
    ///		"Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }

    #if canImport(Foundation)
    /// GDExtension: Latinize string.
    ///
    ///		var str = "Hèllö Wórld!"
    ///		str.latinize()
    ///		print(str) // prints "Hello World!"
    ///
    @discardableResult
    mutating func latinize() -> String {
        self = folding(options: .diacriticInsensitive, locale: Locale.current)
        return self
    }
    #endif

    /// GDExtension: Random string of given length.
    ///
    ///		String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    /// GDExtension: Reverse string.
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// GDExtension: Sliced string from a start index with length.
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count  else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index..<count]
        }
        guard length > 0 else { return "" }
        return self[safe: index..<index.advanced(by: length)]
    }

    /// GDExtension: Slice given string from a start index with length (if applicable).
    ///
    ///		var str = "Hello World"
    ///		str.slice(from: 6, length: 5)
    ///		print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }

    /// GDExtension: Slice given string from a start index to an end index (if applicable).
    ///
    ///		var str = "Hello World"
    ///		str.slice(from: 6, to: 11)
    ///		print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return self }
        if let str = self[safe: start..<end] {
            self = str
        }
        return self
    }

    /// GDExtension: Slice given string from a start index (if applicable).
    ///
    ///		var str = "Hello World"
    ///		str.slice(at: 6)
    ///		print(str) // prints "World"
    ///
    /// - Parameter index: string index the slicing should start from.
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < count else { return self }
        if let str = self[safe: index..<count] {
            self = str
        }
        return self
    }

    /// GDExtension: Check if string starts with substring.
    ///
    ///		"hello World".starts(with: "h") -> true
    ///		"hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    #if canImport(Foundation)
    /// GDExtension: Date object from string of date format.
    ///
    ///		"2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///		"not date string".date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Removes spaces and new lines in beginning and end of string.
    ///
    ///		var str = "  \n Hello World \n\n\n"
    ///		str.trim()
    ///		print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }
    #endif

    /// GDExtension: Truncate string (cut it to a given number of characters).
    ///
    ///		var str = "This is a very long sentence"
    ///		str.truncate(toLength: 14)
    ///		print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// GDExtension: Truncated string (limited to a given number of characters).
    ///
    ///		"This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///		"Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 1..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    #if canImport(Foundation)
    /// GDExtension: Convert URL string to readable string.
    ///
    ///		var str = "it's%20easy%20to%20decode%20strings"
    ///		str.urlDecode()
    ///		print(str) // prints "it's easy to decode strings"
    ///
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
        return self
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Escape string.
    ///
    ///		var str = "it's easy to encode strings"
    ///		str.urlEncode()
    ///		print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif

    /// GDExtension: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padStart(10) -> "       hue"
    ///   "hue".padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        self = paddingStart(length, with: string)
        return self
    }

    /// GDExtension: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// GDExtension: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        self = paddingEnd(length, with: string)
        return self
    }

    /// GDExtension: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// GDExtension: Removes given prefix from the string.
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// GDExtension: Removes given suffix from the string.
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// math the text size
    ///
    /// - Parameters:
    ///   - width: width of text
    ///   - lineSpacing: lineSpacing of text
    ///   - font: font of text
    /// - Returns: size for text
    func actualSize(width: CGFloat = UIScreen.gd.screenWidth, lineSpacing: CGFloat = 0, font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGSize {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = lineSpacing
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        
        let dict = [NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: paraStyle,
                    NSAttributedString.Key.kern: 0] as [NSAttributedString.Key: Any]
        let size = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        
        let actualSize = (self as NSString).boundingRect(with: size,
                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                         attributes: dict,
                                                         context: nil).size
        return actualSize
        
    }
    
    /// math the text height
    ///
    /// - Parameters:
    ///   - font: font of text
    ///   - width: width of text
    /// - Returns: height for text
    func actualNormalHeght(strFont: UIFont, width: CGFloat) -> CGFloat {
        
        let strSize = (self as NSString).boundingRect(with: CGSize(width: width,
                                                                   height: CGFloat.greatestFiniteMagnitude),
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      attributes: [NSAttributedString.Key.font: strFont],
                                                      context: nil).size
        return strSize.height
    }
    
    /// substring with range
    ///
    /// - Parameters:
    ///   - integerRange: range to whant to substring
    /// - Returns: result of string with sub
    subscript(integerRange: Range<Int>) -> String {
        guard self.count > integerRange.lowerBound,
            self.count >= integerRange.upperBound else { return self }
        guard integerRange.upperBound > integerRange.lowerBound else { return self }
        
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    /// integerClosedRange
    ///
    /// - Parameter integerClosedRange: integerClosedRange
    subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }
    
    /// attributedSubString string with subString
    ///
    /// - Parameters:
    ///   - subString:
    ///   - font:
    ///   - color: 
    /// - Returns: result of string with sub
    func setup(attributedSubString subString: String?,
               font: UIFont? = nil,
               color: UIColor? = nil) -> NSMutableAttributedString? {
        
        guard let subString = subString else { return nil }
        let range = (self as NSString).range(of: subString)
        guard range.location != NSNotFound else { return nil }
        
        let attributedString = NSMutableAttributedString(string: self)
        if let font = font {
            attributedString.addAttributes([NSAttributedString.Key.font: font], range: range)
        }
        if let color = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        }
        return attributedString
    }
    
    /// attributedSubString
    ///
    /// - Parameters:
    ///   - subString: 要设置副文本属性的文字数组
    ///   - attributKV: 要设置副属性的key/value
    /// - Returns: NSMutableAttributedString
    func attributedSubString(subString: [String]?,
                             attributKV: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        guard let subString = subString else { return nil }
        var rangeArray = [NSRange]()
        
        subString.forEach { (item) in
            if let range = findSubString(subString: item) {
                rangeArray += range
            }
        }
        return attributedWithRange(ranges: rangeArray, attributKV: attributKV)
    }
    
    /// attributedWithRange
    ///
    /// - Parameters:
    ///   - ranges: 要设置副文本属性的NSRange数组
    ///   - attributKV: 要设置副属性的key/value
    /// - Returns: NSMutableAttributedString
    func attributedWithRange(ranges: [NSRange]?,
                             attributKV: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        guard let rangeArray = ranges else { return nil }
        let attrText = NSMutableAttributedString(string: self)
        for range in rangeArray {
            attributKV.forEach { (key, value) in
                attrText.addAttribute(key, value: value, range: range)
            }
        }
        return attrText
    }
    
    /// findSubString
    ///
    /// - Parameter subString: 查找字符串出现的range
    /// - Returns: 如果重复出现，返回所有range
    func findSubString(subString: String?) -> [NSRange]? {
        guard let subString = subString else { return nil }
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString,
                                                 options: NSString.CompareOptions.literal,
                                                 range: NSRange(location: start,
                                                                length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        return ranges
    }
    
    /// set userdefault value for self
    func setUserDefaultsValue(value:Any?) {
        UserDefaults.standard.set(value, forKey: self)
    }
    
    /// get userdefault value for self
    func getUserDefaultsValue() -> Any? {
        return UserDefaults.standard.object(forKey: self)
    }
    
    /// remoe UserDefaults value
    func removeUserDefaultsValue() {
        return UserDefaults.standard.removeObject(forKey: self)
    }
    
    /// add http to given string
    func httpStyle() -> String {
        if self.hasPrefix("http") || self.hasPrefix("file://") {
            return self
        } else if self.hasPrefix("//") {
            return "https:\(self)"
        } else {
            return "https://\(self)"
        }
    }
    
    ///to dic for given string
    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let dict = jsonObject as? [String: Any] else { return nil }
        return dict
    }
    
    ///to decimal String
    func toDecimalString(minimumFractionDigits:Int = 0,maximumFractionDigits:Int = 2) -> String {
        guard !isEmpty else { return "" }
        let decimalNumber = NSDecimalNumber.init(string: self)
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0.##"
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: decimalNumber) ?? "0"
    }
}

// MARK: - Initializers
public extension String {

    #if canImport(Foundation)
    /// GDExtension: Create a new string from a base64 string (if applicable).
    ///
    ///		String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///		String(base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    #endif

    /// GDExtension: Create a new random string of given length.
    ///
    ///		String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }

        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }

}

#if !os(Linux)

// MARK: - NSAttributedString
public extension String {

    #if canImport(UIKit)
    private typealias Font = UIFont
    #endif

    #if canImport(Cocoa)
    private typealias Font = NSFont
    #endif

    #if os(iOS) || os(macOS)
    /// GDExtension: Bold string.
    var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: Font.boldSystemFont(ofSize: Font.systemFontSize)])
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Underlined string
    var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: Strikethrough string.
    var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    #endif

    #if os(iOS)
    /// GDExtension: Italic string.
    var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    #if canImport(UIKit)
    /// GDExtension: Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    /// GDExtension: return the color for string
    ///
    /// - Returns: UIColor
    func toColor() -> UIColor {
        return UIColor.init(hex: self)
    }
    #endif

    #if canImport(Cocoa)
    /// GDExtension: Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func colored(with color: NSColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    #endif

}

#endif

// MARK: - Operators
public extension String {

    /// GDExtension: Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// GDExtension: Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }

}

#if canImport(Foundation)

// MARK: - NSString extensions
public extension String {

    /// GDExtension: NSString from a string.
    var nsString: NSString {
        return NSString(string: self)
    }

    /// GDExtension: NSString lastPathComponent.
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// GDExtension: NSString pathExtension.
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// GDExtension: NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    /// GDExtension: NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// GDExtension: NSString pathComponents.
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// GDExtension: NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// GDExtension: NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }

    /// GDExtension: timeFormat %02d:%02d:%02d or %02d:%02d
    ///
    /// - Parameter time: time
    /// - Returns: String
    static func timeFormat(withSeconds time: TimeInterval) -> String {
        let hours = Int(time)/3600
        let minutes = (Int(time) / 60) % 60
        let secs = (Int(time) % 60)
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%02d:%02d", minutes, secs)
    }
}

#endif
