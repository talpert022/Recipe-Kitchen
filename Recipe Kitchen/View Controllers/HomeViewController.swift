//
//  ViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Variables and Outlets
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var numFoods : Int = 0
    private var fetchedRC : NSFetchedResultsController<Food>!
    
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var numFoodItems: UILabel!
    @IBOutlet weak var recipeBackground: UIImageView!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var addIngredientStack: UIStackView!
    
    let recipeData = recipeDataSource()
    let recipeDelegate = recipeCollectionViewDelegate()
    
    let filtersData = filtersDataSource()
    let filtersDelegateSource = filtersDelegate()
    
    var model = recipeModel()
    
    var selectedFood : String?
    var ingredients : [Food] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Food Items Collection View Set Up
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.isScrollEnabled = false
        
        // Recipe Collection View Set Up
        let nib = UINib(nibName: "recipeCell", bundle: nil)
        self.recipeCollectionView.register(nib, forCellWithReuseIdentifier: recipeCell.reuseIdentifier)
        recipeCollectionView.delegate = recipeDelegate
        recipeCollectionView.dataSource = recipeData
        recipeDelegate.delegate = self
        recipeCollectionView.backgroundColor = recipeBackground.backgroundColor?.withAlphaComponent(0.01)
        recipeCollectionView.contentInsetAdjustmentBehavior = .never
        
        // Filters Collection View Set up
        let nib1 = UINib(nibName: "filterCell", bundle: nil)
        self.filtersCollectionView.register(nib1, forCellWithReuseIdentifier: filterCell.reuseIdentifier)
        filtersCollectionView.delegate = filtersDelegateSource
        filtersCollectionView.dataSource = filtersData
        filtersDelegateSource.delegate = self
        filtersCollectionView.backgroundColor = recipeBackground.backgroundColor?.withAlphaComponent(0.01)
        
        // Additional setup
        model.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noResultsLabel.isHidden = true
        refresh()
        fillIngredientsArr() // food collection view data source
        numFoods = ingredients.count
        numFoodItems.text = "・\(numFoods)"
        myVariables.params.removeValue(forKey: "q")
        getRecipeData()
        addIngredientStack.isHidden = !(ingredients.count == 0)
        recipeCollectionView.isHidden = ingredients.count == 0
        self.foodCollectionView.reloadData()
        
        // Nav bar set up
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: Helpers
    
    private func refresh() {
        let request = Food.fetchRequest() as NSFetchRequest<Food>
        let sort = NSSortDescriptor(key: "enteredDate", ascending: false)
        let sort1 = NSSortDescriptor(key: "inRecipe", ascending: false)
        request.sortDescriptors = [sort1, sort]
        
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    private func updateFilters(_ filters : [Filter]) {
        
        var dietArr : [String] = []
        var healthArr : [String] = []
        
        for filter in filters {
            switch filter.type {
            case .diet:
                if filter.api == nil {
                    dietArr.append(filter.label)
                } else {
                    dietArr.append(filter.api!)
                }
            case .health:
                if filter.api == nil {
                    healthArr.append(filter.label)
                } else {
                    healthArr.append(filter.api!)
                }
            default:
                assert(false,"Unchecked filter type")
            }
        }
        
        myVariables.params["diet"] = dietArr
        myVariables.params["health"] = healthArr
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        let notSupportedMessage = UIAlertController(title: "Sorry!", message: "Saved recipes are not supported yet. We are working hard on fixing this.", preferredStyle: .alert)
        notSupportedMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            notSupportedMessage.dismiss(animated: true, completion: nil)
        }))
        
        let actionController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        actionController.addAction(UIAlertAction(title: "Saved Recipes", style: .default, handler: { (action) in
            self.present(notSupportedMessage, animated: true, completion: nil)
        }))
        actionController.addAction(UIAlertAction(title: "Kitchen", style: .default, handler: { (action) in
            self.tabBarController?.selectedIndex = 1
        }))
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    
    private func fillIngredientsArr() {
        
        ingredients.removeAll()
        
        for food in fetchedRC.fetchedObjects ?? [] {
            if food.inRecipe {
                ingredients.append(food)
            } else {
                break
            }
        }
    }
    
    private func getRecipeData() {
        
        if ingredients.count != 0 {
            // Load recipes with all the search parameters from food items
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                
                var searchStr = ""
                for str in self!.ingredients {
                    searchStr.append(str.label + " ")
                }
                myVariables.params["q"] = searchStr
                
                self?.model.getRecipes(params: myVariables.params)
                // If theres no 'q' parameter recipeModel won't return anything
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let addVC = segue.destination as! AddViewController
            addVC.delegate = self
        }
        
        if segue.identifier == "addFilters" {
            let navController = segue.destination as! UINavigationController
            let filtersVC = navController.viewControllers[0] as! FiltersViewController
            filtersVC.delegate = self
        }
        
        if segue.identifier == "recipeSegue" {
            
            let indexPath = recipeCollectionView.indexPathsForSelectedItems
            
            guard indexPath != nil else{
                return
            }
            
            let recipe = myVariables.recipes[indexPath![0].row]
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.url = recipe.url!
        }
        
        if segue.identifier == "ingredientSegue" {
            
            let ingrVC = segue.destination as! IngredientsViewController
            ingrVC.delegate = self
        }
    }
    
    // MARK: - Food Collection View
    
    private var foodsToDisplay = [String]()
    let colors = [UIColor.orange, UIColor.brown, UIColor.blue, UIColor.green, UIColor.green]
    
    let foodFont = UIFont(name: "HelveticaNeue-Bold", size: 16)!
    let itemSpacing : CGFloat = 5
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setCollectionViewDisplay()
        return foodsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = foodsToDisplay[indexPath.row]
        return CGSize(width: item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]).width+35, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCell.reuseIdentifier, for: indexPath) as? foodCell
        else { fatalError("Could not create foodCell") }
        
        cell.displayCell(foodtxt: foodsToDisplay[indexPath.row], color: colors[indexPath.row % 5])
        
        return cell
        
    }
    
    func foodStrings(foods : [Food]) -> [String] {
        
        var foodStrings : [String] = []
        for food in foods {
            foodStrings.append(food.label)
        }
        return foodStrings
    }
    
    func foodsToDisplay(foods : [String]) -> [String] {
        
        let rowWidth : CGFloat = foodCollectionView.frame.width
        let numRows = Int((foodCollectionView.frame.height-40) / 45)
        let plusBubbleWidth = "+999".width(withConstrainedHeight: 30, font: foodFont) + 10
        var display : [String] = []
        var rowWidthCounter : CGFloat = 0
        var foodIndex = 0
        
        var counter = 0
        while counter < numRows && foodIndex < foods.count {
            let food = foods[foodIndex]
            let stringWidth = food.width(withConstrainedHeight: 30, font: foodFont)
            let itemSize = stringWidth + 33.0 + itemSpacing
            
            rowWidthCounter += itemSize
            display.append(food)
            foodIndex += 1
            
            if counter < numRows-1 && rowWidthCounter > rowWidth {
                counter += 1
                rowWidthCounter = itemSize
            }
            else if counter == numRows-1 && rowWidthCounter > rowWidth - plusBubbleWidth {
                counter += 1
                display.removeLast()
                foodIndex -= 1
            }
        }
        
        // Add plus bubble
        let extra = foods.count - foodIndex
        if extra > 0 {
            display.append("+\(extra)")
        }
        return display
    }
    // Creates foods to display array
    func setCollectionViewDisplay() {
        let foodNames = foodStrings(foods: ingredients)
        foodsToDisplay = foodsToDisplay(foods: foodNames)
    }
}

