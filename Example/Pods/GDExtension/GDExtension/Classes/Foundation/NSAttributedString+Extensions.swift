//
//  NSAttributedString+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
/// Font typealias.
public typealias Font = UIFont
/// Color typealias.
public typealias Color = UIColor
#endif

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(AppKit)
import AppKit
/// Font typealias.
public typealias Font = NSFont
/// Color typealias.
public typealias Color = NSColor
#endif


// MARK: - Properties
public extension NSAttributedString {

    #if os(iOS)
    /// GDExtension: Bolded string.
    var bolded: NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    #if !os(Linux)
    /// GDExtension: Underlined string.
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    #endif

    #if os(iOS)
    /// GDExtension: Italicized string.
    var italicized: NSAttributedString {
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    #if !os(Linux)
    /// GDExtension: Struckthrough string.
    var struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    #endif

    #if !os(Linux)
    /// GDExtension: Dictionary of the attributes applied across the whole string
    var attributes: [NSAttributedString.Key: Any] {
        guard self.length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
    #endif

}

// MARK: - Methods
public extension NSAttributedString {

    #if !os(Linux)
    /// GDExtension: Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)

        return copy
    }
    #endif

    #if os(macOS)
    /// GDExtension: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: NSColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #endif

    #if canImport(UIKit)
    /// GDExtension: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #endif

    #if !os(Linux)
    /// GDExtension: Apply attributes to substrings matching a regular expression
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    func applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// GDExtension: Apply attributes to occurrences of a given string
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    func applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"

        return applying(attributes: attributes, toRangesMatching: pattern)
    }
    #endif

}

// MARK: - Operators
public extension NSAttributedString {

    /// GDExtension: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// GDExtension: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// GDExtension: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// GDExtension: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }

}


public extension NSAttributedString {
    /// UIFont or NSFont, default Helvetica(Neue) 12.
    ///
    /// - Parameters:
    ///   - font: UIFont or NSFont, default Helvetica(Neue) 12.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func font(_ font: Font, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// NSParagraphStyle, default defaultParagraphStyle
    ///
    /// - Parameters:
    ///   - paragraphStyle: NSParagraphStyle, default defaultParagraphStyle
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// UIColor or NSColor, default black.
    ///
    /// - Parameters:
    ///   - foregroundColor: UIColor or NSColor, default black.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func foregroundColor(_ foregroundColor: Color, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// UIColor or NSColor, default nil means no background.
    ///
    /// - Parameters:
    ///   - backgroundColor: UIColor or NSColor, default nil means no background.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func backgroundColor(_ backgroundColor: Color, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: backgroundColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Default true means default ligatures, false means no ligatures.
    ///
    /// - Parameters:
    ///   - ligature: Default true means default ligatures, false means no ligatures.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func ligature(_ ligature: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.ligature, value: ligature, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Amount to modify default kerning.
    /// 0 means kerning is disabled.
    ///
    /// - Parameters:
    ///   - kern: Amount to modify default kerning.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func kern(_ kern: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.kern, value: kern, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Default 0 means no strikethrough.
    ///
    /// - Parameters:
    ///   - strikethroughStyle: Default 0 means no strikethrough.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func strikethroughStyle(_ strikethroughStyle: Int, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: strikethroughStyle, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// NSUnderlineStyle.
    ///
    /// - Parameters:
    ///   - underlineStyle: NSUnderlineStyle.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func underlineStyle(_ underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: underlineStyle, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strokeColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func strokeColor(_ strokeColor: Color, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeColor, value: strokeColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// In percent of font point size, default 0 measn no stroke.
    /// Positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0).
    ///
    /// - Parameters:
    ///   - strokeWidth: In percent of font point size, default 0 measn no stroke.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func strokeWidth(_ strokeWidth: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeWidth, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    #if !os(watchOS)
    /// NSShadow, default nil means no shadow.
    ///
    /// - Parameters:
    ///   - shadow: NSShadow, default nil means no shadow.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func shadow(_ shadow: NSShadow, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.shadow, value: shadow, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    #endif
    
    /// Default nil means no text effect.
    ///
    /// - Parameters:
    ///   - textEffect: Default is nil means no text effect. Currently, only NSTextEffectLetterpressStyle can be used.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func textEffect(_ textEffect: String, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.textEffect, value: textEffect, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    #if !os(watchOS)
    /// NSTextAttachment, default is nil.
    ///
    /// - Parameters:
    ///   - attachment: NSTextAttachment, default is nil.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func attachment(_ attachment: NSTextAttachment, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.attachment, value: attachment, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    #endif
    
    /// NSURL.
    ///
    /// - Parameters:
    ///   - link: NSURL.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func link(_ link: NSURL, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.link, value: link, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Offset from baseline, default is 0.
    ///
    /// - Parameters:
    ///   - baselineOffset: Offset from baseline, default is 0.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func baselineOffset(_ baselineOffset: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - underlineColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func underlineColor(_ underlineColor: Color, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strikethroughColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func strikethroughColor(_ strikethroughColor: Color, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: strikethroughColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Skew to be applied to glyphs, default 0 means no skew.
    ///
    /// - Parameters:
    ///   - obliqueness: Skew to be applied to glyphs, default 0 means no skew.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func obliqueness(_ obliqueness: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.obliqueness, value: obliqueness, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///
    /// - Parameters:
    ///   - expansion: Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func expansion(_ expansion: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.expansion, value: expansion, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    /// The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.
    /// Remeber to use `.rawValue`, because the attribute wants an Int.
    /// - LRE: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.embedding.
    /// - RLE: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.embedding.
    /// - LRO: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.override.
    /// - RLO: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.override.
    ///
    /// - Parameters:
    ///   - writingDirection: Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func writingDirection(_ writingDirection: [Int], range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.writingDirection, value: writingDirection, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// The value 0 indicates horizontal text, the value 1 indicates vertical text.
    /// In iOS, horizontal text is always used and specifying a different value is undefined.
    ///
    /// - Parameters:
    ///   - verticalGlyphForm: The value false indicates horizontal text, the value true indicates vertical text.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func verticalGlyphForm(_ verticalGlyphForm: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        mutableAttributedString.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: verticalGlyphForm, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// Set text alignment to left.
    ///
    /// - Returns: Returns a NSAttributedString.
    func textAlignmentLeft() -> NSAttributedString {
        return textAlignment(.left)
    }
    
    /// Set text alignment to right.
    ///
    /// - Returns: Returns a NSAttributedString.
    func textAlignmentRight() -> NSAttributedString {
        return textAlignment(.right)
    }
    
    /// Set text alignment to center.
    ///
    /// - Returns: Returns a NSAttributedString.
    func textAlignmentCenter() -> NSAttributedString {
        return textAlignment(.center)
    }
    
    /// Set text alignment to justified.
    ///
    /// - Returns: Returns a NSAttributedString.
    func textAlignmentJustified() -> NSAttributedString {
        return textAlignment(.justified)
    }
    
    /// Set text alignment.
    ///
    /// - Parameter alignment: Text alignment.
    /// - Returns: Returns an NSAttributedString with the given text alignment.
    private func textAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let textAlignment = NSMutableParagraphStyle()
        textAlignment.alignment = alignment
        
        return paragraphStyle(textAlignment)
    }
    
    /// Returns self NSRange if the given NSRange is nil.
    ///
    /// - Parameter range: Given NSRange.
    /// - Returns: Returns self NSRange if the given NSRange is nil.
    private func attributedStringRange(_ range: NSRange?) -> NSRange {
        return range ?? NSRange(location: 0, length: string.count)
    }
}

#endif
