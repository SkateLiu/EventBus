//
//  NSDictionary+Extension.swift
//  GDExtension
//
//  Created by Objc on 2020/4/20.
//

import UIKit

@objc public extension NSDictionary {
    func objectForKey(ignoreKeyCase key:String?) -> Any? {
        guard let ignoreKeyCase = key?.lowercased()   else { return  nil}
        
        for item in allKeys {
            if let keyItem = item as? String,
                ignoreKeyCase == keyItem.lowercased(){
               return self[item]
            }
        }
        return nil
    }
    
    func setObject(_ object: Value, ignoreKeyCase key: String?) {
        guard let ignoreKeyCase = key?.lowercased() else { return }

        for item in allKeys {
            if let keyItem = item as? String,
                ignoreKeyCase == keyItem.lowercased() {
                self.setValue(item, forKey: keyItem)
                return
            }
        }
    }
}
