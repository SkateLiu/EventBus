//
//  UILabel+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UILabel {

    /// GDExtension: Initialize a UILabel with text
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// GDExtension: Initialize a UILabel with a text and font style.
    ///
    /// - Parameters:
    ///   - text: the label's text.
    ///   - style: the text style of the label, used to determine which font should be used.
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
    
    // MARK: - Functions
    
    /// Create an UILabel with the given parameters.
    ///
    /// - Parameters:
    ///   - frame: Label frame.
    ///   - text: Label text.
    ///   - font: Label font.
    ///   - color: Label text color.
    ///   - alignment: Label text alignment.
    ///   - lines: Label text lines.
    convenience init(text: String? = "", font: UIFont, color: UIColor,_ alignment: NSTextAlignment = .left,_ lines: Int = 0) {
        self.init(frame: CGRect.zero )
        self.font = font
        self.text = text
        backgroundColor = UIColor.clear
        textColor = color
        textAlignment = alignment
        numberOfLines = lines
    }

}

public extension GDReference where Base: UILabel {
    
    /// GDExtension: Required height for a label
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: base.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = base.font
        label.text = base.text
        label.attributedText = base.attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    /// Calculates height based on text, width and font.
    ///
    /// - Returns: Returns calculated height.
    func getHeight() -> CGFloat {
        guard let text = base.text else {
            return 0
        }
        return UIFont.calculateHeight(width: base.frame.size.width, font: base.font, text: text)
    }
    
    func getTextLine() -> CGFloat {
        guard let text = base.text else {
            return 0
        }
        let height =  UIFont.calculateHeight(width: base.frame.size.width, font: base.font, text: text)
        base.lineBreakMode = base.lineBreakMode
        return height / base.font.lineHeight
    }
    
    func getSomeLinesText(_ num: Int) -> String {
        guard let text = base.text else {
            return ""
        }
        
        if self.getTextLine() <= CGFloat(num) {
            return base.text ?? ""
        }
        let path = CGPath(rect: base.frame, transform: nil)
        let framesetter = CTFramesetterCreateWithAttributedString(text.attributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, text.attributedString.length), path, nil)
        let lines = CTFrameGetLines(frame)
        let numberOfLines = CFArrayGetCount(lines)
        var lineOrigins = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: numberOfLines)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        var str = ""
        for index in 0 ..< num {
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, index), to: CTLine.self)
            let lineRef: CTLine = line
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range: NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = (text as NSString).substring(with: range)
            str.append(lineString)
        }
        return str
    }
    
    /// Sets a custom font from a character at an index to character at another index.
    ///
    /// - Parameters:
    ///   - font: New font to be setted.
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    func setFont(_ font: UIFont, fromIndex: Int, toIndex: Int) {
        guard let text = base.text else {
            return
        }
        
        base.attributedText = text.attributedString.font(font, range: NSRange(location: fromIndex, length: toIndex - fromIndex))
    }
}

#endif
