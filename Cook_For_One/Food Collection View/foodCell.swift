//
//  foodCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class foodCell: UICollectionViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    
    static let reuseIdentifier = String(describing: foodCell.self)

    func displayCell(foodtxt : String, color : UIColor) {
        contentView.layer.cornerRadius = 23
        foodLabel.text = foodtxt
        setColor(color: color)
    }
    
    func setColor(color : UIColor) {
        let lighterColor = color.lighter(by: 25.0)
        let darkerColor = color.darker(by: 25.0)
        foodLabel.textColor = darkerColor
        contentView.backgroundColor = lighterColor!.withAlphaComponent(0.5)
    }

}

