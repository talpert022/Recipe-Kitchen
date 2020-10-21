//
//  foodInfoCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/9/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class foodInfoCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    static let reuseIdentifier = String(describing: foodInfoCell.self)
    
    func containerViewSetUp() {
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.backgroundColor = UIColor.white
        deleteButton.isHidden = true
    }
    
    func displayFood(food : Food) {
        ingredientLabel.text = food.label
        quantityLabel.text = food.quantity ?? ""
        locationLabel.text = food.location.label
        expirationLabel.text = food.expirationString
    }
    
    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    

}
