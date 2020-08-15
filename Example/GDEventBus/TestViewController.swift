//
//  TestViewController.swift
//  GDEventBus_Example
//
//  Created by Objc on 2020/5/26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import GDEventBus
import GDExtension
import Foundation

class TestViewController: UIViewController {
    
    let p = Person(number: 10)
    
    override func viewDidLoad() {
        subscribe(keys: "test") { (event) in
            print(event)
        }
        
        
    }
    
    func tyest(){
        //        subscribe(on: JsonEvent.self) { (event) in
        //            print(#line)
        //        }
                subscribe(on: JsonEvent.self,keys: "test","test2") { (event) in
                    print(#line)
                }
        //        subscribe(key: "hahah") { (event) in
        //            print(#line)
        //        }
        //        subscribe(key: "test","test2") { (event) in
        //            print(#line)
        //        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let event = JsonEvent()
        event.eventName = "test"
        dispatch(event)
        self.dismiss(animated: true, completion: nil)
        
        
//
//        let queue1 = DispatchQueue(label: "com.ffib.blog.concurrent.queue", qos: .utility, attributes: .concurrent)
//
//
//            for _ in 200...300 {
//                queue1.async {
//                    self.p.number = (self.p.number ?? 0) + 1
////
                    objc_sync_enter(self.p)
                    self.p.other = self.p.other! + 1
                    objc_sync_exit(self.p)
//
//
//                }
//        }
        
    }
    
    deinit {
        print("===========销毁了😯===============")
    }

}

@propertyWrapper
struct ThreadSafe<T>{
    lazy var refrence = NSObject()
    var value: T
    var wrappedValue: T! {
        mutating get {
            objc_sync_enter(self.refrence)
            defer {
                objc_sync_exit(self.refrence)
            }
            return value
        }
        mutating set {
            objc_sync_enter(self.refrence)
            defer {
                objc_sync_exit(self.refrence)
            }
            value = newValue
            print(value)
        }
    }
    init(_ value:T) {
        self.value = value
    }
}


class Person {
    @ThreadSafe(10)
    var number:Int?
    var other: Int? = 0{
        didSet {
            print("other",other!)
        }
    }
    
    init(number:Int?) {
        
        self._number = ThreadSafe(number ?? 0)
        self.number = number
    }
}

