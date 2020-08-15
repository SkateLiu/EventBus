//
//  GDEvent.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//

public protocol GDEvent {
    
    /// eventName for GDEvent
    var eventName: String? { get set }
}


public protocol GDEventDispose {
    
    /// destory func
    func dispose()
}


public class GDEventObject<T> : GDEvent {
    public var eventName: String?
    public var data:T?
    init(eventName:String,data:T?) {
        self.eventName = eventName
        self.data = data
    }
}

