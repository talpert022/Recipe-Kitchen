//
//  myVariables.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/22/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

struct myVariables {
    static var recipes = [Recipe]()
    static var params = [String : Any]()
    
    static var calsOn = false
    static var ingrOn = false
    static var timeOn = false
    static var minCalValue : Float? = nil
    static var maxCalValue : Float? = nil
    static var ingrValue : Float? = nil
    static var timeValue : Float? = nil
    
    static var filters : [Filter] = {
        var filters: [Filter] = []
        filters.append(Filter(label: "Balanced", selected: false, type: .diet, api: "balanced"))
        filters.append(Filter(label: "High Fiber", selected: false, type: .diet, api: "high-fiber"))
        filters.append(Filter(label: "High Protein", selected: false, type: .diet, api: "high-protein"))
        filters.append(Filter(label: "Low Carb", selected: false, type: .diet, api: "low-carb"))
        filters.append(Filter(label: "Low Fat", selected: false, type: .diet, api: "low-fat"))
        filters.append(Filter(label: "Low Sodium", selected: false, type: .diet, api: "low-sodium"))
        filters.append(Filter(label: "Vegan", selected: false, type: .health, api: "vegan"))
        filters.append(Filter(label: "Vegetarian", selected: false, type: .health, api: "vegetarian"))
        filters.append(Filter(label: "Sugar Conscious", selected: false, type: .health, api: "sugar-conscious"))
        filters.append(Filter(label: "Keto", selected: false, type: .health, api: "keto-friendly"))
        filters.append(Filter(label: "Gluten Free", selected: false, type: .health, api: "gluten-free"))
        filters.append(Filter(label: "Kosher", selected: false, type: .health, api: "kosher"))
        filters.append(Filter(label: "No Sugar", selected: false, type: .health, api: "low-sugar"))
        filters.append(Filter(label: "Shellfish Free", selected: false, type: .health, api: "shellfish-free"))
        filters.append(Filter(label: "Soy Free", selected: false, type: .health, api: "soy-free"))
        filters.append(Filter(label: "Dairy Free", selected: false, type: .health, api: "dairy-free"))
        filters.append(Filter(label: "Alcohol Free", selected: false, type: .health, api: "alcohol-free"))

        return filters
    }()
    
    static var mealFilters : [Filter] = {
        var filters : [Filter] = []
        filters.append(Filter(label: "All Recipes", selected: true, type: .none))
        filters.append(Filter(label: "Breakfast", selected: false, type: .meal))
        filters.append(Filter(label: "Lunch", selected: false, type: .meal))
        filters.append(Filter(label: "Dinner", selected: false, type: .meal))
        filters.append(Filter(label: "Snack", selected: false, type: .meal))
        filters.append(Filter(label: "Desserts", selected: false, type: .dish))
        filters.append(Filter(label: "Sandwiches", selected: false, type: .dish))
        filters.append(Filter(label: "Salad", selected: false, type: .dish))
        return filters
    }()
    
    static var dishFilters : [Filter] = {
        var filters : [Filter] = []
        filters.append(Filter(label: "Alcohol-cocktail", selected: false, type: .dish))
        filters.append(Filter(label: "Biscuits and cookies", selected: false, type: .dish))
        filters.append(Filter(label: "Bread", selected: false, type: .dish))
        filters.append(Filter(label: "Cereals", selected: false, type: .dish))
        filters.append(Filter(label: "Condiments and Sauces", selected: false, type: .dish))
        filters.append(Filter(label: "Desserts", selected: false, type: .dish))
        filters.append(Filter(label: "Egg", selected: false, type: .dish))
        filters.append(Filter(label: "Main Course", selected: false, type: .dish))
        filters.append(Filter(label: "Omelet", selected: false, type: .dish))
        filters.append(Filter(label: "Pancake", selected: false, type: .dish))
        filters.append(Filter(label: "Preps", selected: false, type: .dish))
        filters.append(Filter(label: "Preserve", selected: false, type: .dish))
        filters.append(Filter(label: "Salad", selected: false, type: .dish))
        filters.append(Filter(label: "Sandwiches", selected: false, type: .dish))
        filters.append(Filter(label: "Soup", selected: false, type: .dish))
        filters.append(Filter(label: "Starter", selected: false, type: .dish))
        return filters
    }()
    