// MARK: - Custom Protocols
extension HomeViewController : AddViewControllerDelegate, FiltersControllerDelegate,  recipeTransitionProtocol, recipeModelProtocol, filterSelectedProtocol, IngredientControllerDelegate {
    
    func filterSelected() {
        
        noResultsLabel.isHidden = true
        
        if ingredients.count != 0 {
            self.model.getRecipes(params: myVariables.params)
            addIngredientStack.isHidden = true
        } else {
            addIngredientStack.isHidden = false
            recipeCollectionView.isHidden = true
        }
    }
    
    func recipeSelected(_ indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: indexPath)
    }
    
    func addFoodItem(label : String, quantity: String?, expoDate: Date?, location: Int) {
        let newFood = Food(entity: Food.entity(), insertInto: context)
        newFood.label = label
        newFood.quantity = quantity
        newFood.expirationDate = expoDate
        newFood.locationEnum = Int16(location)
        newFood.enteredDate = Date()
        appDelegate.saveContext()
        refresh()
        foodCollectionView.reloadData()
        numFoods = fetchedRC.fetchedObjects?.count ?? 0
        numFoodItems.text = "・\(numFoods)"
    }
    
    func addFilters(minCal: String?, maxCal: String?, time: String?, ingredients: String?, selectedFilters : [Filter]?) {
        
        myVariables.params.removeValue(forKey: "calories")
        myVariables.params.removeValue(forKey: "time")
        myVariables.params.removeValue(forKey: "ingr")
        myVariables.params.removeValue(forKey: "diet")
        myVariables.params.removeValue(forKey: "health")
        
        if minCal != nil && maxCal != nil {
            myVariables.params["calories"] = minCal! + "-" + maxCal!
        }
        if time != nil {
            myVariables.params["time"] = time!
        }
        if ingredients != nil {
            myVariables.params["ingr"] = Int(ingredients!)
        }
        
        if selectedFilters != nil {
            updateFilters(selectedFilters!)
        }
        
        self.noResultsLabel.isHidden = true
        self.model.getRecipes(params: myVariables.params)
    }
    
    func goToRecipePage(indexPath : IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: indexPath)
    }
    
    func recipesRecieved(_ recipes: [Recipe]) {
        
        // Setting the recipes array global variable to the recipes passed back by the model
        myVariables.recipes = recipes
        recipeCollectionView.isHidden = false
        
        if recipes.count == 0 {
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
        }
        
        // Reload the collection view
        recipeCollectionView.reloadData()
        
        recipeCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .right)
    }
    
    func invalidRecipeSearch() {
        myVariables.recipes = []
        recipeCollectionView.reloadData()
        addIngredientStack.isHidden = false
    }
    
    func ingredientsReturned() {
        noResultsLabel.isHidden = true

        // Load food collection view with food items in recipe
        refresh()
        fillIngredientsArr() // food collection view data source
        
        foodCollectionView.reloadData()
        noResultsLabel.isHidden = true
        
        // Async load recipes with all the search parameters from food items
        myVariables.params.removeValue(forKey: "q")
        getRecipeData()
        addIngredientStack.isHidden = !(ingredients.count == 0)
        recipeCollectionView.isHidden = ingredients.count == 0
        numFoods = ingredients.count
        numFoodItems.text = "・\(numFoods)"
    }
}



