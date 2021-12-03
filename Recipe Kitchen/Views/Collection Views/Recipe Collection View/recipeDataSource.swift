//
//  recipeDataSource.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/29/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class recipeDataSource : NSObject, UICollectionViewDataSource {
    
    weak var parentVC : HomeViewController?
    
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
            
            // Resets matched ingredients every time cell is displayed so it is not cumulative
            cell.clean()
            cell.parentVC = parentVC
            cell.matchedIngredients = cell.setMatchedIngredients(selectedIngredients: parentVC?.foodsToDisplay, recipe: recipe)
            cell.displayRecipe(recipe)
            
            return cell
        } else { // Used for generate more recipes cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: moreRecipesCell.reuseIdentifier, for: indexPath) as? moreRecipesCell else {
                fatalError("Could not create recipe cell")
            }
            cell.configure()
            return cell
        }
    }
    
    
    
}
