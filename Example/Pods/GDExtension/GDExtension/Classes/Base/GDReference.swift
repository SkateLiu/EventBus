//
//  Refrence.swift
//  GDCommonBiz
//
//  Created by YUYO on 2019/8/16.

import Foundation

public class GDReference<Base> {
    
    public static var base: Base.Type {
        return Base.self
    }
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}

public protocol GDReferenceCompatible {
    associatedtype GDCompatibleType
    
    static var gd: GDReference<GDCompatibleType>.Type { get }
    
    var gd: GDReference<GDCompatibleType> { get }
}

extension GDReferenceCompatible {
    
    public static var gd: GDReference<Self>.Type {
        return GDReference<Self>.self
    }
    
    public var gd: GDReference<Self> {
        return GDReference(self)
    }
    
}

extension NSObject: GDReferenceCompatible { }

extension Array: GDReferenceCompatible { }
