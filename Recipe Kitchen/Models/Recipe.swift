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
    var more: Bool?
    var count: Int?
    var hits: [Hit]?
}

struct Hit : Codable {
    var recipe: Recipe?
    var bookmarked: Bool?
    var bought: Bool?
}

struct Recipe : Codable {
    var uri: String?
    var label: String?
    var image: String?
    var source: String?
    var url: String?
    var yield: Int?
    var dietLabels : [String]?
    var healthLabels : [String]?
    var ingredients: [Ingredient]?
    var calories: Float?
    var totalWeight: Float?
    var totalTime : Float?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String]?
    var totalNutrients : [String : NutrientInfo]?
    var totalDaily : [String : NutrientInfo]?
}

struct Ingredient : Codable {
    var text: String?
    var quantity: Float?
    var measure : String?
    var food: String?
    var weight : Float?
    var foodCategory: String?
    var image : String?
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
    var label: String?
    var quantity: Float?
    var unit: String?
}

