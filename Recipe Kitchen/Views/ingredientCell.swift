//
//  ingredientCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/26/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Foundation

class ingredientCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    
    static let reuseIdentifier = String(describing: ingredientCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func displayCell(food : Food) {
        label.text = food.label
        checkImage.isHidden = !food.inRecipe
        
        if food.expirationStatus == .expiring {
            if food.daysTilExpiration == 1 {
                warningLabel.text = "⚠️ \(food.daysTilExpiration!) day left"
            } else {
                warningLabel.text = "⚠️ \(food.daysTilExpiration!) days left"
            }
            warningLabel.textColor = .systemYellow
        } else if food.expirationStatus == .expired{
            if abs(food.daysTilExpiration!) == 1 {
                warningLabel.text = "☠️ \(abs(food.daysTilExpiration!)) day bad"
            } else {
                warningLabel.text = "☠️ \(abs(food.daysTilExpiration!)) days bad"
            }
            warningLabel.textColor = .systemRed
        }
    }

}
