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
import DropDown

enum sortedStatus {
    case recentlyAdded
    case expirationDateClosestFirst
    case expirationDateFarthestFirst
}
extension sortedStatus : CaseIterable {
    var description : String {
        switch self {
        case .recentlyAdded:
                return "Recently Added"
        case .expirationDateClosestFirst:
                return "Expiration Date - Sooner"
        case .expirationDateFarthestFirst:
                return "Expiration Date - Later"
        }
    }
}

class PantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddViewControllerProtocol {

    // MARK: - Variables and Outlets
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Food>!
    private let dropDown = DropDown()
    var foodArr : [Food] = []
    var editingFood : Food?
    var selectedIndex : Int = 0
    var sortStatus : sortedStatus = .recentlyAdded
    
    @IBOutlet weak var segmentView: Segmentio!
    @IBOutlet weak var foodInfoTableView: UITableView!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    //   @IBOutlet weak var sortingDropDown: DropDown!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodInfoTableView.delegate = self
        foodInfoTableView.dataSource = self
        foodInfoTableView.isHidden = false
        
        setUpNaviagtion()
        configureUI()
        refresh()
        fillFoodArr(index: selectedIndex, sort: sortStatus)
        
        segmentView.selectedSegmentioIndex = 0
    }
  
  // Needed for if new food items are created from ingredients view controller
  override func viewWillAppear(_ animated: Bool) {
    refresh()
    fillFoodArr(index: selectedIndex, sort: sortStatus)
    foodTableView.reloadData()
  }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addSegue" {
            let addVC = segue.destination as! AddViewController
            addVC.delegate = self
            addVC.location = segmentView.selectedSegmentioIndex
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
        let sort = NSSortDescriptor.init(key: "enteredDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
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
        fillFoodArr(index: selectedIndex, sort: sortStatus)
        self.foodTableView.reloadData()
    }
    
    private func setUpNaviagtion() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "My Kitchen"
        navigationController?.navigationBar.titleTextAttributes =
            [
              NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 164/255, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 164/255, green: 0, blue: 0, alpha: 1)
        

        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "sortIconWhite"), for: .normal)
        rightButton.setImage(UIImage(named: "sortIconGray"), for: .selected)
        rightButton.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
        rightButton.tag = 1
        navigationController?.navigationBar.addSubview(rightButton)
        rightButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 20)
        let targetView = self.navigationController?.navigationBar
        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
                                                    .trailingMargin, relatedBy: .equal, toItem: targetView,
                                                   attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                                  toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -6)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])

    }
    
    func configureUI() {
        segmentViewSetUp()
        self.foodInfoTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        addButton.layer.cornerRadius = 3
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.white.cgColor
        let view = navigationController?.navigationBar.subviews[0]
        dropDown.anchorView = navigationController?.navigationBar.subviews[0]
        dropDown.dataSource = ["Sort By: Recently Added", "Sort By: Expiration Date - Sooner", "Sort By: Expiration Date - Later"]
        dropDown.width = 350
        dropDown.cellHeight = 50
        DropDown.appearance().selectionBackgroundColor = UIColor.systemTeal
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: (view?.bounds.width)!+100, y: (view?.bounds.height)!+100)
        dropDown.selectRow(at: 0)
        
        dropDown.selectionAction = {  (index: Int, item: String) in
            switch index {
            case 0:
                self.sortStatus = .recentlyAdded
                self.fillFoodArr(index: self.selectedIndex, sort: self.sortStatus)
                self.foodInfoTableView.reloadData()
            case 1:
                self.sortStatus = .expirationDateClosestFirst
                self.fillFoodArr(index: self.selectedIndex, sort: self.sortStatus)
                self.foodInfoTableView.reloadData()
            case 2:
                self.sortStatus = .expirationDateFarthestFirst
                self.fillFoodArr(index: self.selectedIndex, sort: self.sortStatus)
                self.foodInfoTableView.reloadData()
            default:
                assert(false, "This segment doesn't exist")
            }
            self.dropDown.hide()
        }
    }

    @objc func rightButtonTapped(_: Int) {
        dropDown.show()
    }
    
    /*
      Fills foodArr, the list that the table view uses as data with the correct food items
      based on the location segment, and sorted status variables
    */
    func fillFoodArr(index : Int, sort : sortedStatus) {
        
        foodArr.removeAll()
        
        if index != 0 {
            for food in fetchedRC.fetchedObjects ?? [] {
                if food.locationEnum == index {
                    foodArr.append(food)
                }
            }
        } else {
            foodArr = fetchedRC.fetchedObjects ?? []
        }
        
        if sort != .recentlyAdded {
            if sort == .expirationDateClosestFirst {
                foodArr.sort { (f1, f2) -> Bool in
                    let date1 = f1.expirationDate
                    let date2 = f2.expirationDate
                    
                    if date1 != nil && date2 != nil {
                        if date1! > date2! { return false }
                        else if date2! > date1! { return true }
                        else { return true }
                    } else {
                        if date1 == nil && date2 != nil { return false }
                        else if date1 != nil && date2 == nil { return true}
                        else { return true }
                    }
                }
            }
            if sort == .expirationDateFarthestFirst {
                foodArr.sort { (f1, f2) -> Bool in
                    let date1 = f1.expirationDate
                    let date2 = f2.expirationDate
                    
                    if date1 != nil && date2 != nil {
                        if date1! > date2! { return true }
                        else if date2! > date1! { return false }
                        else { return true }
                    } else {
                        if date1 == nil && date2 != nil { return true }
                        else if date1 != nil && date2 == nil { return false}
                        else { return true }
                    }
                }
            }
        }
    }
    
    // MARK: - Segment Set Up
    
    func segmentViewSetUp() {
        
        var content = [SegmentioItem]()
        let item0 = SegmentioItem(title: " All Items", image: nil)
        content.append(item0)
        let item1 = SegmentioItem(title: "Fridge", image: nil)
        content.append(item1)
        let item2 = SegmentioItem(title: "Freezer", image: nil)
        content.append(item2)
        let item3 = SegmentioItem(title: "Pantry", image: nil)
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
                titleTextColor: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
        
        let option1 = SegmentioIndicatorOptions(type: .bottom, ratio: 1.0, height: 3.0, color: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1))
        
        let option2 = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .white)
        
        let option3 = SegmentioVerticalSeparatorOptions(ratio: 0, color: .white)
        
        let options = SegmentioOptions(backgroundColor: UIColor.white, segmentPosition: SegmentioPosition.dynamic, scrollEnabled: true, indicatorOptions: option1, horizontalSeparatorOptions: option2, verticalSeparatorOptions: option3, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: states, animationDuration: CFTimeInterval(0.2))
        
        segmentView.setup(content: content, style: .onlyLabel, options: options)
        
        segmentView.backgroundColor = UIColor(red: 164/255, green: 0, blue: 0, alpha: 1)
        
        segmentView.valueDidChange = { segment, index in
            
            self.selectedIndex = index
            self.fillFoodArr(index: self.selectedIndex, sort: self.sortStatus)
            self.foodTableView.reloadData()
        }
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = foodInfoTableView.dequeueReusableCell(withIdentifier: foodInfoCell.reuseIdentifier, for: indexPath) as? foodInfoCell else {
            fatalError("Could not create recipe cell")
        }
        
        cell.containerViewSetUp()
        cell.displayFood(food: foodArr[indexPath.row])
        
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
            let food = self.foodArr[indexPath.row]
            self.context.delete(food)
            self.appDelegate.saveContext()
            tableView.beginUpdates()
            self.refresh()
            self.fillFoodArr(index: self.selectedIndex, sort: self.sortStatus)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
                        
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
            self.editingFood = self.foodArr[indexPath.row]
            self.performSegue(withIdentifier: "editSegue", sender: indexPath)
        }
        editAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 119/255, blue: 1, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }

}

// MARK: - Done Editing Protocol
extension PantryViewController : EditControllerDelegate {
    
    func doneEditing() {
        foodTableView.reloadData()
    }
    
}


