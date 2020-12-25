//
//  PantryViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/6/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Segmentio
import CoreData

class PantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddViewControllerDelegate {

    // MARK: - Variables and Outlets
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Food>!
    var selectedFoods : [Food] = []
    var segmentSelected : Bool = false
    var editingFood : Food?
    
    @IBOutlet weak var doneButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var addButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var addButton: addButton!
    @IBOutlet weak var deleteButton: addButton!
    @IBOutlet weak var doneButton: addButton!
    @IBOutlet weak var editItemsButton: UIButton!
    @IBOutlet weak var segmentView: Segmentio!
    @IBOutlet weak var foodInfoTableView: UITableView!
    @IBOutlet weak var foodTableView: UITableView!
    
    var deleteActive : Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodInfoTableView.delegate = self
        foodInfoTableView.dataSource = self
        
        configureUI()
        refresh()
        
        segmentView.selectedSegmentioIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
   
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addSegue" {
            let addVC = segue.destination as! AddViewController
            addVC.delegate = self
        }
        
        if segue.identifier == "editSegue" {
            let editVC = segue.destination as! EditViewController
            editVC.selectedFood = editingFood!
            editVC.delegate = self
        }
    }
    
    // MARK: - Helper methods
    
    private func refresh() {
        let request = Food.fetchRequest() as NSFetchRequest<Food>
        
        // TODO: Set up search results controller and query request for data
        
        let sort = NSSortDescriptor(key: "enteredDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
            foodTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func addFoodItem(label: String, quantity: String?, expoDate: Date?, location: Int) {
        let newFood = Food(entity: Food.entity(), insertInto: context)
        newFood.label = label
        newFood.quantity = quantity
        newFood.expirationDate = expoDate
        newFood.locationEnum = Int16(location)
        newFood.enteredDate = Date()
        appDelegate.saveContext()
        refresh()
        self.foodTableView.reloadData()
    }
    
    func configureUI() {
        segmentViewSetUp()
        self.foodInfoTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        navigationController?.navigationBar.tintColor = .black
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Edit Items", attributes: underlineAttribute)
        
        editItemsButton.titleLabel?.attributedText = underlineAttributedString
        
        // button constraints
        addButtonTrailing.constant = -100
        deleteButtonTrailing.constant = -100
        doneButtonTrailing.constant = -100
        
        doneButton.layer.borderColor = UIColor.black.cgColor
        doneButton.layer.borderWidth = 3
    }
    
    func fillSelectedFoods(index : Int) {
        
        selectedFoods.removeAll()
        
        if index == 0 {
            segmentSelected = false
        } else {
            segmentSelected = true
            for food in fetchedRC.fetchedObjects ?? [] {
                if food.locationEnum == index {
                    selectedFoods.append(food)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func editItemsButtonTapped(_ sender: Any) {
        
        editItemsButton.isHidden = true
        
        addButton.isHidden = false
        deleteButton.isHidden = false
        doneButton.isHidden = false
        
        addButtonTrailing.constant = 180
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        deleteButtonTrailing.constant = 88
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        doneButtonTrailing.constant = 20
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        doneButtonTrailing.constant = -100
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        deleteButtonTrailing.constant = -100
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        addButtonTrailing.constant = -100
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.editItemsButton.isHidden = false
        }
        
        deleteActive = false
        foodTableView.reloadData()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        deleteActive = !deleteActive
        
        foodTableView.reloadData()
    }
    
    @IBAction func deleteFood(_ sender: UIButton) {
        
        let itemIndex = sender.tag
        print(itemIndex)
    }
    
    
    
    // MARK: - Segment Set Up
    
    func segmentViewSetUp() {
        
        var content = [SegmentioItem]()
        let item0 = SegmentioItem(title: "All Items", image: nil)
        content.append(item0)
        let item1 = SegmentioItem(title: "Fridge", image: nil)
        content.append(item1)
        let item2 = SegmentioItem(title: "Freezer", image: nil)
        content.append(item2)
        let item3 = SegmentioItem(title: "Dry Pantry", image: nil)
        content.append(item3)
        let item4 = SegmentioItem(title: "Spice Rack", image: nil)
        content.append(item4)
        
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor.gray
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor(displayP3Red: 0, green: 240/255, blue: 0, alpha: 1)
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor(displayP3Red: 0, green: 240/255, blue: 0, alpha: 1)
            )
        )
        
        let option1 = SegmentioIndicatorOptions(type: .bottom, ratio: 1.0, height: 3.0, color: UIColor(displayP3Red: 0, green: 240/255, blue: 0, alpha: 1))
        
        let option2 = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .white)
        
        let option3 = SegmentioVerticalSeparatorOptions(ratio: 0, color: .white)
        
        let options = SegmentioOptions(backgroundColor: UIColor.white, segmentPosition: SegmentioPosition.dynamic, scrollEnabled: true, indicatorOptions: option1, horizontalSeparatorOptions: option2, verticalSeparatorOptions: option3, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: states, animationDuration: CFTimeInterval(0.2))
        
        segmentView.setup(content: content, style: .onlyLabel, options: options)
        
        segmentView.valueDidChange = { segment, index in
            self.fillSelectedFoods(index : index)
            self.foodTableView.reloadData()
        }
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !segmentSelected {
            return fetchedRC.fetchedObjects?.count ?? 0
        } else {
            return selectedFoods.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = foodInfoTableView.dequeueReusableCell(withIdentifier: foodInfoCell.reuseIdentifier, for: indexPath) as? foodInfoCell else {
            fatalError("Could not create recipe cell")
        }
        
        cell.containerViewSetUp()
        
        if !segmentSelected {
            cell.displayFood(food: fetchedRC.object(at: indexPath))
        } else {
            cell.displayFood(food: selectedFoods[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            // Delete item from persistent store
            let food : Food
            if !self.segmentSelected {
                food = self.fetchedRC.object(at: indexPath)
            } else {
                food = self.selectedFoods[indexPath.row]
            }
            self.context.delete(food)
            self.appDelegate.saveContext()
            tableView.beginUpdates()
            self.refresh()
    
            if self.segmentSelected {
                self.selectedFoods.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
            if !self.segmentSelected {
                self.editingFood = self.fetchedRC.object(at: indexPath)
            } else {
                self.editingFood = self.selectedFoods[indexPath.row]
            }
            self.performSegue(withIdentifier: "editSegue", sender: indexPath)
        }
        editAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 119/255, blue: 1, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }

}

// MARK: - Done Editing Protocol
extension PantryViewController : editProtocol {
    
    func doneEditing() {
        foodTableView.reloadData()
    }
    
}


