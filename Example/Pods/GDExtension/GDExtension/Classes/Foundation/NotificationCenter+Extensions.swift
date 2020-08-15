//
//  NotificationCenter+Extensions.swift
//  GDExtension
//
//  Created by ClaudeLi on 2019/9/18.
//

public extension NotificationCenter {
    
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: String, object anObject: Any? = nil) {
        NotificationCenter.default.addObserver(observer,
                                               selector: aSelector,
                                               name: NSNotification.Name(rawValue: aName),
                                               object: anObject)
    }

    static func post(_ notification: Notification) {
        NotificationCenter.default.post(notification)
    }
    
    static func post(name aName: String, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: anObject, userInfo: aUserInfo)
    }
    
    static func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

    static func removeObserver(_ observer: Any, name aName: String, object anObject: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: aName), object: anObject)
    }
}

