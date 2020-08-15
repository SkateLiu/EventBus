//
//  NSError+Extensions.swift
//  GDExtension
//
//  Created by ClaudeLi on 2019/8/31.
//

import Foundation

// MARK: - Methods
public extension NSError {
    
    static func error(domain: String = "error",
                     code: Int = 0,
                     description: String? = "",
                     failureReason: String? = "") -> NSError {
        return NSError.init(domain: domain,
                            code: code,
                            userInfo: [NSLocalizedDescriptionKey: description ?? "",
                                       NSLocalizedFailureReasonErrorKey: failureReason ?? ""])
    }
}
