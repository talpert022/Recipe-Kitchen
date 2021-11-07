//
//  recipeDataSource.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/29/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class recipeDataSource : NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let recipeCount = Global.recipes.count
        if recipeCount > 0 && Global.nextPageLink != nil {
            return recipeCount + 1 // Add a cell for moreRecipesCell collection view cell
        } else {
            return recipeCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < Global.recipes.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCell.reuseIdentifier, for: indexPath) as? recipeCell else {
                fatalError("Could not create recipe cell")
            }
            
            let recipe = Global.recipes[indexPath.row]
            
            cell.displayRecipe(recipe)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: moreRecipesCell.reuseIdentifier, for: indexPath) as? moreRecipesCell else {
                fatalError("Could not create recipe cell")
            }
            cell.configure()
            return cell
        }
    }
    
}
