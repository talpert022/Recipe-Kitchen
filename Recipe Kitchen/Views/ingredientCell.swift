//
//  ingredientCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/26/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Foundation

protocol IngredientButtonsProtocol {
    func couldIncludeSelected(indexPath : IndexPath)
    func mustIncludeSelected(indexPath : IndexPath)
}

class ingredientCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var couldIncludeImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var indexPath : IndexPath?
    var delegate : IngredientButtonsProtocol?
    
    static let reuseIdentifier = String(describing: ingredientCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func displayCell(food : Food, indexPath: IndexPath) {
        label.text = food.label
        checkImage.image = UIImage(systemName: food.inRecipe ? "checkmark.circle.fill" : "checkmark.circle")
        couldIncludeImage.image = UIImage(systemName: food.couldInclude ? "checkmark.circle.fill" : "checkmark.circle")
        self.indexPath = indexPath
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(couldIncludeTapped(tapGestureRecognizer:)))
        couldIncludeImage.isUserInteractionEnabled = true
        couldIncludeImage.addGestureRecognizer(tapGR)
        
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(mustIncludeTapped(tapGestureRecognizer:)))
        checkImage.isUserInteractionEnabled = true
        checkImage.addGestureRecognizer(tapGR2)
        
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
    
    @objc func couldIncludeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        couldIncludeImage.image = UIImage(systemName: couldIncludeImage.image?.accessibilityIdentifier == "checkmark.circle" ? "checkmark.circle.fill" : "checkmark.circle")
        delegate?.couldIncludeSelected(indexPath: indexPath!)
    }
    
    @objc func mustIncludeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        checkImage.image = UIImage(systemName: checkImage.image?.accessibilityIdentifier == "checkmark.circle" ? "checkmark.circle.fill" : "checkmark.circle")
        delegate?.mustIncludeSelected(indexPath: indexPath!)
    }

}
