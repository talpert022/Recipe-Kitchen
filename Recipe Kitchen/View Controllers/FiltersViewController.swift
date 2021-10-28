//
//  FiltersViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/2/20.
//   
//
import UIKit
import RangeSeekSlider

protocol FiltersControllerDelegate: NSObjectProtocol {
    func addFilters(minCal : String?, maxCal : String?, time: String?, ingredients : String?, selectedFilters : [Filter]?)
}

class FiltersViewController: UIViewController {
    
    // MARK: Variables and Outlets
    
    weak var delegate : FiltersControllerDelegate?
    var filtersArr : [Filter] = Global.filters

    // Outlets
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var timeValue: UILabel!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var ingredientValue: UILabel!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var ingredientSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var calorieSlider: RangeSeekSlider!
    
    @IBOutlet var bubbleViews: [UIView]!
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        slidersSetUp()
        navbarSetUp()
        
        // Filters collection view set up
        let nib = UINib(nibName: filterSelectionCell.reuseIdentifier, bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: filterSelectionCell.reuseIdentifier)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
    }
    
// MARK: - Private methods
    private func slidersSetUp() {
        saveButton.layer.borderWidth = 3
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.cornerRadius = 10
        
        switch1.isOn = Global.calsOn
        switch2.isOn = Global.timeOn
        switch3.isOn = Global.ingrOn
        
        calorieSlider.isEnabled = Global.calsOn
        timeSlider.isEnabled = Global.timeOn
        ingredientSlider.isEnabled = Global.ingrOn
        
        calorieSlider.minValue = 0
        calorieSlider.maxValue = 2000
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = 180
        
        ingredientSlider.minimumValue = 0
        ingredientSlider.maximumValue = 20
        
        calorieSlider.selectedMinValue = Global.minCalValue ?? 0
        calorieSlider.selectedMaxValue = Global.maxCalValue ?? 2000
        timeSlider.value = Global.timeValue ?? 0
        ingredientSlider.value = Global.ingrValue ?? 0
        
        timeValue.text = Global.timeOn ? Int(timeSlider.value.rounded()).description + " Min" : "Off"
        ingredientValue.text = Global.ingrOn ? Int(ingredientSlider.value.rounded()).description : "Off"
        
        for bubbleView in bubbleViews {
            bubbleView.layer.cornerRadius = 10
            bubbleView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    func navbarSetUp() {
        
        navigationController?.navigationBar.topItem!.title = "Recipe Filters"
        
        // Right cancel button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelGame))
        let textAttribute2 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        let textAttribute3 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "Avenir-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute2, for: .normal)
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute3, for: .selected)
    }
    
    @objc func cancelGame() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

// MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let minCals = switch1.isOn ? Int(calorieSlider.selectedMinValue.rounded()).description : nil
        let maxCals = switch1.isOn ? Int(calorieSlider.selectedMaxValue.rounded()).description : nil
        let time = switch2.isOn ? Int(timeSlider.value.rounded()).description : nil
        let ingredients = switch3.isOn ? Int(ingredientSlider.value.rounded()).description : nil
        
        // Only return selected filters for speed improvement
        var selectedFilters : [Filter] = []
        for filter in filtersArr {
            if filter.selected == false { break }
            else {
                selectedFilters.append(filter)
            }
        }
        let filters = selectedFilters.isEmpty ? nil : selectedFilters
        
        // Pass filter values back to home vc
        delegate?.addFilters(minCal: minCals, maxCal: maxCals, time: time, ingredients: ingredients, selectedFilters: filters)
        
        // Save filter values
        Global.calsOn = switch1.isOn
        Global.timeOn = switch2.isOn
        Global.ingrOn = switch3.isOn
        Global.minCalValue = calorieSlider.isEnabled ? calorieSlider.selectedMinValue : nil
        Global.maxCalValue = calorieSlider.isEnabled ? calorieSlider.selectedMaxValue : nil
        Global.timeValue = timeSlider.isEnabled ? timeSlider.value : nil
        Global.ingrValue = ingredientSlider.isEnabled ? ingredientSlider.value : nil
        
        dismiss(animated: true)
    }
    
    @IBAction func switch1On(_ sender: Any) {
        
        calorieSlider.isEnabled = switch1.isOn
       // calorieSlider.colo
        
    }
    
    @IBAction func switch2On(_ sender: Any) {
        
        timeSlider.isEnabled = switch2.isOn
        
        if switch2.isOn {
            timeValue.text = Int(timeSlider.value.rounded()).description + " Min"
        } else {
            timeValue.text = "Off"
        }
        
    }
    
    @IBAction func switch3On(_ sender: Any) {
        ingredientSlider.isEnabled = switch3.isOn
        
        if switch3.isOn {
            ingredientValue.text = Int(ingredientSlider.value.rounded()).description
        } else {
            ingredientValue.text = "Off"
        }
    }
    
    @IBAction func timeSliderChanged(_ sender: Any) {
        
        timeValue.text = Int(timeSlider.value.rounded()).description + " Min"
        
    }
    
    @IBAction func ingredientSliderChanged(_ sender: Any) {
        
        ingredientValue.text = Int(ingredientSlider.value.rounded()).description
        
    }
    
}

// MARK: - Filers Collection View
extension FiltersViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Sort filters
        filtersArr = filtersArr.sorted { (filter1, filter2) -> Bool in
            if filter1.selected != filter2.selected { return filter1.selected }
            else { return filter1.label < filter2.label}
        }
        
        return Global.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: filterSelectionCell.reuseIdentifier, for: indexPath) as? filterSelectionCell
        else { fatalError("Could not create filter cell") }
        
        cell.displayCell(filter: filtersArr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = Global.healthFilters[indexPath.row].label
        let attributes : [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Avenir-Heavy", size: 14)!
        ]
        
        return CGSize(width: item.size(withAttributes: attributes).width+37, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Save the information of the selected item
        let selectedLabel = filtersArr[indexPath.row].label
        let selectedBool = !filtersArr[indexPath.row].selected
        
        // Flip selected property of selected element
        filtersArr[indexPath.row].selected = selectedBool
        
        // Sort the filters array with new properties
        filtersArr = filtersArr.sorted { (filter1, filter2) -> Bool in
            if filter1.selected != filter2.selected { return filter1.selected }
            else { return filter1.label < filter2.label}
        }
        
        // Find the index of changed element
        guard let newIndex = filtersArr.firstIndex(of: Filter(label: selectedLabel, selected: selectedBool, type: .none))
        else {
            fatalError("Could not find changed element")
        }
        let index = IndexPath(row: newIndex, section: indexPath.section)
        
        // Move the collection the item in the collectionView
        collectionView.performBatchUpdates {
            collectionView.moveItem(at: indexPath, to: index)
        } completion: { (completed) in
            if completed {
                collectionView.reloadItems(at: [index])
            }
        }
    }
}


