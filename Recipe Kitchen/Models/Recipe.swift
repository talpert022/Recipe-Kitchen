//
//  Recipe.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/4/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

struct Hits : Codable {
    var from: Int?
    var to: Int?
    var count: Int?
    var _links : Links?
    var hits: [Hit]?
}

struct Hit : Codable {
    var recipe: Recipe?
    var _links : Links?
}

struct Links : Codable {
    var `self` : Link?
    var next : Link?
}

struct Link : Codable {
    var href : String?
    var title : String?
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
    var cautions : [String]?
    var ingredientLines : [String]?
    var ingredients: [Ingredient]?
    var calories: Float?
    var totalWeight: Float?
    var totalTime : Float?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String]?
    var totalNutrients : NutrientsInfo?
    var totalDaily : NutrientsInfo?
}

struct Ingredient : Codable {
    var text: String?
    var quantity: Float?
    var measure : String?
    var food: String?
    var weight : Float?
    var foodCategory: String?
    var foodId: String?
}

struct NutrientsInfo : Codable {
    var uri : String?
    var label: String?
    var quantity: Float?
    var unit: String?
}

