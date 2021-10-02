//
//  recipeCollectionViewDelegate.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/29/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

protocol recipeTransitionProtocol: class {
    func recipeSelected(_ indexPath : IndexPath)
}

class recipeCollectionViewDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    
    var delegate: recipeTransitionProtocol?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.recipeSelected(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxHeight : CGFloat = collectionView.bounds.height
        let maxWidth : CGFloat = maxHeight * (2/3)
        let cellSize = CGSize(width: maxWidth, height: maxHeight)
        return cellSize
    }
    
}
