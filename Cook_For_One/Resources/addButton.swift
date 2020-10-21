//
//  addButton.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/21/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

@IBDesignable
class addButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    func setUpButton() {
        
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        layer.cornerRadius = 17.5
        
    }

}
