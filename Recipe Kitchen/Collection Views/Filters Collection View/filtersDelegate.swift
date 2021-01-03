//
//  filtersDelegate.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/9/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

protocol filterSelectedProtocol: class {
    func filterSelected()
}

class filtersDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    
    var selectedIndex = 0
    var delegate: filterSelectedProtocol?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let attributes : [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Avenir-Heavy", size: 14)!
        ]
        let item = myVariables.mealFilters[indexPath.row].label
        
        return CGSize(width: item.size(withAttributes: attributes).width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row != selectedIndex else { return }
        
        // Update collection view
        
        // Deselect current filter
        let selectedPath = IndexPath(row: selectedIndex, section: 0)
        myVariables.mealFilters[selectedPath.row].selected = false
        
        // Change selected property of chosen filter
        let chosenFilter = myVariables.mealFilters[indexPath.row]
        chosenFilter.selected = true
        selectedIndex = indexPath.row
        
        collectionView.reloadItems(at: [selectedPath, indexPath])
        
        // Update filters and parameters
        myVariables.params.removeValue(forKey: "mealType")
        myVariables.params.removeValue(forKey: "dishType")
        
        switch chosenFilter.type {
        case .none:
            print("All recipes")
        case .meal:
            myVariables.params["mealType"] = chosenFilter.label
        case .dish:
            myVariables.params["dishType"] = chosenFilter.label
        default:
            assert(false, "Unexpected filter type")
        }
        
        if let delegate = delegate {
            delegate.filterSelected()
        } else {
            print("Delegate not assigned")
        }
    }
}
