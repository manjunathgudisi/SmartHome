/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Device {
	public var id : Int?
	public var gatewayId : Int?
	public var name : String?
	public var alternateId : String?
	public var creationTimestamp : Int?
	public var status : String?
	public var online : String?
	public var sensors : Array<Sensor>?
	public var authentications : Array<Authentications>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Device]
    {
        var models:[Device] = []
        for item in array
        {
            models.append(Device(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		gatewayId = dictionary["gatewayId"] as? Int
		name = dictionary["name"] as? String
		alternateId = dictionary["alternateId"] as? String
		creationTimestamp = dictionary["creationTimestamp"] as? Int
		status = dictionary["status"] as? String
		online = dictionary["online"] as? String
        if (dictionary["sensors"] != nil) {
            sensors = Sensor.modelsFromDictionaryArray(array: dictionary["sensors"] as! NSArray)
        }
        if (dictionary["authentications"] != nil) {
            authentications = Authentications.modelsFromDictionaryArray(array: dictionary["authentications"] as! NSArray)
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.gatewayId, forKey: "gatewayId")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.alternateId, forKey: "alternateId")
		dictionary.setValue(self.creationTimestamp, forKey: "creationTimestamp")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.online, forKey: "online")

		return dictionary
	}

}
