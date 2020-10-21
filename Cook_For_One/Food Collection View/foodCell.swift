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
    @IBOutlet weak var roundedView: UIView!
    
    static let reuseIdentifier = String(describing: foodCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func displayCell(foodtxt : String, color : UIColor) {
        customizeRoundedView()
        foodLabel.text = foodtxt
        setColor(color: color)
    }
    
    func setColor(color : UIColor) {
        let lighterColor = color.lighter(by: 25.0)
        let darkerColor = color.darker(by: 25.0)
        foodLabel.textColor = darkerColor
        roundedView.backgroundColor = lighterColor!.withAlphaComponent(0.7)
    }
    
    func customizeRoundedView() {
        roundedView.layer.cornerRadius = 24
        
    }


}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
