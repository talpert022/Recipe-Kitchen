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
    
}
