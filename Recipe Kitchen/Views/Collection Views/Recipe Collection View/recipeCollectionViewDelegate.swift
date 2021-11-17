//
//  recipeCollectionViewDelegate.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/29/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeTransitionProtocol: class {
    func recipeSelected(_ indexPath : IndexPath)
    func generateMoreRecipes(_ completionHandler: @escaping () -> Void)
}

class recipeCollectionViewDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    
    var delegate: RecipeTransitionProtocol?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < Global.recipes.count {
            self.delegate?.recipeSelected(indexPath)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! moreRecipesCell
            cell.startLoadingAnimation()
            self.delegate?.generateMoreRecipes(cell.stopLoadingAnimation)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxHeight : CGFloat = collectionView.bounds.height
        let maxWidth : CGFloat = maxHeight * (2/3)
        let cellSize = CGSize(width: maxWidth, height: maxHeight)
        return cellSize
    }
    
}
