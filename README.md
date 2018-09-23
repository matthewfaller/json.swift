# No Longer in Use
A newer approach available makes this repository obsolete:
[Decodable & Encodable](https://developer.apple.com/documentation/swift/codable)

## Json.swift
The easiest way to handle Json in Swift3. 

## Installation

The recommended way to add Json.swift to an iOS project is by using [Carthage](https://github.com/Carthage/Carthage).

Paste the following into your Cartfile: 

`github "matthewfaller/json.swift"`

## Usage

Suppose you had to parse and access the following Json String: 

```Json
{
  "accounts" : [
    {
      "name" : "James Smith Donaldson",
      "cardNumber" : 4567887722452314,
      "typeName" : "Checking Account",
      "id" : "25367892309"
    },
    {
      "name" : "James Smith Donaldson",
      "cardNumber" : 4567887722452314,
      "typeName" : "Credit Card",
      "id" : "9735680345AA"
    }
  ],
  "statusMsg" : "Successfully retrieved cards.",
  "statusCode" : 0
}
```

Using Json.swift, this chore becomes less cumbersome: 

```Swift
let string = retrieveCardsList()
let json = Json(utf8text: string)

guard let firstCard = json?.get(forPath: "accounts.0.cardNumber")?.asNumber else {
    // Handle Error
    return
}
displayCardNumber(firstCard)
```

This is taking advantage of our simple 'dot' path notation. Further examples follow. 

### Json Objects

A Json Object can be created by one of the convienient initializers: 

```Swift
let jsonResponse = Json(utf8text: jsonString)
```

```Swift
let map = [
  "key1": "value1",
  "key2": [
    "innerKey1": "val"
  ]
]

let myJson = Json(fromDictionary: map)
```

Getting values out of your json can be done two ways: 

#### 1. Dot Path 

```Swift

let myVal = myJson.get(forPath: "key2.innerKey1").asString
```
For each key separated by a dot (.), the "get(forPath:)" method will use optional chaining to reach deep into your json. 

#### 2. Subscript Access

Of course, some json keys might *also* have dots, i.e.: 

```Json
{
    "phone.number" : "1-866-999-9999",
    "user.profile" : {
      "user.name" : "therealspiderman",
      "email.masked" : "pete*******@dailybugle.com"
    }
}
```
The subscript operator will ignore any dots, treating the whole string as a key: 

```Swift
let email = myJson["user.profile"]?["email.masked"]?.asString
```

### Json Arrays


### Json Values

