//  JsonlyTests.swift
//  JsonlyTests
//  Created by Matthew F. Faller on 7/19/16.
//  Copyright © 2016 Matthew F. Faller. All rights reserved.
//
//  Oxy Parse.
//  The cleanest way to deal with Json.

import XCTest
@testable import SwiftJson

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPreservationPlain() {
        
        let dictionary: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let originalJson = Json(fromDictionary: dictionary)
        
        let originalString = originalJson.asJsonString()
        
        let newJson = Json(utf8text: originalString ?? "{}")
        
        compareStructures(dictionary: dictionary, json: originalJson)
        compareStructures(dictionary: dictionary, json: newJson!)
    }
    
    func testPreservationPretty() {
        
        let dictionary: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let originalJson = Json(fromDictionary: dictionary)
        
        let originalString = originalJson.asPrettyJsonString()
        
        let newJson = Json(utf8text: originalString ?? "{}")
        
        compareStructures(dictionary: dictionary, json: originalJson)
        compareStructures(dictionary: dictionary, json: newJson!)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testParsing() {
        
        let jsonString = "{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}"
        let json = Json(utf8text: jsonString)
        XCTAssert(json != nil)
    }
    
    func testPath() {
        let d: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "outer" : [
                "inner1" : [
                    "inner2" : [
                        "key" : "val"
                    ]
                ]
                ] as AnyObject
        ]
        
        let json = Json(fromDictionary: d)
        
        let sub = json.getJson(forPath: "outer.inner1.inner2")
        
        XCTAssert(sub != nil)
        
        let leaf1 = json.getJson(forPath: "outer.inner1.inner2")?["key"]
        let leaf2 = json.getValue(forPath: "outer.inner1.inner2.key")
        
        XCTAssert(leaf1 != nil)
        XCTAssert(leaf2 != nil)
        
        print("\(leaf1)")
    }
    
    func testPath2() {
        let d: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "outer" : [
                "inner1" : [
                    "inner2" : [
                        "key" : "val"
                    ]
                ]
                ] as AnyObject
        ]
        
        let json = Json(fromDictionary: d)
        
        let sub = json.get(forPath: "outer.inner1.inner2")
        
        XCTAssert(sub != nil)
        
        let leaf1 = json.get(forPath: "outer.inner1.inner2")?["key"]?.asAnyObject
        let leaf2 = json.get(forPath: "outer.inner1.inner2.key")?.asAnyObject
        
        XCTAssert(leaf1 != nil)
        XCTAssert(leaf2 != nil)
        
        print("\(leaf1)")
    }
    
    func testPath3() {
        let d: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "outer" : [
                "inner1" : [
                    "inner2" : [
                        "key" : "val"
                    ]
                ]
                ] as AnyObject
        ]
        
        let json = Json(fromDictionary: d)
        
        let sub = json.get(forPath: "outer.inner1.inner2")
        
        XCTAssert(sub != nil)
        
        let leaf1 = json["outer"]?["inner1"]?["inner2"]?["key"]?.asAnyObject
        let leaf2 = json.get(forPath: "outer.inner1.inner2.key")?.asAnyObject
        
        XCTAssert(leaf1 != nil)
        XCTAssert(leaf2 != nil)
        
        print("\(leaf1)")
    }
    
    func testPrinting() {
        let d: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let json = Json(fromDictionary: d)
        print(json.asJsonString()!)
        print(json.asPrettyJsonString()!)
    }
    
    func testArrayParsing() {
        
        let arrayStr = "[]"
        
        let json = Json(utf8text: arrayStr)
        
        XCTAssert(json != nil)
    }
    
    func testArrayParsingComplex() {
        
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"},\"value4\"]"
        let jsonResult = Json(utf8text: test)
        
        XCTAssertTrue(jsonResult != nil)
    }
    
    func testArrays() {
        
        let arr:[Any] = [
            "value1" as AnyObject,
            "value2" as AnyObject,
            "value3" as AnyObject,
            "value4" as AnyObject
        ]
        
        //    let json = Json(fromArray: arr) TODO Fixme
        let json = Json(fromAny: arr)
        let string = json?.asPrettyJsonString() ?? "[]"
        
        let secondJson = Json(utf8text: string)
        
        XCTAssertTrue(secondJson != nil)
        
        //    print(string)
        //    print(secondJson?.asPrettyJsonString() ?? "[]")
    }
    
    func testArrayAccess1() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "2.key3.inner1")
        
        XCTAssert(result != nil)
        
        print("\(result)")
    }
    
    func testArrayAccess2() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "3")
        
        XCTAssert(result != nil)
    }
    
    func testArrayAccess3() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "4")
        
        XCTAssert(result == nil)
    }
    
    func testArrayAccess4() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "-1")
        
        XCTAssert(result == nil)
    }
    
    func testArrayAccess5() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "\(Int.max)")
        
        XCTAssert(result == nil)
    }
    
    func testArrayAccess6() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.getValue(forPath: "")
        
        XCTAssert(result == nil)
    }
    
    func testArrayAccess7() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.get(forPath: "2.key3.inner1")?.asAnyObject
        
        XCTAssert(result != nil)
        
        print("\(result)")
    }
    
    func testArrayAccess8() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.get(forPath: "2.key3.inner1")?.asString
        
        XCTAssert(result != nil)
        
        print("\(result)")
    }
    
    func testArrayAccess9() {
        let test = "[{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal\"},\"key2\":\"val2\"}},\"value2\",{\"key1\":\"val1\",\"key3\":{\"inner1\":\"inVal2\"},\"key2\":\"val2\"},\"value4\"]"
        
        let json = Json(utf8text: test)
        
        let result = json?.get(forPath: "2.key3.inner1")?.asBool
        
        XCTAssert(result == nil)
        
        print("\(result)")
    }
    
    func testValueAsString1() {
        
        let d: Dictionary<String, AnyObject> = [
            "k1" : "string" as AnyObject,
            "k2" : 42 as AnyObject,
            "k3" : true as AnyObject,
            "k4" : "null" as AnyObject,
            "k5" : 19.9 as AnyObject,
            "k6" : "" as AnyObject
        ]
        
        let json = Json(fromDictionary: d)
        
        d.forEach() { k, v in
            
            let str = json.getValueAsString(forPath: k)
            
            if v is String {
                
                XCTAssert(str != nil)
                
                if str == nil {
                    print("String is nil for key: \(k)")
                }
            }else {
                
                XCTAssert(str == nil)
            }
        }
    }
    
    func testValueAsString2() {
        
        let d: Dictionary<String, AnyObject> = [
            "k1" : "string" as AnyObject,
            "k2" : 42 as AnyObject,
            "k3" : true as AnyObject,
            "k4" : "null" as AnyObject,
            "k5" : 19.9 as AnyObject,
            "k6" : "" as AnyObject
        ]
        
        let json = Json(utf8text: Json(fromDictionary: d).asPrettyJsonString() ?? "{}")!
        
        d.forEach() { k, v in
            
            let str = json.getValueAsString(forPath: k)
            
            if v is String {
                
                XCTAssert(str != nil)
                
                if str == nil {
                    print("String is nil for key: \(k)")
                }
            }else {
                
                XCTAssert(str == nil)
            }
        }
    }
    
    func testValueAsString3() {
        
        let d: Dictionary<String, AnyObject> = [
            "k1" : "string" as AnyObject,
            "k2" : 42 as AnyObject,
            "k3" : true as AnyObject,
            "k4" : "null" as AnyObject,
            "k5" : 19.9 as AnyObject,
            "k6" : "" as AnyObject
        ]
        
        let json = Json(utf8text: Json(fromDictionary: d).asPrettyJsonString() ?? "{}")!
        
        d.forEach() { k, v in
            
            let str = json.get(forPath: k)?.asString
            
            if v is String {
                
                XCTAssert(str != nil)
                
                if str == nil {
                    print("String is nil for key: \(k)")
                }
            }else {
                
                XCTAssert(str == nil)
            }
        }
    }
    
    func testValues() {
        
        let d: Dictionary<String, AnyObject> = [
            "k1" : "string" as AnyObject,
            "k2" : 42 as AnyObject,
            "k3" : true as AnyObject,
            "k4" : "null" as AnyObject,
            "k5" : 19.9 as AnyObject,
            "k6" : "" as AnyObject
        ]
        
        
        let json = Json(utf8text: Json(fromDictionary: d).asPrettyJsonString() ?? "{}")!
        
        
        d.forEach() { k, v in
            
            guard let obj = json.getValue(forPath: k) else {
                
                print("\(k) was nil. ")
                return
            }
            
            let objView = Mirror(reflecting: obj)
            
            print("\(k) Type = \(objView.subjectType)")
            
            if obj is Int {
                
                print("\(k) Type is also an Int. ")
            }
        }
    }
    
    func testArraysComplex() {
        
        let d1: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let d2: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : d1 as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let arr:[AnyObject] = [
            d2 as AnyObject,
            "value2" as AnyObject,
            d1 as AnyObject,
            "value4" as AnyObject
        ]
        
        let json = Json(fromArray: arr)
        
        let string = json.asPrettyJsonString() ?? "[]"
        
        let secondJson = Json(utf8text: string)
        
        XCTAssertTrue(secondJson != nil)
        
        //    let query = json.getValueAsString(forPath: "accounts.0.id")
        // print(string)
        print(secondJson?.asJsonString() ?? "[]")
    }
    
    func testEmptyParse() {
        
        let empty = "{}"
        
        let json = Json(utf8text: empty)
        
        XCTAssert(json != nil)
    }
    
    func testExtra() {
        let _ = Json()
        
        let test1: [String: AnyObject] = [
            "key1" : "val1" as AnyObject,
            "key2" : "val2" as AnyObject,
            "key3" : [
                "inner1" : "inVal"
                ] as AnyObject
        ]
        
        let json1 = Json(fromDictionary: test1)
        let innerJson = json1["key3"]
        XCTAssert(innerJson != nil)
        
        let innerVal = innerJson?["inner1"]
        
        XCTAssert(innerVal != nil)
        
        let jsonString1 = json1.asJsonString()
        let jsonString2 = json1.asPrettyJsonString()
        let jsonData    = json1.asJsonData()
        
        XCTAssert(jsonString1 != nil)
        XCTAssert(jsonString2 != nil)
        XCTAssert(jsonData != nil)
        
        let result1 = jsonString1 ?? "{\"json\": \"nil\"}"
        let result2 = jsonString2 ?? "{\"json\": \"nil\"}"
        
        let jsonFromStr1 = Json(utf8text: result1)
        let jsonFromStr2 = Json(utf8text: result2)
        
        XCTAssert(jsonFromStr1 != nil)
        XCTAssert(jsonFromStr2 != nil)
    }
    
    func testUserExperienceBad() {
        
        // Task: Retrieve the first (0th) account's card number from our server response.
        
        let string = retrieveCardsList()
        
        guard let data = string.data(using: String.Encoding.utf8) else {
            // Handle Error
            return
        }
        
        var result: AnyObject = "" as AnyObject
        
        do {
            let serial = try JSONSerialization.jsonObject(with: data, options: [])
            result = serial as AnyObject
        }catch {
            print(error)
            return
        }
        
        guard let dictionary = result as? Dictionary<String, AnyObject> else {
            // Handle Error
            return
        }
        
        guard let accountList = dictionary["accounts"] as? Array<AnyObject> else {
            // Handle Error
            return
        }
        
        if accountList.count == 0 {
            // Handle Error
            return
        }
        
        guard let firstAccount = accountList[0] as? Dictionary<String, AnyObject> else {
            // Handle Error
            return
        }
        
        guard let firstCardNumber = firstAccount["cardNumber"] as? NSNumber else {
            // Handle Error
            return
        }
        
        displayCardNumber(firstCardNumber)
    }
    
    func testUserExperienceGood() {
        
        // Task: Retrieve the first (0th) account's card number from our server response.
        
        let string = retrieveCardsList()
        let json = Json(utf8text: string)
        
        guard let firstCard = json?.get(forPath: "accounts.0.cardNumber")?.asNumber else {
            // Handle Error
            return
        }
        displayCardNumber(firstCard)
    }
    
    func compareStructures(dictionary d: Dictionary<String, AnyObject>, json j: Json) {
        
        d.forEach() { (key, value) in
            
            XCTAssert(j[key] != nil)
            
            if let sub = value as? Dictionary<String, AnyObject> {
                
                compareStructures(dictionary: sub, json: j[key]!)
            }
        }
    }
    
    func retrieveCardsList() -> String {
        
        let d: [String: AnyObject] = [
            
            "statusMsg": "Successfully retrieved cards." as AnyObject,
            "statusCode" : 0 as AnyObject,
            "accounts" : [
                [
                    "id": "25367892309",
                    "cardNumber": 4567887722452314,
                    "name": "James Smith Donaldson",
                    "typeName": "Checking Account"
                ],
                [
                    "id": "9735680345AA",
                    "cardNumber": 4567887722452314,
                    "name": "James Smith Donaldson",
                    "typeName": "Credit Card"
                ],
                ] as AnyObject
        ]
        
        return Json(fromDictionary: d).asPrettyJsonString()!
    }
    
    func displayCardNumber(_ cardNumber: NSNumber) {
        print("Card Number: \(cardNumber)")
        XCTAssert(cardNumber == 4567887722452314)
    }
    
    func testMirror() {
        
        let testView = Mirror.init(reflecting: Json())
        
        let type = testView.subjectType
        
        print("TestView Type: \(type)")
        
        testView.children.forEach() { (label: String?, value: Any) in
            
            print("\(label): \(Mirror(reflecting: value).subjectType)")
        }
    }
    
    func testPrintSomeJson() {
        
        print(retrieveCardsList())
    }
    
    func testHugeFile() {
        
        guard let file = loadHugeFile() else { return }
        
        let parsedJson = Json(utf8text: file)
        
        XCTAssert(parsedJson != nil)
        
        let childTest1 = parsedJson?.get(forPath: "a.6U閆崬밺뀫颒myj츥휘:$薈mY햚#rz飏+玭V㭢뾿愴YꖚX亥ᮉ푊\u{0006}垡㐭룝\"厓ᔧḅ^Sqpv媫\"⤽걒\"˽Ἆ?ꇆ䬔未tv{DV鯀Tἆl凸g\\㈭ĭ즿UH㽤")
        
        XCTAssert(childTest1 == nil)
        
        let childTest2 = parsedJson?["a"]?["b茤z\\.N"]?.getJson(forPath: "0.1")?["\"䬰ỐwD捾V`邀⠕VD㺝sH6[칑.:醥葹*뻵倻aD\""]?.asBool
        
        XCTAssert(childTest2 != nil)
        
        let val = childTest2 ?? false
        
        XCTAssert(val == true)
        
        let prettyString = parsedJson?.asPrettyJsonString()
        
        XCTAssert(prettyString != nil)
    }
    
    func testHugeFileRec() {
        
        guard let file = loadHugeFile() else {
            XCTAssert(false)
            return
        }
        
        let parsedJson = Json(utf8text: file)?.getValue(forPath: "a")
        
        XCTAssert(parsedJson != nil)
        
        hugeFileRec(json: parsedJson)
    }
    
    func hugeFileRec(json jsonOpt: Any?) {
        
        if jsonOpt == nil {
            return
        }
        
        guard let json = Json(fromAny: jsonOpt) else {
            return
        }
        
        
        if json.arrayCount == 0 {
            
            let dictionary = jsonOpt as? Dictionary<String, AnyObject>
            
            for key in (dictionary?.keys)! {
                
                let value = json[key]
                
                if key == "ႁq킍蓅R`謈蟐ᦏ儂槐僻ﹶ9婌櫞釈~\"%匹躾ɢ뤥>࢟瀴愅?殕节/냔O✬H鲽엢?ᮈੁ⋧d␽㫐zCe*" {
                    
                    XCTAssert(value != nil)
                }
                
                hugeFileRec(json: value)
            }
        }else {
            
            for i in 0..<json.arrayCount {
                
                let value = json.getValue(forPath: "\(i)")
                hugeFileRec(json: value)
            }
        }
    }
    
    func loadHugeFile() -> String? {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "sample", ofType: "json") else {
            print("Could not Load Main Bundle!")
            return nil
        }
        
        guard let massiveFile = try? String(contentsOfFile: path) else {
            
            print("Could not load file. ")
            return nil
        }
        
        return massiveFile
    }
    
    
}

