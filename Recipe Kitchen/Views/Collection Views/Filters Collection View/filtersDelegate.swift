//
//  filtersDelegate.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/9/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

protocol FilterSelectedProtocol: class {
    func filterSelected()
}

class filtersDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    
    var selectedIndex = 0
    var delegate: FilterSelectedProtocol?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let attributes : [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Avenir-Heavy", size: 14)!
        ]
        let item = Global.mealFilters[indexPath.row].label
        
        return CGSize(width: item.size(withAttributes: attributes).width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row != selectedIndex else { return }
        
        // Update collection view
        
        // Deselect current filter
        let selectedPath = IndexPath(row: selectedIndex, section: 0)
        Global.mealFilters[selectedPath.row].selected = false
        
        // Change selected property of chosen filter
        let chosenFilter = Global.mealFilters[indexPath.row]
        chosenFilter.selected = true
        selectedIndex = indexPath.row
        
        collectionView.reloadItems(at: [selectedPath, indexPath])
        
        // Update filters and parameters
        Global.params.removeValue(forKey: "mealType")
        Global.params.removeValue(forKey: "dishType")
        
        switch chosenFilter.type {
        case .none:
            print("All recipes")
        case .meal:
            Global.params["mealType"] = chosenFilter.label
        case .dish:
            Global.params["dishType"] = chosenFilter.label
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
