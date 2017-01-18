//
//  Json.swift
//  Jsonly
//
//  Created by Matthew F. Faller on 7/19/16.
//  Copyright © 2016 Matthew F. Faller. All rights reserved.
//

import Foundation

public class Json {
    
    public static var forceVerboseDebugging = false
    private static let TAG = "Json.swift"
    
    // Properties
    // ==================================================================================================
    
    /**
     This is the internal structure used to store the json.
     */
    private var jsonMap: Dictionary<String, AnyObject> = [:]
    private var jsonArray: Array<AnyObject> = []
    private var jsonValue: Any? = nil
    
    private(set) var isLeaf: Bool = false
    private(set) var isArray: Bool = false
    
    /**
     If this item is a json array, arrayCount will be equal to the number of items in the array.
     */
    public var arrayCount: Int {
        
        get {
            return jsonArray.count
        }
    }
    
    // Constructors / convenience constructors methods.
    // ==================================================================================================
    
    /**
     Creates a json object from a Dictionary
     - parameters:
        - fromDictionary: The dictionary with your json's key-value pairs. Works with nested dictionaries as well.
     */
    public init(fromDictionary: Dictionary<String, AnyObject>) {
        self.jsonMap = fromDictionary
        self.isArray = false
    }
    
    public init(fromArray: Array<AnyObject>) {
        self.jsonArray = fromArray
        self.isArray = true
    }
    
    /**
     Creates an empty json object "{}"
     */
    public convenience init() {
        self.init(fromDictionary: Dictionary<String, AnyObject>())
    }
    
    /**
     Attempts to create a json object from the string using UTF8 encoding.
     This constructor will fail (return nil) under the following conditions:
     - The provided text is not valid json.
     - The provided text is not a utf8 string.
     
     - parameters:
        - utf8text: A UTF8 encoded json string.
     */
    public convenience init?(utf8text text: String) {
        
        Json.log("Parsing text into Json.")
        
        guard let data = text.data(using: String.Encoding.utf8) else {
            Json.log("Failed converting text to utf8 NSData.")
            return nil
        }
        
        guard let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as AnyObject else {
            Json.log("JSONObjectWithData(data, options), Using default options: NSJSONReadingOptions()")
            Json.log("Failed to serialize to JSON. The NSData UTF8 representation of your string could not be serialized. ")
            return nil
        }
        
        self.init(fromObject: object)
    }
    
    public convenience init?(fromAny any: Any?) {
        self.init(fromObject: any as AnyObject)
    }
    
    /**
     Creates a json object from a Dictionary
     - parameters:
        - fromObject: An object representing json, e.g.
                       A Dictionary
                       An Array
                        - 3. A value (leaf)
     */
    public convenience init?(fromObject optObject: AnyObject?) {
        
        guard let object = optObject else {
            Json.log("Passed a nil object into initializer. Returning nil. ")
            return nil
        }
        
        if object is Dictionary<String, AnyObject> {
            
            guard let dict = object as? Dictionary<String, AnyObject> else {
                Json.log("Could not cast AnyObject to Dictionary<String, AnyObject>. Object: \(object). ")
                return nil
            }
            
            self.init(fromDictionary: dict)
            return
        }
        
        if object is Array<AnyObject> {
            
            guard let arr = object as? Array<AnyObject> else {
                Json.log("Could not cast AnyObject to Array<AnyObject>. Object: \(object). ")
                return nil
            }
            
            self.init(fromArray: arr)
            return
        }
        
        if Json.isLeafNode(anyObject: object) {
            
            self.init(fromLeaf: object)
            return
        }
        
        return nil
    }
    
    private init(fromLeaf obj: AnyObject) {
        
        self.isLeaf = true
        self.jsonValue = obj
    }
    
    // Member Functions
    // ==================================================================================================
    
