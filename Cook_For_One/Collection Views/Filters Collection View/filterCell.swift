//
//  filtersCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/9/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class filterCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: filterCell.self)
    
    let disabledColor : UIColor = UIColor(displayP3Red: 110/255, green: 0, blue: 0, alpha: 0.4)
    let selectedColor : UIColor = UIColor(displayP3Red: 164/255, green: 0, blue: 0, alpha: 1)
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayCell(filter: Filter) {
        filterMark.isHidden = !filter.selected
        filterLabel.text = filter.label
        filterLabel.textColor = filter.selected ? selectedColor : disabledColor
    }

}
