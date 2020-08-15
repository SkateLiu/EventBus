//
//  GDEventSubscriberMaker.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//
import GDExtension

/// this class is the model for Subscriber factory
/// is to easyly that no description
public class GDEventSubscriberMaker {
    
    var eventBus: GDEventBus
    var eventClass: GDEvent.Type?
    var queue: DispatchQueue?
    var lifeTimeTracker:NSObject?
    var eventSubTypes = SafeArray<String>()
    var handler: ((GDEvent?)->())?
    
    init(eventBus:GDEventBus,eventClass:GDEvent.Type?) {
        self.eventBus = eventBus
        self.eventClass = eventClass
        self.queue = nil
    }
    
    @discardableResult
    public func at(queue: DispatchQueue) -> Self {
        self.queue = queue
        return self
    }
    
    @discardableResult
    public func next(handler: @escaping GDEventNextBlock) -> GDEventDispose?  {
        self.handler = handler
        return self.eventBus.createNewSubscriber(maker: self)
    }
    
    @discardableResult
    public func dispose(by :AnyObject) -> Self {
        self.lifeTimeTracker = by as? NSObject
        return self
    }
    
    @discardableResult
    public func with(subTypes :[String]) -> Self {
        self.eventSubTypes += subTypes
        return self
    }
    
    @discardableResult
    public func with(subTypes :String...) -> Self {
        return with(subTypes: subTypes)
    }
    
}

class GDEventSubscriber {
    var eventClass: GDEvent.Type?
    var queue: DispatchQueue?
    var uniqueId: String?
    var handler: GDEventNextBlock?
    
    init(subscriberMaker: GDEventSubscriberMaker?,
         uniqueId: String?){
        self.eventClass = subscriberMaker?.eventClass
        self.queue = subscriberMaker?.queue
        self.uniqueId = uniqueId
        self.handler = subscriberMaker?.handler
    }
}



