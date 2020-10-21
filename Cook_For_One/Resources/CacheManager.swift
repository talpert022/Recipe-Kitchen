//
//  CacheManager.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

class CacheManager {
    
    static var imageDictionary = [String:Data]()
    
    static func saveData(_ url:String, _ imageData:Data) {
        
        // Save the image data along with the URL
        imageDictionary[url] = imageData
        
    }
    
    static func retrieveData(_ url:String) -> Data? {
        
        // Return the saved image data or nil
        return imageDictionary[url]
    }
    
}
