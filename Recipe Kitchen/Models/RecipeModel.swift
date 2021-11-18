//
//  RecipeModel.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/19/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Alamofire

protocol RecipeModelProtocol {
    
    func recipesRecieved(_ recipes: [Recipe])
    
    func moreRecipesAdded(_ recipes: [Recipe])
    
    func invalidRecipeSearch()
}

class RecipeModel {
    
    var delegate: RecipeModelProtocol?
    
    func getRecipes(params : [String : Any]){
        
        let keys = getKeys()
        let applicationID : String = keys!["app_id"]!
        let clientKey : String = keys!["app_key"]!
        
        let stringUrl = "https://api.edamam.com/api/recipes/v2?type=public&app_id=\(applicationID)&app_key=\(clientKey)"
        
        AF.request(stringUrl, method: .get, parameters: params, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: nil).validate()
            .responseDecodable(of: Hits.self) { (response) in
                
                print(response.request)
                
                guard let recipeService = response.value else {
                    self.delegate?.invalidRecipeSearch()
                    return
                }
                
                let recipes = recipeService.hits!.compactMap { $0.recipe }
                    
                DispatchQueue.main.async {
                    self.delegate?.recipesRecieved(recipes)
                }
                
                Global.nextPageLink = recipeService._links?.next?.href
        }
    }
    
    // TODO: Security???????
    // Retrieves recipes from the next link of a current recipe GET request to support pagination
    // Competion handler ends the more recipe cell loading animation
    func getMoreRecipes(stringUrl : String, completionHandler: @escaping () -> Void) {
        
        AF.request(stringUrl, method: .get, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: nil).validate()
            .responseDecodable(of: Hits.self) { (response) in
                
                print(response.request)
                
                guard let recipeService = response.value else {
                    self.delegate?.invalidRecipeSearch()
                    return
                }
                
                let recipes = recipeService.hits!.compactMap { $0.recipe }
                    
                DispatchQueue.main.async {
                    self.delegate?.moreRecipesAdded(recipes)
                    completionHandler()
                }
                
                Global.nextPageLink = recipeService._links?.next?.href
        }
    }
    
    func getKeys() -> [String : String]? {
        var nsDict: [String : String]?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            nsDict = NSDictionary(contentsOfFile: path) as? [String : String]
            return nsDict!
        } else {return nil}
    }
}
