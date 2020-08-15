//
//  GDDisposeBag.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//

import GDExtension

class GDDisposeBag {
    
    /// the safe collection for token and binding to NSObject
    var tokens = SafeArray<GDEventDispose>()
    var stickyTokens = SafeArray<GDEventDispose>()
    
    /// add token to clooection
    /// - Parameter token: confrom to GDEventTokenProtocol objct
    func addToken(_ token: GDEventDispose)  {
        tokens.append(token)
    }
    
    func addStickyToken(_ tokens:GDEventDispose)  {
        stickyTokens += tokens
    }
    
    /// when NSObjct delloc, the tokens will dispose also
    deinit {
        tokens.forEach { $0.dispose() }
        stickyTokens.forEach { $0.dispose() }
    }
}
