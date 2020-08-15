//
//  GDEventToken.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//

import GDExtension

public class GDEventDisposeContainer: NSObject, GDEventDispose {
    var uniqueId: String?
    var isDisposed = false
    var onDispose: ((String?)->())?
    
    init(key:String) {
        self.uniqueId = key
    }
    
    public func dispose() {
        synchronized {
            if isDisposed {
                return
            }
            isDisposed = true
        }
        onDispose?(uniqueId)
    }
}

public class GDComposeDisposeContainer: NSObject, GDEventDispose {
    var tokens:SafeArray<GDEventDispose>?
    var isDisposed = false
    
    init(tokens:SafeArray<GDEventDispose>) {
        self.tokens = tokens
    }
    public func dispose() {
        synchronized {
            if isDisposed {
                return
            }
            isDisposed = true
        }
        tokens?.forEach({ (token) in
            token.dispose()
        })
    }
}
