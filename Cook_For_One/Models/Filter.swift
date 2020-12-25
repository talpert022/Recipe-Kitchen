//
//  Filter.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/14/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

class Filter : Equatable {
        
    var label: String
    var selected : Bool
    var type : filterType
    var api : String?
    
    enum filterType {
        case health
        case diet
        case none
        case meal
        case dish
        case cuisine
    }
    
    init(label : String, selected : Bool, type : filterType) {
        self.label = label
        self.selected = selected
        self.type = type
        self.api = nil
    }
    
    init(label : String, selected : Bool, type : filterType, api : String?) {
        self.label = label
        self.selected = selected
        self.type = type
        self.api = api
    }
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        return (lhs.label == rhs.label && lhs.selected == rhs.selected)
    }
    
}
