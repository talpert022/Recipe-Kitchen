//
//  filtersDataSource.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/9/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

class filtersDataSource : NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myVariables.mealFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCell.reuseIdentifier, for: indexPath) as? filterCell else {
            fatalError("Could not create filter cell")
        }
        
        cell.displayCell(filter: myVariables.mealFilters[indexPath.row])
        
        return cell
    }
    
    
}
