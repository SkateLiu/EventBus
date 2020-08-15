//
//  WeakMediator.swift
//  GDExtension
//
//  Created by Objc on 2019/12/9.
//

import UIKit

open class WeakMediator<Object: NSObjectProtocol>: NSObject {
    
    open weak var object: Object?
    
    public init(object: Object) {
        self.object = object
    }
}
