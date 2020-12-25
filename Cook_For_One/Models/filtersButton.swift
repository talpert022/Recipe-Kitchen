//
//  filtersButton.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 8/1/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//
import UIKit

class filtersButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    func setUpButton() {
        
        setTitleColor(UIColor(displayP3Red: 164/255, green: 0, blue: 0, alpha: 1.0), for: .normal)
        backgroundColor = UIColor.init(displayP3Red: 110/255, green: 0, blue: 0, alpha: 0.3)
        titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        layer.cornerRadius = 20
        
        imageView!.contentMode = .scaleAspectFill
    }

}