    static var cuisineFilters : [Filter] = {
        var filters : [Filter] = []
        filters.append(Filter(label: "American", selected: false, type: .cuisine))
        filters.append(Filter(label: "Asian", selected: false, type: .cuisine))
        filters.append(Filter(label: "British", selected: false, type: .cuisine))
        filters.append(Filter(label: "Caribbean", selected: false, type: .cuisine))
        filters.append(Filter(label: "Central Europe", selected: false, type: .cuisine))
        filters.append(Filter(label: "Chinese", selected: false, type: .cuisine))
        filters.append(Filter(label: "Eastern Europe", selected: false, type: .cuisine))
        filters.append(Filter(label: "French", selected: false, type: .cuisine))
        filters.append(Filter(label: "Indian", selected: false, type: .cuisine))
        filters.append(Filter(label: "Italian", selected: false, type: .cuisine))
        filters.append(Filter(label: "Japanese", selected: false, type: .cuisine))
        filters.append(Filter(label: "Kosher", selected: false, type: .cuisine))
        filters.append(Filter(label: "Mediterranean", selected: false, type: .cuisine))
        filters.append(Filter(label: "Mexican", selected: false, type: .cuisine))
        filters.append(Filter(label: "Middle Eastern", selected: false, type: .cuisine))
        filters.append(Filter(label: "Nordic", selected: false, type: .cuisine))
        filters.append(Filter(label: "South American", selected: false, type: .cuisine))
        filters.append(Filter(label: "South East Asian", selected: false, type: .cuisine))
        return filters
    }()
    
    static var dietFilters : [Filter] = {
        var filters : [Filter] = []
        filters.append(Filter(label: "Balanced", selected: false, type: .diet, api: "balanced"))
        filters.append(Filter(label: "High Fiber", selected: false, type: .diet, api: "high-fiber"))
        filters.append(Filter(label: "High Protein", selected: false, type: .diet, api: "high-protein"))
        filters.append(Filter(label: "Low Carb", selected: false, type: .diet, api: "low-carb"))
        filters.append(Filter(label: "Low Fat", selected: false, type: .diet, api: "low-fat"))
        filters.append(Filter(label: "Low Sodium", selected: false, type: .diet, api: "low-sodium"))
        return filters
    }()
    
    static var healthFilters : [Filter] = {
        var filters : [Filter] = []
        filters.append(Filter(label: "Alcohol Free", selected: false, type: .health, api: "alcohol-free"))
        filters.append(Filter(label: "Immune Supportive", selected: false, type: .health, api: "immuno-supportive"))
        filters.append(Filter(label: "Celery Free", selected: false, type: .health, api: "celery-free"))
        filters.append(Filter(label: "Crustcean Free", selected: false, type: .health, api: "crustacean-free"))
        filters.append(Filter(label: "Dairy Free", selected: false, type: .health, api: "dairy-free"))
        filters.append(Filter(label: "Egg Free", selected: false, type: .health, api: "egg-free"))
        filters.append(Filter(label: "Fish Free", selected: false, type: .health, api: "fish-free"))
        filters.append(Filter(label: "FODMAP Free", selected: false, type: .health, api: "fodmap-free"))
        filters.append(Filter(label: "Gluten Free", selected: false, type: .health, api: "gluten-free"))
        filters.append(Filter(label: "Keto", selected: false, type: .health, api: "keto-friendly"))
        filters.append(Filter(label: "Kidney Friendly", selected: false, type: .health, api: "kidney-friendly"))
        filters.append(Filter(label: "Kosher", selected: false, type: .health, api: "kosher"))
        filters.append(Filter(label: "Low Potassium", selected: false, type: .health, api: "low-potassium"))
        filters.append(Filter(label: "Lupine Free", selected: false, type: .health, api: "lupine-free"))
        filters.append(Filter(label: "Mustard Free", selected: false, type: .health, api: "mustard-free"))
        filters.append(Filter(label: "No Oil Added", selected: false, type: .health, api: "No-oil-added"))
        filters.append(Filter(label: "No Sugar", selected: false, type: .health, api: "low-sugar"))
        filters.append(Filter(label: "Paleo", selected: false, type: .health, api: "paleo"))
        filters.append(Filter(label: "Peanut Free", selected: false, type: .health, api: "peanut-free"))
        filters.append(Filter(label: "Pescatarian", selected: false, type: .health, api: "pescatarian"))
        filters.append(Filter(label: "Pork Free", selected: false, type: .health, api: "pork-free"))
        filters.append(Filter(label: "Red Meat Free", selected: false, type: .health, api: "red-meat-free"))
        filters.append(Filter(label: "Sesame Free", selected: false, type: .health, api: "sesame-free"))
        filters.append(Filter(label: "Shellfish Free", selected: false, type: .health, api: "shellfish-free"))
        filters.append(Filter(label: "Soy Free", selected: false, type: .health, api: "soy-free"))
        filters.append(Filter(label: "Sugar Conscious", selected: false, type: .health, api: "sugar-conscious"))
        filters.append(Filter(label: "Tree Nut Free", selected: false, type: .health, api: "tree-nut-free"))
        filters.append(Filter(label: "Vegan", selected: false, type: .health, api: "vegan"))
        filters.append(Filter(label: "Vegetarian", selected: false, type: .health, api: "vegetarian"))
        filters.append(Filter(label: "Wheat Free", selected: false, type: .health, api: "wheat-free"))
        return filters
    }()
}
