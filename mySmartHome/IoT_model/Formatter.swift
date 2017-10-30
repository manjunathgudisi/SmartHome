/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Formatter {
	public var scale : Int?
	public var shift : Int?
	public var swap : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let formatter_list = Formatter.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Formatter Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Formatter]
    {
        var models:[Formatter] = []
        for item in array
        {
            models.append(Formatter(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let formatter = Formatter(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Formatter Instance.
*/
	required public init?(dictionary: NSDictionary) {

		scale = dictionary["scale"] as? Int
		shift = dictionary["shift"] as? Int
		swap = dictionary["swap"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.scale, forKey: "scale")
		dictionary.setValue(self.shift, forKey: "shift")
		dictionary.setValue(self.swap, forKey: "swap")

		return dictionary
	}

}