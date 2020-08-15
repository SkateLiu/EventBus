//
//  Dictionary+Extensions.swift
//  GDExtension
//
//  Created by Objc on 08/14/2019.
//  Copyright © 2019 GDExtension
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Methods
public extension Dictionary {

    /// GDExtension: Check if key exists in dictionary.
    ///
    ///        let dict: [String : Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///        dict.has(key: "testKey") -> true
    ///        dict.has(key: "anotherKey") -> false
    ///
    /// - Parameter key: key to search for
    /// - Returns: true if key exists in dictionary.
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /// GDExtension: Remove all keys contained in the keys parameter from the dictionary.
    ///
    ///        var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.removeAll(keys: ["key1", "key2"])
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }

    /// GDExtension: Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }

    #if canImport(Foundation)
    /// GDExtension: JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    #endif

    #if canImport(Foundation)
    /// GDExtension: JSON String from dictionary.
    ///
    ///        dict.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
    ///
    ///        dict.jsonString(prettify: true)
    ///        /*
    ///        returns the following string:
    ///
    ///        "{
    ///        "testKey" : "testValue",
    ///        "testArrayKey" : [
    ///            1,
    ///            2,
    ///            3,
    ///            4,
    ///            5
    ///        ]
    ///        }"
    ///
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = true) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    #endif

    /// GDExtension: Returns a dictionary containing the results of mapping the given closure over the sequence’s elements.
    /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type.
    /// - Returns: A dictionary containing the transformed elements of this sequence.
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try map(transform))
    }

    /// GDExtension: Returns a dictionary containing the non-`nil` results of calling the given transformation with each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
    /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try compactMap(transform))
    }
    
    /// GDExtension: Union of self and the input dictionaries.
    func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (key, value) -> Void in
                result[key] = value
            }
        }
        return result
    }
    
    /// GDExtension: Intersection of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] copules.
    func intersection<K, V: Equatable>(_ dictionaries: [K: V]...) -> [K: V] {
        //  Casts self from [Key: Value] to [K: V]
        let filtered = mapFilter { (item, value) -> (K, V)? in
            if let item = item as? K, let value = value as? V {
                return (item, value)
            }
            return nil
        }
        
        //  Intersection
        
        return filtered.filter { (arg: (key: K, value: V)) -> Bool in
            //  check for [key: value] in all the dictionaries
            
            let (key, value) = arg
            return dictionaries.testAll { $0.has(key) && $0[key] == value }
        }
    }
    
    /// GDExtension: Checks if a key exists in the dictionary.
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// GDExtension: Creates an Array with values generated by running
    /// each [key: value] of self through the mapFunction.
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    /// GDExtension: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction.
    func mapValues<V>(_ map: (Key, Value) -> V) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            mapped[$0] = map($0, $1)
        }
        return mapped
    }
    
    /// GDExtension: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    func mapFilterValues<V>(_ map: (Key, Value) -> V?) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[$0] = value
            }
        }
        return mapped
    }
    
    /// GDExtension: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    func mapFilter<K, V>(_ map: (Key, Value) -> (K, V)?) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        return mapped
    }
    
    /// GDExtension: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction.
    func map<K, V>(_ map: (Key, Value) -> (K, V)) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        }
        return mapped
    }
    
    /// GDExtension: Constructs a dictionary containing every [key: value] pair from self
    /// for which testFunction evaluates to true.
    func filter(_ test: (Key, Value) -> Bool) -> Dictionary {
        var result = Dictionary()
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        return result
    }
    
    /// GDExtension: Checks if test evaluates true for all the elements in self.
    func testAll(_ test: (Key, Value) -> (Bool)) -> Bool {
        return !contains { !test($0, $1) }
    }
    
    /// GDExtension: Unserialize JSON string into Dictionary
    static func constructFromJSON (json: String) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary {
            return data
        } else {
            return nil
        }
    }
    
    /// GDExtension: Serialize Dictionary into JSON string
    func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    func toQuaryParams() -> String  {
        var result = [String]()
        
        keys.forEach { (key) in
            if let value = self[key] {
                result.append(String(describing: key) + "=" + String(describing: value))
            }
        }
        return result.joined(separator: "&")
    }

}

// MARK: - Methods (Value: Equatable)
public extension Dictionary where Value: Equatable {

    /// GDExtension: Returns an array of all keys that have the given value in dictionary.
    ///
    ///        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    ///        dict.keys(forValue: "value1") -> ["key1", "key2"]
    ///        dict.keys(forValue: "value2") -> ["key3"]
    ///        dict.keys(forValue: "value3") -> []
    ///
    /// - Parameter value: Value for which keys are to be fetched.
    /// - Returns: An array containing keys that have the given value.
    func keys(forValue value: Value) -> [Key] {
        return keys.filter { self[$0] == value }
    }
    
    
    /// GDExtension: Difference of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] pairs.
    func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
    
}

// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: StringProtocol {

    /// GDExtension: Lowercase all keys in dictionary.
    ///
    ///        var dict = ["tEstKeY": "value"]
    ///        dict.lowercaseAllKeys()
    ///        print(dict) // prints "["testkey": "value"]"
    ///
    mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
    
}
public extension Dictionary{
    
    /// get object ignore key upper or lower case
    /// - Parameter key: the key must be string o
    func objectForKey(ignoreKeyCase key:String?) -> Any? {
        guard let ignoreKeyCase = key?.lowercased()   else { return  nil}

        for item in keys {
            if let keyItem = item as? String,
                ignoreKeyCase == keyItem.lowercased(){
               return self[item]
            }
        }
        return nil
    }
    
    mutating func setObject(_ object: Value, ignoreKeyCase key: String?) {
        guard let ignoreKeyCase = key?.lowercased() else { return }

        for item in keys {
            if let keyItem = item as? String,
                ignoreKeyCase == keyItem.lowercased() {
                self[item] = object
                return
            }
        }
    }
}

// MARK: - Subscripts
public extension Dictionary {

    /// GDExtension: Deep fetch or set a value from nested dictionaries.
    ///
    ///        var dict =  ["key": ["key1": ["key2": "value"]]]
    ///        dict[path: ["key", "key1", "key2"]] = "newValue"
    ///        dict[path: ["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note: Value fetching is iterative, while setting is recursive.
    ///
    /// - Complexity: O(N), _N_ being the length of the path passed in.
    ///
    /// - Parameter path: An array of keys to the desired value.
    ///
    /// - Returns: The value for the key-path passed in. `nil` if no value is found.
    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
}

// MARK: - Operators
public extension Dictionary {

    /// GDExtension: Merge the keys/values of two dictionaries.
    ///
    ///        let dict : [String : String] = ["key1" : "value1"]
    ///        let dict2 : [String : String] = ["key2" : "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    // MARK: - Operators

    /// GDExtension: Append the keys and values from the second dictionary into the first one.
    ///
    ///        var dict : [String : String] = ["key1" : "value1"]
    ///        let dict2 : [String : String] = ["key2" : "value2"]
    ///        dict += dict2
    ///        dict["key1"] -> "value1"
    ///        dict["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    /// GDExtension: Remove keys contained in the sequence from the dictionary
    ///
    ///        let dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        let result = dict-["key1", "key2"]
    ///        result.keys.contains("key3") -> true
    ///        result.keys.contains("key1") -> false
    ///        result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    /// GDExtension: Remove keys contained in the sequence from the dictionary
    ///
    ///        var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict-=["key1", "key2"]
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }

}
