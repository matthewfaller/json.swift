# Json.swift
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

### Json Arrays

### Json Values

