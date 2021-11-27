//
//  recipeCell.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 7/28/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Alamofire

class recipeCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: recipeCell.self)
    
    @IBOutlet weak var numIngredients: UIButton!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cookTime: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    
    private var recipeToDisplay : Recipe?
    private var ownedIngredientsCount : Int = 0
    var parentVC : HomeViewController?
    var matchedIngredients : [String : [String]] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
     ----------
     Sets properties for recipe cell before displaying and fetches image from edamin api
     ----------
     */
    func displayRecipe(_ recipe: Recipe) {
        
        // Clean up the cell before dipslaying
        customizeCell()
        
        // Keep a refrence to the recipe
        recipeToDisplay = recipe
        
        // Set the labels in the recipe cell
        configureLabels(recipeToDisplay: recipeToDisplay!)
        
        // Download and display image data
        
        // Check that the recipe has an image
        guard recipeToDisplay!.image != nil else {
            recipeImage.image = UIImage(named: "default")
            return
        }
        
        let urlString = recipeToDisplay!.image!
        
        // Check the cachemanager before downloading any image data
        if let imageData = CacheManager.retrieveData(urlString) {
            
            // There is image data, set the imageview and return
            recipeImage.image = UIImage(data: imageData)
            return
        }
        
        // Create the url
        let url = URL(string: urlString)
        
        // Check that the url isn't nil
        guard url != nil else {
            print("Couldn't create url object")
            return
        }
        
        // Get a URLSession
        let session = URLSession.shared
        
        // Create a datatask
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check that there were no errors
            if error == nil && data != nil {
                
                // Save the data into cache
                CacheManager.saveData(urlString, data!)
                
                // Check if the url string that the data task went off to download matches the article this cell is set to display
                if self.recipeToDisplay!.image == urlString {
                    
                    DispatchQueue.main.async {
                        // Display the image data in the image view
                        self.recipeImage.image = UIImage(data: data!)
                    }
                    
                }
                
            } // End if
            
        } // End data task
        
        // Kick off the datatask
        dataTask.resume()
    }
    
    /// Creates a dictionary that maps recipe ingredients to an array of corresponding local ingredients or an array with one default value if the user does not have the ingredient
    func setMatchedIngredients(selectedIngredients : [String]?, recipe: Recipe) {
        guard let myItems = selectedIngredients else {
            return
        }
        
        var myIngredients = myItems.reduce([String : Bool]()) { (dict, ingr) -> [String : Bool] in
            var dict = dict
            dict[ingr] = false
            return dict
        }
        
        guard let recipeItems = recipe.ingredients else {
            return
        }
        
        for recipeIngr in recipeItems {
            var matched = false
            for ingr in myItems {
                if myIngredients[ingr] == false {
                    if recipeIngr.text != nil && recipeIngr.text!.contains("\(ingr.lowercased())") {
                        matched = true
                        matchedIngredients[recipeIngr.text!] = matchedIngredients[recipeIngr.text!, default: []] + [ingr]
                        ownedIngredientsCount += 1
                        myIngredients.updateValue(true, forKey: ingr)
                    }
                }
            }
            
            if !matched && recipeIngr.text != nil {
                matchedIngredients.updateValue([Global.NO_LOCAL_INGR_MATCH], forKey: recipeIngr.text!)
            }
            
        }
        
    }
    
    //MARK: - Helpers
    func customizeCell() {
        
        // Save Button Set Up
        saveButton.backgroundColor = UIColor.white
        saveButton.tintColor = UIColor(displayP3Red: 164/255, green: 0, blue: 0, alpha: 1.0)
        saveButton.layer.cornerRadius = 18
        
        // Recipe image set up
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.layer.cornerRadius = 10
        
        // numIngredients Label Set Up
        numIngredients.layer.backgroundColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        numIngredients.layer.cornerRadius = 14
        
        healthLabel.textColor = UIColor.green.darker()
        
    }
    
    func configureLabels(recipeToDisplay : Recipe) {
        recipeTitle.text = recipeToDisplay.label
        cookTime.text = (Int((recipeToDisplay.totalTime ?? 0)).description) + " min"
        if recipeToDisplay.dietLabels?.count == 0 {
            healthLabel.text = ""
        } else {
            healthLabel.text = recipeToDisplay.dietLabels![0]
        }
        
        if ownedIngredientsCount > 0 {
            numIngredients.setTitle(ownedIngredientsCount.description + "/" + (recipeToDisplay.ingredients?.count.description ?? "0") + " ingredients", for: .normal)
        } else {
            numIngredients.setTitle((recipeToDisplay.ingredients?.count.description ?? "0") + " ingredients", for: .normal)
        }
    }
    
    func clean() {
        ownedIngredientsCount = 0
        matchedIngredients = [:]
    }
    
    //MARK: - Actions
    @IBAction func ingredientsPressed(_ sender: Any) {
        
        guard let parentVC = parentVC else {
            return
        }
        
        parentVC.navigationController?.pushViewController(MatchedIngredientsViewController(matchedIngredients: matchedIngredients, parentVC: parentVC, recipe: recipeToDisplay!), animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if saveButton.isSelected == false {
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            saveButton.isSelected = true
        } else {
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
            saveButton.isSelected = false
        }
    }
}

