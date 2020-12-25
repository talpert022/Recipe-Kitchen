//
//  recipeModel.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/19/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Alamofire

protocol recipeModelProtocol {
    
    func recipesRecieved(_ recipes: [Recipe])
}

class recipeModel {
    
    var delegate: recipeModelProtocol?
    
    func getRecipes(params : [String : Any]){
        
        let keys = getKeys()
        let applicationID : String = keys!["app_id"]!
        let clientKey : String = keys!["app_key"]!
        
        let stringUrl = "https://api.edamam.com/search?&app_id=\(applicationID)&app_key=\(clientKey)"
        
        AF.request(stringUrl, method: .get, parameters: params, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: nil).validate()
            .responseDecodable(of: Hits.self) { (response) in
                
                //print(response.request)
                
                guard let recipeService = response.value else {return}
                let hits = recipeService.hits
                var recipes = [Recipe]()
                
                for hit in hits! {
                    recipes.append(hit.recipe!)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.recipesRecieved(recipes)
                }
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
