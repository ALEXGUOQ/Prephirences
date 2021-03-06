//
//  NSUbiquitousKeyValueStore+Prephirences.swift
//  Prephirences
/*
The MIT License (MIT)

Copyright (c) 2015 Eric Marchand (phimage)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

/** Prephirences Extends NSUbiquitousKeyValueStore

*/
extension NSUbiquitousKeyValueStore : MutablePreferencesType {

    public func dictionary() -> [String : AnyObject] {
        return self.dictionaryRepresentation as! [String:AnyObject]
    }
    public func hasObjectForKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    public func clearAll() {
        for(key,value) in self.dictionaryRepresentation {
            removeObjectForKey(key as! String)
        }
    }
    
    public func setObjectsForKeysWithDictionary(dictionary: [String:AnyObject]) {
        for (key, value) in dictionary {
            self.setObject(value, forKey: key)
        }
    }
    
    public func stringArrayForKey(key: String) -> [AnyObject]? {
        return arrayForKey(key) as? [String]
    }
    
    // MARK: number
    
    public func integerForKey(key: String) -> Int {
        return Int(longLongForKey(key))
    }
    public func floatForKey(key: String) -> Float {
        return Float(doubleForKey(key))
    }

    public func setInteger(value: Int, forKey key: String){
        setLongLong(Int64(value.value), forKey: key)
    }
    public func setFloat(value: Float, forKey key: String){
        setDouble(Double(value), forKey: key)
    }

    // MARK: url
    
    public func URLForKey(key: String) -> NSURL? {
        if let bookData = self.dataForKey(key) {
            var isStale : ObjCBool = false
            var error : NSErrorPointer = nil
            if let url = NSURL(byResolvingBookmarkData: bookData, options: .WithSecurityScope, relativeToURL: nil, bookmarkDataIsStale: &isStale, error: error) {
                if error == nil {
                    return url
                }
            }
        }
        return nil
    }
    
    public func setURL(url: NSURL, forKey key: String) {
        let data = url.bookmarkDataWithOptions(.WithSecurityScope | .SecurityScopeAllowOnlyReadAccess, includingResourceValuesForKeys:nil, relativeToURL:nil, error:nil)
        setData(data, forKey: key)
    }
}

//MARK: subscript access
extension NSUbiquitousKeyValueStore {
    
    public subscript(key: String) -> AnyObject? {
        get {
            return self.objectForKey(key)
        }
        set {
            if newValue == nil {
                removeObjectForKey(key)
            } else {
                setObject(newValue, forKey: key)
            }
        }
    }
    
}