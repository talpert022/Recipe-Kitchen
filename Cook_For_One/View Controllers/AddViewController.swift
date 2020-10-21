//
//  addViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/24/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import iOSDropDown

protocol AddViewControllerDelegate: NSObjectProtocol {
    func addFoodItem(label: String, quantity: String?, expoDate: Date?, location : Int)
}

class AddViewController: UIViewController {
    
    var delegate : AddViewControllerDelegate?
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addIngredient: UITextField!
    @IBOutlet weak var addQuantity: UITextField!
    @IBOutlet weak var addExpoDate: UIDatePicker!
    @IBOutlet weak var addFood: UIButton!
    @IBOutlet weak var foodStorage: DropDown!
    @IBOutlet weak var addIngredientTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expirationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView.layer.cornerRadius = 15
        addFood.roundedButton()
        foodStorageSetUp()
    }
    
    @IBAction func addFood(_ sender: Any) {
        
        guard addIngredient.text != "" && addIngredient.hasText == true else {
            addIngredientTopConstraint.constant = 2
            showWarning()
            return
        }
        
        if let delegate = delegate {
            delegate.addFoodItem(label: addIngredient.text!, quantity: addQuantity.text, expoDate: addExpoDate.isEnabled ? addExpoDate.date : nil , location: foodStorage.selectedIndex ?? 0)
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    func showWarning() {
        warningLabel.alpha = 0
        warningLabel.isHidden = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.warningLabel.alpha = 1.0
        }, completion: nil)
        
    }
    
    @IBAction func expirationSwitchOn(_ sender: Any) {
        
        addExpoDate.isEnabled = expirationSwitch.isOn
    }
    
    func foodStorageSetUp() {
        
        foodStorage.optionArray = ["All Items", "Fridge", "Freezer", "Dry Pantry", "Spice Rack"]
        foodStorage.rowHeight = 40
        foodStorage.listHeight = 200
        foodStorage.isSearchEnable = true
        
        
    }
}

extension UIButton{
    
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
}
