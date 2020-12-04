//
//  ViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Segmentio
import WebKit
import CoreData

struct myVariables {
    static var recipes = [Recipe]()
    static var params = [String : Any]()
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: -Variables and Outlets
    
    private let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var numFoods : Int = 0
    private var fetchedRC : NSFetchedResultsController<Food>!
    
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var numFoodItems: UILabel!
    @IBOutlet weak var recipeBackground: UIImageView!
    @IBOutlet weak var recipeOptions: Segmentio!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var getStartedLabel: UILabel!
    
    let recipeData = recipeDataSource()
    let recipeDelegate = recipeCollectionViewDelegate()
    
    var model = recipeModel()
    
    var selectedFood : String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Food Items Collection View Set Up
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        if let flowLayout = self.foodCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
          //          flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        foodCollectionView.isScrollEnabled = false
        
        // Recipe Collection View Set Up
        let nib = UINib(nibName: "recipeCell", bundle: nil)
        self.recipeCollectionView.register(nib, forCellWithReuseIdentifier: recipeCell.reuseIdentifier)
        recipeCollectionView.delegate = recipeDelegate
        recipeCollectionView.dataSource = recipeData
        recipeDelegate.delegate = self
        recipeCollectionView.backgroundColor = recipeBackground.backgroundColor?.withAlphaComponent(0.01)
        recipeCollectionView.contentInsetAdjustmentBehavior = .never
        
        //Additional Set Up
        RecipeOptionsSetUp()
        model.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        numFoods = fetchedRC.fetchedObjects?.count ?? 0
        numFoodItems.text = "・\(numFoods)"
        // Nav bar set up
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.foodCollectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let addVC = segue.destination as! AddViewController
            addVC.delegate = self
        }
        
        if segue.identifier == "addFilters" {
            let filtersVC = segue.destination as! FiltersViewController
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
    }
    
    // MARK: - Food Collection View
    
    private var foodsToDisplay = [String]()
    let colors = [UIColor.orange, UIColor.brown, UIColor.blue, UIColor.green, UIColor.green]
    
    let foodFont = UIFont(name: "HelveticaNeue-Bold", size: 16)!
    let itemSpacing : CGFloat = 5
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "foodSegue", sender: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setCollectionViewDisplay()
        return foodsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = foodsToDisplay[indexPath.row]
        return CGSize(width: item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 16)
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
            foodStrings.append(food.label!)
        }
        
        return foodStrings
    }
    
    // Might breakdown if itemSize > rowWidth for long food titles
    // Try to include items so that the container is always full
    func foodsToDisplay(foods : [String]) -> [String] {
        
        let rowWidth : CGFloat = foodCollectionView.frame.width
        let numRows = Int((foodCollectionView.frame.height-40) / 50)
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
    
    func setCollectionViewDisplay() {
        let foodNames = foodStrings(foods: fetchedRC.fetchedObjects ?? [])
        foodsToDisplay = foodsToDisplay(foods: foodNames)
    }
    // MARK: - Scrollable Control
    func RecipeOptionsSetUp() {
        
        // Scrollable Recipe Options Set Up
        var content = [SegmentioItem]()
        let item0 = SegmentioItem(title: "All Recipes", image: nil)
        content.append(item0)
        let item1 = SegmentioItem(title: "Balanced", image: nil)
        content.append(item1)
        let item2 = SegmentioItem(title: "Vegan", image: nil)
        content.append(item2)
        let item3 = SegmentioItem(title: "Vegetarian", image: nil)
        content.append(item3)
        let item4 = SegmentioItem(title: "High-Protein", image: nil)
        content.append(item4)
        let item5 = SegmentioItem(title: "Sugar-Conscious", image: nil)
        content.append(item5)
        let item6 = SegmentioItem(title: "Low-Fat", image: nil)
        content.append(item6)
        let item7 = SegmentioItem(title: "Low-Carb", image: nil)
        content.append(item7)
        
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor(displayP3Red: 164/255, green: 0, blue: 0, alpha: 0.5)
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Avenir-Heavy", size: 16)!,
                titleTextColor: UIColor(displayP3Red: 1, green: 35/255, blue: 0, alpha: 1)
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        let option1 = SegmentioIndicatorOptions(type: .bottom, ratio: 1.0, height: 3.0, color: UIColor(displayP3Red: 1, green: 35/255, blue: 0, alpha: 1))
        
        let option2 = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .white)
        
        let option3 = SegmentioVerticalSeparatorOptions(ratio: 0, color: .lightGray)
        
        let options = SegmentioOptions(backgroundColor: recipeBackground.backgroundColor!.withAlphaComponent(0.01), segmentPosition: SegmentioPosition.dynamic, scrollEnabled: true, indicatorOptions: option1, horizontalSeparatorOptions: option2, verticalSeparatorOptions: option3, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: states, animationDuration: CFTimeInterval(0.2))
        
        recipeOptions.setup(content: content, style: .onlyLabel, options: options)
        
        recipeOptions.valueDidChange = { segment, index in
            
            myVariables.params.removeValue(forKey: "diet")
            myVariables.params.removeValue(forKey: "health")
            
            switch index {
            case 0:
                self.model.getRecipes(params: myVariables.params)
            case 1:
                myVariables.params["diet"] = "balanced"
            case 2:
                myVariables.params["health"] = "vegan"
            case 3:
                myVariables.params["health"] = "vegetarian"
            case 4:
                myVariables.params["diet"] = "high-protein"
            case 5:
                myVariables.params["health"] = "sugar-conscious"
            case 6:
                myVariables.params["diet"] = "low-fat"
            case 7:
                myVariables.params["diet"] = "low-carb"
            default:
                self.model.getRecipes(params: myVariables.params)
            }
            
            self.model.getRecipes(params : myVariables.params)
        }
        
    }
}

// MARK: - Custom Protocols
extension HomeViewController : AddViewControllerDelegate, FiltersControllerDelegate, recipeTransitionProtocol, recipeModelProtocol {
    
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
        // updateIngredients()
    }
    
    func addFilters(minCal: String?, maxCal: String?, time: String?, ingredients: String?, pFree: Bool, alcFree : Bool, tnFree: Bool) {
        
        myVariables.params.removeValue(forKey: "calories")
        myVariables.params.removeValue(forKey: "time")
        myVariables.params.removeValue(forKey: "ingr")
        myVariables.params.removeValue(forKey: "health")
        
        if minCal != nil && maxCal != nil {
            myVariables.params["calories"] = minCal! + "-" + maxCal!
        }
        if time != nil {
            myVariables.params["time"] = time
        }
        if ingredients != nil {
            myVariables.params["ingr"] = Int(ingredients!)
        }
        if pFree {
            myVariables.params["health"] = "peanut-free"
        }
        if alcFree {
            myVariables.params["health"] = "alcohol-free"
        }
        if tnFree {
            myVariables.params["health"] = "tree-nut-free"
        }
        
        self.model.getRecipes(params: myVariables.params)
    }
    
    func goToRecipePage(indexPath : IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: indexPath)
    }
    
    func recipesRecieved(_ recipes: [Recipe]) {
        
        // Setting the recipes array global variable to the recipes passed back by the model
        myVariables.recipes = recipes
        
        if recipes.count == 0 {
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
        }
        
        // Reload the collection view
        recipeCollectionView.reloadData()
    }
}
// MARK: - String Extensions



