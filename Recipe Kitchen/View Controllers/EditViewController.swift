//
//  EditViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import DropDown

protocol EditControllerDelegate {
    func doneEditing()
}

class EditViewController: UIViewController {

    // MARK: - Outlets and Vars
    
    @IBOutlet weak var labelText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var expireDate: UIDatePicker!
    @IBOutlet weak var expireSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dropDown = DropDown()
    
    var selectedFood : Food?
    var delegate : EditControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.anchorView = dropDownView
        customizeUI()
        setUpFields()
        
        labelText.returnKeyType = UIReturnKeyType.done
        quantityText.returnKeyType = UIReturnKeyType.done
        labelText.clearsOnBeginEditing = false
        quantityText.clearsOnBeginEditing = false
        self.setupToHideKeyboardOnTapOnView()
    }
    
    // MARK: - Helpers
    
    func customizeUI() {
        editView.layer.cornerRadius = 15
        saveButton.roundedButton()
    }
    
    func setUpFields() {
        labelText.text = selectedFood?.label
        quantityText.text = selectedFood?.quantity ?? ""
        locationButton.setTitle(selectedFood?.location.label, for: .normal)
        // Drop down set up
        dropDown.dataSource = ["All Items", "Fridge", "Freezer", "Dry Pantry", "Spice Rack"]
        dropDown.selectRow(Int(selectedFood?.locationEnum ?? 0))
        dropDown.width = dropDown.anchorView?.plainView.bounds.width
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            locationButton.setTitle(item, for: .normal)
        }
        if selectedFood?.expirationDate != nil {
            expireSwitch.isOn = true
            expireDate.date = (selectedFood?.expirationDate)!
        } else {
            expireSwitch.isOn = false
            expireDate.isEnabled = false
        }
        
        locationButton.layer.cornerRadius = 10
        
    }

    // MARK: - Actions

    @IBAction func switchTapped(_ sender: Any) {
        
        expireDate.isEnabled = expireSwitch.isOn
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // TODO: you can't assign a label to nil 
        selectedFood?.label = labelText.text ?? ""
        selectedFood?.quantity = quantityText.text
        selectedFood?.locationEnum = Int16(dropDown.indexForSelectedRow ?? 0)
        selectedFood?.expirationDate = expireDate.isEnabled ? expireDate.date : nil
        appDelegate.saveContext()
        
        if let delegate = delegate {
            delegate.doneEditing()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        dropDown.show()
    }
    
}

extension EditViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EditViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
