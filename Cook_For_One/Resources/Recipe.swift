//
//  Recipe.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/4/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

struct Hits : Codable {
    var q: String?
    var from: Int?
    var to: Int?
    var params: [[String]]?
    var count: Int?
    var more: Bool?
    var hits: [Hit]?
}

struct Hit : Codable {
    var recipe: Recipe?
    var bookmarked: Bool?
    var bought: Bool?
}

struct Recipe : Codable {
    var uri : String?
    var label: String?
    var image: String?
    var source: String?
    var url: String?
    var yield: Int?
    var calories: Float?
    var totalWeight: Float?
    var ingredients: [Ingredient]?
    var totalNutrients : [String : NutrientInfo]?
    var totalDaily : [String : NutrientInfo]?
    var dietLabels : [String]?
    var totalTime : Float?
}

struct Ingredient : Codable {
    var foodId: String?
    var quantity: Float?
    var measure : Measure?
    var weight : Float?
    var food: FoodItem?
    var foodCategory: String?
}

struct Measure : Codable {
    var uri : String?
    var label : String?
}

struct FoodItem : Codable {
    var foodId: String?
    var label: String?
}

struct NutrientInfo : Codable {
    var uri: String?
    var label: String?
    var quantity: Float?
    var unit: String?
}

