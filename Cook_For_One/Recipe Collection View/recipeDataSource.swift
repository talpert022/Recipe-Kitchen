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
        myVariables.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCell.reuseIdentifier, for: indexPath) as? recipeCell else {
            fatalError("Could not create recipe cell")
        }
        
        let recipe = myVariables.recipes[indexPath.row]
        
        cell.displayRecipe(recipe)
        
        return cell
    }
    
}