    /**
     Retrieves a nested Json Object using a special dot-path notation. For example,
     given a json object:
     ````
     {
        "key1" : {
     
            "key2" : {
     
                "key3" : {
     
                    "innerKey1" : "innerValue1",
                    "innerKey2" : "innerValue2"
                }
            }
        }
     }
     ````
     The path "key1.key2.key3" would return:
     ````
     {
        "innerKey1" : "innerValue1",
        "innerKey2" : "innerValue2"
     }
     ````
     - parameters:
     - forPath: A dot separated path which specifies a traversal through nested json objects. Each dot denotes tra
     
     - returns: The json object specified by the path.
     */
    public func get(forPath p: String) -> Json? {
        
        var json: Json? = self
        
        
        p.components(separatedBy: ".").forEach() { path in
            
            json = json?[path]
        }
        
        return json
    }
    
    /**
     Retrieves a nested Json Object using a special dot-path notation. For example,
     given a json object:
     ````
     {
        "key1" : {
     
            "key2" : {
     
                "key3" : {
     
                    "innerKey1" : "innerValue1",
                    "innerKey2" : "innerValue2"
                }
            }
        }
     }
     ````
     The path "key1.key2.key3" would return:
     ````
     {
        "innerKey1" : "innerValue1",
        "innerKey2" : "innerValue2"
     }
     ````
     - parameters:
        - forPath: A dot separated path which specifies a traversal through nested json objects. Each dot denotes tra
     
     - returns: The json object specified by the path.
     */
    @available(*, deprecated: 0.1, message: "use get(forPath: ...) ")
    public func getJson(forPath p: String) -> Json? {
        
        return get(forPath: p)
    }
    
    /**
     Retrieves a nested Json Value using a special dot-path notation. For example,
     given a json object:
     ````
     {
        "key1" : {
     
            "key2" : {
     
                "key3" : {
     
                    "innerKey1" : "innerValue1",
                    "innerKey2" : "innerValue2"
                }
            }
        }
     }
     ````
     The path "key1.key2.key3.innerKey2" would return:
     ````
     "innerValue2"
     ````
     
     - parameters:
        - forPath: A dot separated path which specifies a traversal through nested json objects.
     Each dot denotes moving through one hierarchical level.
     
     - returns: The json value specified by the path. If at any point a node on the path does not exist, the entire expression will
     simply become nil.
     */
    public func getValue(forPath p: String) -> AnyObject? {
        
        var components = p.components(separatedBy: ".")
        let last = components.removeLast()
        var json: Json? = self
        
        components.forEach() { path in
            
            json = json?[path]
        }
        
        return json?[getAsAnyObject: last]
    }
    
    /**
     A string value of this json or nil if not a leaf node.
     */
    public var asString: String? {
        get {
            return jsonValue as? String
        }
    }
    
    /**
     A Numerical value of this json or nil if not a leaf node.
     */
    public var asNumber: NSNumber? {
        get {
            return jsonValue as? NSNumber
        }
    }
    
    /**
     A Bool value of this json or nil if not a leaf node.
     */
    public var asBool: Bool? {
        get {
            return jsonValue as? Bool
        }
    }
    
    /**
     A value of this json or nil if not a leaf node.
     */
    public var asAnyObject: AnyObject? {
        get {
            return jsonValue as AnyObject
        }
    }
    
    /**
     Retrieves a nested Json Value using a special dot-path notation. For example,
     given a json object:
     ````
     {
     "key1" : {
     
     "key2" : {
     
     "key3" : {
     
     "innerKey1" : "innerValue1",
     "innerKey2" : "innerValue2"
     }
     }
     }
     }
     ````
     The path "key1.key2.key3.innerKey2" would return:
     ````
     "innerValue2"
     ````
     
     - parameters:
     - forPath: A dot separated path which specifies a traversal through nested json objects.
     Each dot denotes moving through one hierarchical level.
     
     - returns: The json value specified by the path. If at any point a node on the path does not exist, the entire expression will
     simply become nil. If the value is a String, this method will coer
     */
    @available(*, deprecated: 0.1, message: "use asString instead")
    public func getValueAsString(forPath p: String) -> String? {
        
        return getJson(forPath: p)?.asString
    }
    
