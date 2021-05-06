//
//  IngredientsViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/25/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import CoreData

protocol IngredientControllerDelegate {
  func ingredientsReturned()
}

class IngredientsViewController: UIViewController {
  
  // MARK: - Varaibles and Outlets
  
  private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var fetchedRC : NSFetchedResultsController<Food>!
  
  @IBOutlet weak var kitchenStack: UIStackView!
  @IBOutlet weak var kitchenButton: addButton!
  @IBOutlet weak var ingredientTableView: UITableView!
  @IBOutlet weak var expireSegment: UISegmentedControl!
  @IBOutlet weak var ingredientView: UIView!
  @IBOutlet weak var saveButton: UIButton!
  
  var delegate : IngredientControllerDelegate?
  var expiringSoonSelected : Bool = false
  var expiringSoon : [Food] = []
  var expiredSelected : Bool = false
  var expired : [Food] = []
  var ingredientsCounter : Int = 0
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    refresh()
    // Do any additional setup after loading the view.
    ingredientTableView.delegate = self
    ingredientTableView.dataSource = self
    
    for food in fetchedRC.fetchedObjects ?? [] {
      if food.inRecipe {
        ingredientsCounter += 1
      }
    }
    
    saveButton.setTitle("Create Recipe: \(ingredientsCounter) items", for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if fetchedRC.fetchedObjects?.count == 0 {
      ingredientTableView.isHidden = true
      kitchenStack.isHidden = false
    }
  }
  
  // MARK: - Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "addIngredient" {
      let addVC = segue.destination as! AddViewController
      addVC.delegate = self
    }
  }
  // MARK: - Private methods
  
  
  private func setUp() {
    ingredientView.layer.cornerRadius = 15
    saveButton.roundedButton()
    
    kitchenButton.layer.borderWidth = 4
    kitchenButton.layer.borderColor = UIColor.darkGray.cgColor
    kitchenButton.layer.shadowColor = UIColor.black.cgColor
    kitchenButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    kitchenButton.layer.shadowRadius = 8
    kitchenButton.layer.shadowOpacity = 0.5
    
  }
  
  private func refresh() {
    let request = Food.fetchRequest() as NSFetchRequest<Food>
    let sort = NSSortDescriptor(key: "enteredDate", ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      try fetchedRC.performFetch()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  private func fillExpireSoonArr() {
    
    expiringSoon.removeAll()
    
    for food in fetchedRC.fetchedObjects ?? [] {
      if food.expirationStatus == .expiring {
        expiringSoon.append(food)
      }
    }
  }
  
  private func fillExpiredArr() {
    
    expired.removeAll()
    
    for food in fetchedRC.fetchedObjects ?? [] {
      if food.expirationStatus == .expired {
        expired.append(food)
      }
    }
  }
  
  // MARK: - Actions
  
  @IBAction func createRecipeTapped(_ sender: Any) {
    
    appDelegate.saveContext()
    dismiss(animated: true, completion: nil)
    
    if let delegate = delegate {
      delegate.ingredientsReturned()
    }
    
  }
  
  
  @IBAction func cancelTapped(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
  }
  
  
  @IBAction func gotoKitchenTapped(_ sender: Any) {
    
    if let delegate = delegate as? HomeViewController {
      let tabBar = delegate.tabBarController!
      tabBar.selectedIndex = 1
    }
    dismiss(animated: false, completion: nil)
  }
  
  
  @IBAction func addNewIngredient(_ sender: Any) {
    performSegue(withIdentifier: "addIngredient", sender: sender)
  }
  
  @IBAction func segmentChanged(_ sender: Any) {
    
    switch expireSegment.selectedSegmentIndex {
    case 0:
      expiringSoonSelected = false
      expiredSelected = false
      ingredientTableView.reloadData()
    case 1:
      expiredSelected = false
      expiringSoonSelected = true
      fillExpireSoonArr()
      ingredientTableView.reloadData()
    case 2:
      expiringSoonSelected = false
      expiredSelected = true
      fillExpiredArr()
      ingredientTableView.reloadData()
    default:
      assert(false, "No such segment exists")
    }
  }
  
}

// MARK: - Ingredients table view
extension IngredientsViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if expiringSoonSelected {
      return expiringSoon.count
    } else if expiredSelected {
      return expired.count
    } else {
      return fetchedRC.fetchedObjects?.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCell.reuseIdentifier, for: indexPath) as? ingredientCell
    else { fatalError("Could not create ingredient cell") }
    
    var x : Bool = false
    let food : Food
    if expiringSoonSelected {
      food = expiringSoon[indexPath.row]
    } else if expiredSelected {
      food = expired[indexPath.row]
    } else {
      x = true
      food = fetchedRC.object(at: indexPath)
    }
    cell.displayCell(food: food)
    cell.warningLabel.isHidden = x
    
    let greenView = UIView()
    greenView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
    
    let redView = UIView()
    redView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    
    cell.selectedBackgroundView = food.inRecipe ? redView : greenView
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let ingredient : Food
    if expiringSoonSelected {
      ingredient = expiringSoon[indexPath.row]
    } else if expiredSelected {
      ingredient = expired[indexPath.row]
    } else {
      ingredient = fetchedRC.object(at: indexPath)
    }
    
    ingredientsCounter += ingredient.inRecipe ? -1 : 1
    ingredient.inRecipe = !ingredient.inRecipe
    tableView.reloadRows(at: [indexPath], with: .automatic)
    // Try in the future to only change property once save button is hit
    
    saveButton.setTitle("Create Recipe: \(ingredientsCounter) items", for: .normal)
    
  }
  
}

// MARK: - Handle add
extension IngredientsViewController : AddViewControllerDelegate {
  
  func addFoodItem(label: String, quantity: String?, expoDate: Date?, location: Int) {
    let newFood = Food(entity: Food.entity(), insertInto: context)
    newFood.label = label
    newFood.quantity = quantity
    newFood.expirationDate = expoDate
    newFood.locationEnum = Int16(location)
    newFood.enteredDate = Date()
    appDelegate.saveContext()
    refresh()
    ingredientTableView.reloadData()
  }
  
}
