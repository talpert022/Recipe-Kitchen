//
//  EditViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import iOSDropDown

protocol editProtocol {
    func doneEditing()
}

class EditViewController: UIViewController {

    // MARK: - Outlets and Vars
    
    @IBOutlet weak var labelText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var locationText: DropDown!
    @IBOutlet weak var expireDate: UIDatePicker!
    @IBOutlet weak var expireSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editView: UIView!
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedFood : Food?
    var delegate : editProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        setUpFields()
    }
    
    // MARK: - Helpers
    
    func customizeUI() {
        editView.layer.cornerRadius = 15
        saveButton.roundedButton()
    }
    
    func setUpFields() {
        labelText.text = selectedFood?.label!
        quantityText.text = selectedFood?.quantity ?? ""
        
        // Drop down set up
        locationText.optionArray = ["All Items", "Fridge", "Freezer", "Dry Pantry", "Spice Rack"]
        locationText.rowHeight = 40
        locationText.listHeight = 200
        locationText.isSearchEnable = true
        locationText.selectedIndex = Int(selectedFood?.locationEnum ?? 0)
        locationText.text = selectedFood?.location.label ?? ""
        
        if selectedFood?.expirationDate != nil {
            expireSwitch.isOn = true
            expireDate.date = (selectedFood?.expirationDate)!
        } else {
            expireSwitch.isOn = false
            expireDate.isEnabled = false
        }
        
    }

    // MARK: - Actions

    @IBAction func switchTapped(_ sender: Any) {
        
        expireDate.isEnabled = expireSwitch.isOn
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        selectedFood?.label = labelText.text
        selectedFood?.quantity = quantityText.text
        selectedFood?.locationEnum = Int16(locationText.selectedIndex ?? 0)
        selectedFood?.expirationDate = expireDate.isEnabled ? expireDate.date : nil
        appDelegate.saveContext()
        
        if let delegate = delegate {
            delegate.doneEditing()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
