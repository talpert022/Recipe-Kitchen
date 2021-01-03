//
//  addViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/24/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import DropDown

protocol AddViewControllerDelegate: NSObjectProtocol {
    func addFoodItem(label: String, quantity: String?, expoDate: Date?, location : Int)
}

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var delegate : AddViewControllerDelegate?
    var location : Int?
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addIngredient: UITextField!
    @IBOutlet weak var addQuantity: UITextField!
    @IBOutlet weak var addExpoDate: UIDatePicker!
    @IBOutlet weak var addFood: UIButton!
    @IBOutlet weak var addIngredientTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expirationSwitch: UISwitch!
    @IBOutlet weak var foodStorage: UIView!
    @IBOutlet weak var locationButton: UIButton!
    let dropDown = DropDown()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        addIngredient.delegate = self
        addIngredient.returnKeyType = UIReturnKeyType.done
        addIngredient.clearsOnBeginEditing = false
        addQuantity.delegate = self
        addQuantity.returnKeyType = UIReturnKeyType.done
        addQuantity.clearsOnBeginEditing = false

        dropDown.anchorView = foodStorage
        
        addView.layer.cornerRadius = 15
        locationButton.layer.cornerRadius = 10
        addFood.roundedButton()
        foodStorageSetUp()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @IBAction func addFood(_ sender: Any) {
        
        guard addIngredient.text != "" && addIngredient.hasText == true else {
            addIngredientTopConstraint.constant = 2
            showWarning()
            return
        }
        
        if let delegate = delegate {
            delegate.addFoodItem(label: addIngredient.text!, quantity: addQuantity.text, expoDate: addExpoDate.isEnabled ? addExpoDate.date : nil , location: dropDown.indexForSelectedRow ?? 0)
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        dropDown.show()
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
        
        
        dropDown.dataSource = ["All Items", "Fridge", "Freezer", "Pantry", "Spice Rack"]
        dropDown.selectRow(location!)
        locationButton.setTitle(dropDown.dataSource[location!], for: .normal)
        dropDown.width = dropDown.anchorView?.plainView.bounds.width
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            locationButton.setTitle(item, for: .normal)
        }
        
    }
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

