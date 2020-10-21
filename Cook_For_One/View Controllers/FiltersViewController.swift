//
//  FiltersViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/2/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

protocol FiltersControllerDelegate: NSObjectProtocol {
    func addFilters(minCal : String?, maxCal : String?, time: String?, ingredients : String?, pFree : Bool, alcFree : Bool, tnFree : Bool)
}

class FiltersViewController: UIViewController {
    
    weak var delegate : FiltersControllerDelegate?

    // Outlets
    @IBOutlet weak var calorieValue: UILabel!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var minCalorieSlider: UISlider!
    @IBOutlet weak var maxCalorieSlider: UISlider!
    @IBOutlet weak var timeValue: UILabel!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var ingredientValue: UILabel!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var ingredientSlider: UISlider!
    @IBOutlet weak var switch4: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch6: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let minCals = switch1.isOn ? Int(minCalorieSlider.value.rounded()).description : nil
        let maxCals = switch1.isOn ? Int(maxCalorieSlider.value.rounded()).description : nil
        let time = switch2.isOn ? Int(timeSlider.value.rounded()).description : nil
        let ingredients = switch3.isOn ? Int(ingredientSlider.value.rounded()).description : nil
        let pFree = switch4.isOn
        let alcFree = switch5.isOn
        let tnFree = switch6.isOn
        
        delegate?.addFilters(minCal: minCals, maxCal: maxCals, time: time, ingredients: ingredients, pFree: pFree, alcFree: alcFree, tnFree: tnFree)
        
        dismiss(animated: true)
    }
    
    private func setUp() {
        saveButton.backgroundColor = UIColor(red: 87/255, green: 218/255, blue: 213/255, alpha: 1.0)
        saveButton.layer.cornerRadius = 10
        
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
        switch4.isOn = false
        switch5.isOn = false
        switch6.isOn = false
        
        minCalorieSlider.isEnabled = false
        maxCalorieSlider.isEnabled = false
        timeSlider.isEnabled = false
        ingredientSlider.isEnabled = false
        
        minCalorieSlider.minimumValue = 0
        minCalorieSlider.maximumValue = 2000
        maxCalorieSlider.minimumValue = 0
        maxCalorieSlider.maximumValue = 2000
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = 180
        
        ingredientSlider.minimumValue = 0
        ingredientSlider.maximumValue = 20
        
        minCalorieSlider.value = 0
        maxCalorieSlider.value = 0
        timeSlider.value = 0
        ingredientSlider.value = 0
    }
    
    @IBAction func switch1On(_ sender: Any) {
        
        minCalorieSlider.isEnabled = switch1.isOn
        maxCalorieSlider.isEnabled = switch1.isOn
        
        if switch1.isOn {
            calorieValue.text = "\(Int(minCalorieSlider.value.rounded()))-\(Int(maxCalorieSlider.value.rounded()))"
        } else {
            calorieValue.text = "Default"
        }
        
    }
    
    @IBAction func switch2On(_ sender: Any) {
        
        timeSlider.isEnabled = switch2.isOn
        
        if switch2.isOn {
            timeValue.text = Int(timeSlider.value.rounded()).description + " Min"
        } else {
            timeValue.text = "Default"
        }
        
    }
    
    @IBAction func switch3On(_ sender: Any) {
        ingredientSlider.isEnabled = switch3.isOn
        
        if switch3.isOn {
            ingredientValue.text = Int(ingredientSlider.value.rounded()).description
        } else {
            ingredientValue.text = "Default"
        }
    }
    
    @IBAction func minCalorieSliderChanged(_ sender: Any) {
        
        calorieValue.text = "\(Int(minCalorieSlider.value.rounded()))-\(Int(maxCalorieSlider.value.rounded()))"
        
    }
    
    @IBAction func maxCalorieSliderChanged(_ sender: Any) {
        
        calorieValue.text = "\(Int(minCalorieSlider.value.rounded()))-\(Int(maxCalorieSlider.value.rounded()))"
        
    }
    
    @IBAction func timeSliderChanged(_ sender: Any) {
        
        timeValue.text = Int(timeSlider.value.rounded()).description + " Min"
        
    }
    
    @IBAction func ingredientSliderChanged(_ sender: Any) {
        
        ingredientValue.text = Int(ingredientSlider.value.rounded()).description
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
