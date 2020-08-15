//
//  NSObject+GDEvent.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/26.
//

import UIKit

public extension NSObject {
    
    /// convenience func
    /// - Parameters:
    ///   - eventClass: events class
    ///   - handler: receive messages callback
    func subscribe(on eventClass:GDEvent.Type,
                      next handler:@escaping GDEventNextBlock) {
        
        GDEventBus.shared
            .on(eventClass: eventClass)
            .dispose(by: self)
            .next(handler: handler)
    }
    
    /// convenience func
    /// - Parameters:
    ///   - eventClass: eventClass description
    ///   - keys: mutable key for some type
    ///   - handler: receive messages callback
    ///
    ///   - example
    ///     subscribe(on XXXevent.self,keys: "A","B"), {event -> in
    ///             print(event)
    ///     })
    ///     dispatch("A",XXXevent())
    ///     dispatch("B",XXXevent())
    ///
    func subscribe(on eventClass:GDEvent.Type,
                   keys: String...,
                    next handler:@escaping GDEventNextBlock)  {
        
        GDEventBus.shared
            .on(eventClass: eventClass)
            .with(subTypes: keys)
            .dispose(by: self)
            .next(handler: handler)
    }
    
    /// convenience func
    /// - Parameters:
    ///   - eventName: eventName description
    ///   - handler: receive messages callback
    func subscribe(keys eventName:String...,
                              next handler:@escaping GDEventNextBlock)  {
        GDEventBus.shared
            .on(eventClass: nil)
            .with(subTypes: eventName)
            .dispose(by: self)
            .next(handler: handler)
    }
    
    /// convenience dispatch event
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    func dispatch(_ event:GDEvent,_ eventName:String? = nil)  {
        GDEventBus.shared.dispatch(event, eventName,self)
    }
    
    /// convenience dispatch event async
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    func dispatchAsync(_ event:GDEvent,_ eventName:String? = nil)  {
        GDEventBus.shared.dispatchAsync(event, eventName,self)
    }
    
}
