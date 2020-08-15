//
//  Bundle+Extension.swift
//  GDExtension
//
//  Created by YUYO on 2019/9/16.
//

public extension Bundle {
    
    /// bundle path
    ///
    /// - Parameters:
    ///   - mClass: Class
    ///   - name: name
    ///   - type: type
    /// - Returns: bundle path
    static func bundlePathForClass(_ mClass: AnyClass,
                                   _ name: String? = "",
                                   _ type: String? = "") -> String {
        return Bundle(for: mClass).path(forResource: name,
                                        ofType: type) ?? ""
    }
    
    /// Bundle
    ///
    /// - Parameters:
    ///   - mClass: Class
    ///   - name: name
    ///   - type: type
    /// - Returns: Bundle
    static func bundleForClass(_ mClass: AnyClass,
                               _ name: String? = "",
                               _ type: String? = "") -> Bundle? {
        return Bundle.init(path: bundlePathForClass(mClass, name, type))
    }
}
