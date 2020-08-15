//
//  GDEventBus.swift
//  GDEventBus
//
//  Created by Objc on 2020/5/25.
//
import GDExtension
 
public typealias GDEventNextBlock = (GDEvent?)->()

public class GDEventBus {
    
    /// prefix for every event group name
    private let prefix = "\(NSDate().timeIntervalSince1970)"
    
    /// event center
    public static let shared = GDEventBus()
    
    /// publish message queue, if user want asyn publish mesaage, please use func dispatchAsync(...){...}
    private let publishQueue: DispatchQueue = DispatchQueue(label: "gaodun.com.eventbus.message.publish.queue")
    
    /// safe save subscribers
    private var collection:SafeDictionary = SafeDictionary<String,SafeArray<GDEventSubscriber>>()
    
    /// save sticky event
    private var stickycollection:SafeDictionary = SafeDictionary<String,SafeArray<GDEvent?>>()
    
    /// generate an unqiuekey
    /// - Parameters:
    ///   - type: event class
    ///   - eventName: event name
    private func generateUnqiueKey(type: GDEvent.Type?,eventName:String?) -> String {
        if let eventName = eventName,
            let type = type{
            return "\(self.prefix)__\(String(describing: eventName))__of__\(String(describing: type))"
        }
        if let eventName = eventName{
            return "\(self.prefix)__\(String(describing: eventName))"
        }
        if let type = type{
            return "\(self.prefix)__\(String(describing: type))"
        }
        return "u.must.give.a.unique.key"
    }
    
    /// creat subscriber
    /// - Parameter maker: subscriber factory class
    func createNewSubscriber(maker: GDEventSubscriberMaker) -> GDEventDispose? {
        guard maker.handler != nil  else { return nil}
        if maker.eventSubTypes.count == 0 {
            return addSubscriberWithMaker(maker: maker, eventName: nil)
        }
        let tokens = SafeArray<GDEventDispose>()
        maker.eventSubTypes.forEach { (enentName) in
            tokens.append(addSubscriberWithMaker(maker: maker, eventName: enentName))
        }
        return GDComposeDisposeContainer(tokens: tokens)
    }
    
    /// creat subscriber
    /// - Parameters:
    ///   - maker: subscriber factory class
    ///   - eventName: eventName description
    func addSubscriberWithMaker(maker:GDEventSubscriberMaker,eventName:String?) -> GDEventDispose {
        let groupId = "\(generateUnqiueKey(type: maker.eventClass, eventName: eventName))"
        let uniqueId = "\(groupId)__\(NSDate().timeIntervalSince1970)"
        let disposeContainer = GDEventDisposeContainer(key: uniqueId)
        disposeContainer.onDispose = {[weak self] uniqueId in
            guard let self = self else { return }
            self.collection[groupId]?.remove(where: { $0.uniqueId == uniqueId })
        }
        let subscriber = GDEventSubscriber(subscriberMaker: maker, uniqueId: uniqueId)
        if let lifeTimeTracker = maker.lifeTimeTracker {
            lifeTimeTracker.disposeBag.addToken(disposeContainer)
        }
        var subscribers = SafeArray<GDEventSubscriber>()
        if let subscriberArray = self.collection[groupId] {
            subscribers += subscriberArray
        }
        subscribers.append(subscriber)
        self.collection[groupId] = subscribers
        dispatchStickyEvent(groupId)
        return disposeContainer
    }
    
    /// observerable on eventClass
    /// - Parameter eventClass: eventClass description
    public func on(eventClass:GDEvent.Type?) -> GDEventSubscriberMaker {
        return GDEventSubscriberMaker(eventBus: self, eventClass: eventClass)
    }
    
    /// dispatch sticky event
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    ///   - disposeBy: when event is stickyly, will remove handler when disposeBy delloced
    private func dispatchStickyEvent(_ groupId:String ,_ disposeBy: NSObject? = nil)  {
        if let eventArray = self.stickycollection[groupId] {
            eventArray.forEach({ publish(groupId, event: $0) })
        }
    }
    
    /// dispatch event
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    ///   - disposeBy: when event is stickyly, will remove handler when disposeBy delloced
    public func dispatch(_ event:GDEvent,_ eventName:String? = nil,_ disposeBy: NSObject? = nil)  {
        let guoupIds = getGroupId(event, eventName)
        saveSticky(guoupIds, event: event)
        guoupIds.forEach { (id) in
            let token = GDEventDisposeContainer(key: id)
            publish(id, event: event)
            token.onDispose = { id in
                if let id = id {
                    self.stickycollection.removeValue(forKey: id)
                }
            }
            disposeBy?.stickyDisposeBag.addStickyToken(token)
        }
    }
    
    /// dispatch event async
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    public func dispatchAsync(_ event:GDEvent,_ eventName:String? = nil,_ disposeBy: NSObject? = nil)  {
        publishQueue.async {
            self.dispatch(event, eventName, disposeBy)
        }
    }
    
    /// dispatch event sync
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    public func dispatchSync(_ event:GDEvent,_ eventName:String? = nil)  {
        if Thread.isMainThread {
            dispatch(event, eventName)
        } else {
            DispatchQueue.main.async {
                self.dispatch(event, eventName)
            }
        }
    }
    
    /// realy publish message 😝
    /// - Parameters:
    ///   - key: event key
    ///   - event: event description
    func publish(_ key:String,event:GDEvent?)  {
        self.collection[key]?.forEach({ publish($0, event: event) })
    }
    
    /// realy publish message 😝
    /// - Parameters:
    ///   - key: event key
    ///   - event: event description
    func publish(_ subscriber:GDEventSubscriber,event:GDEvent?)  {
        if let queue = subscriber.queue {
            queue.async {
                subscriber.handler?(event)
            }
        } else {
            subscriber.handler?(event)
        }
    }
    
    /// return unique key for every event name and event class
    /// - Parameters:
    ///   - event: event description
    ///   - eventName: eventName description
    func getGroupId(_ event:GDEvent,_ eventName:String?) -> [String] {
        var array = [String]()
        if let eventName = event.eventName {
            array.append(generateUnqiueKey(type: nil, eventName: eventName))
            array.append(generateUnqiueKey(type: type(of: event), eventName: eventName))
        }
        array.append(generateUnqiueKey(type: type(of: event), eventName: eventName))
        return array
    }
    
    /// save sticky message in collection
    /// - Parameters:
    ///   - guoupIds: guoupIds description
    ///   - event: event description
    func saveSticky(_ guoupIds:[String],event:GDEvent?)  {
        func save(_ guoupId:String,event:GDEvent?){
            var subscribers = SafeArray<GDEvent?>()
            if let subscriberArray = self.stickycollection[guoupId] {
               subscribers += subscriberArray
            }
            subscribers.append(event)
            self.stickycollection[guoupId] = subscribers
        }
        guoupIds.forEach({ save($0, event: event) })
    }
}
