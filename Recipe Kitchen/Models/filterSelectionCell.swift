//
//  filterSelectionCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/15/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class filterSelectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: filterSelectionCell.self)

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterMark: UIImageView!
    @IBOutlet weak var backgroundScreen: UIView!
    
    let image1 = UIImage(systemName: "checkmark")
    let image2 = UIImage(systemName: "xmark")
    let c1 = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let c2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayCell(filter : Filter) {
        filterMark.image = filter.selected ? image1 : image2
        filterLabel.text = filter.label
        
        backgroundScreen.layer.cornerRadius = 15
        backgroundScreen.layer.borderWidth = 2
        backgroundScreen.layer.borderColor = filter.selected ? c1.cgColor : c2.cgColor
        backgroundScreen.backgroundColor = filter.selected ? c1.withAlphaComponent(0.2) : c2.withAlphaComponent(0.3)
        filterMark.tintColor = filter.selected ? c1 : c2
    }

}
