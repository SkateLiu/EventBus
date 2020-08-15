//
//  Event+disposeBag.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//

import UIKit


private var key = "com.gaodun.event.dispose.key"
private var stickyKey = "com.gaodun.sticky.event.dispose.key"

/// runtime binding disposeBag to NSObject
extension NSObject {
    
    var disposeBag:GDDisposeBag{
        get {
            if let obj = objc_getAssociatedObject(self, &key) {
                return obj as! GDDisposeBag
            }
            let obj = GDDisposeBag()
            objc_setAssociatedObject(self, &key, obj, .OBJC_ASSOCIATION_RETAIN)
            return obj
        }
    }
    
    var stickyDisposeBag:GDDisposeBag{
           get {
               if let obj = objc_getAssociatedObject(self, &stickyKey) {
                   return obj as! GDDisposeBag
               }
               let obj = GDDisposeBag()
               objc_setAssociatedObject(self, &stickyKey, obj, .OBJC_ASSOCIATION_RETAIN)
               return obj
           }
       }
}