    @available(*, deprecated: 0.1, message: "use asNSNumber instead")
    public func getValueAsNumber(forPath p: String) -> NSNumber? {
        
        return getJson(forPath: p)?.asNumber
    }
    
    /**
     The json as an optional String using utf8 encoding.
     
     - returns: The string representation of the Json object or nil, if an encoding error has occurred.
     */
    public func asJsonString() -> String? {
        
        let jsonArray = self.jsonArray as AnyObject
        let jsonMap   = self.jsonMap as AnyObject
        
        let objectToSerialize: AnyObject = isArray ? jsonArray : jsonMap
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject:objectToSerialize, options: []) else {
            
            Json.log("NSJSONSerialization failed to write json using default writing options. ")
            return nil
        }
        
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }
    
    /**
     The json as an optional String using utf8 encoding.
     
     - returns: The string representation of the Json object or nil, if an encoding error has occurred.
     */
    public func asPrettyJsonString() -> String? {
        
        let jsonArray = self.jsonArray as AnyObject
        let jsonMap   = self.jsonMap as AnyObject
        
        let objectToSerialize: AnyObject = isArray ? jsonArray : jsonMap
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: objectToSerialize, options: [.prettyPrinted]) else {
            
            Json.log("NSJSONSerialization failed to write json using .PrettyPrinted writing options. ")
            return nil
        }
        
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }
    
    /**
     The json as an optional NSData Object.
     
     - returns: The NSData representation of the Json object or nil, if an encoding error has occurred.
     */
    public func asJsonData() -> Data? {
        
        let jsonArray = self.jsonArray as AnyObject
        let jsonMap   = self.jsonMap as AnyObject
        
        let objectToSerialize: AnyObject = isArray ? jsonArray : jsonMap
    
        return try? JSONSerialization.data(withJSONObject: objectToSerialize, options: JSONSerialization.WritingOptions())
    }
    
    // Subscript Access
    // ==================================================================================================
    
    /**
     Access a node
     
     */
    subscript(index: String) -> Json? {
        
        get {
            var result: Json? = nil
            
            if isLeaf {
                
                result = self
                
            } else if isArray {
                
                guard let arrayIndex: Int = Int(index) else {
                    
                    return nil
                }
                result = Json(fromObject: getFromArray(arrayIndex))
                
            }else {
                result = Json(fromObject: jsonMap[index])
            }
            
            return result
        }
    }
    
    subscript(getAsAnyObject index: String) -> AnyObject? {
        
        get {
            var result: AnyObject? = nil
            
            if isLeaf {
            
                result = self.jsonValue as AnyObject?
                
            } else if isArray {
                
                guard let arrayIndex: Int = Int(index) else {
                    
                    return nil
                }
                result = getFromArray(arrayIndex)
                
            }else {
                result = jsonMap[index]
            }
            
            return result
        }
    }
    
    private static func log(_ message: String) {
        
        if(!Json.forceVerboseDebugging) {
            return
        }
        
        print("\(Json.TAG): \(message)")
    }
    
    /*
     Retrieves an element from the json array, or if out of bounds, returns nil.
     */
    private func getFromArray(_ arrayIndex: Int) -> AnyObject? {
        
        if !isArray {
            return nil
        }
        
        if arrayIndex >= jsonArray.count {
            return nil
        }
        
        if arrayIndex < 0 {
            return nil
        }
        
        return jsonArray[arrayIndex]
    }
    
    /*
     Sets an element in the json array, or if out of bounds, performs no action.
     */
    private func setArrayValue(atIndex i: Int, withValue v: AnyObject) {
        
        if !isArray {
            return
        }
        
        if i >= jsonArray.count {
            return
        }
        
        if i < 0 {
            return
        }
        
        jsonArray[i] = v
    }
    
    private static func isLeafNode(anyObject obj: AnyObject) -> Bool {
        
        if obj is String || obj is Bool || obj is NSNumber { // Might need obj is NSNull to meet spec.
            
            return true
        }
        
        return false
    }
}
