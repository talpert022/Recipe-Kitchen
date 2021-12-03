//
//  savedRecipeCell.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/30/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit

class savedRecipeCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: savedRecipeCell.self)
    
    private var savedRecipeToDisplay : SavedRecipe?
    private var fullRecipe : Recipe?
    private var matchedIngredients : [String : [String]]?
    private var recipeIsSaved = true
    var parentVC : HomeViewController?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var savedButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayCell(recipe : SavedRecipe) {
        
        // Keep reference to the recipe
        savedRecipeToDisplay = recipe
        
        // Set up heart button and recipe titile text
        recipeTitle.text = recipe.title ?? ""
        recipeImage.layer.cornerRadius = 5
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.savedImageTapped))
        savedButton.addGestureRecognizer(tapGR)
        savedButton.isUserInteractionEnabled = true
        
        // Check that the recipe has an image
        guard recipe.imageUrl != nil else {
            recipeImage.image = UIImage(named: "default")
            return
        }
        
        let urlString = recipe.imageUrl!
        
        // Check the cachemanager before downloading any image data
        if let imageData = CacheManager.retrieveData(urlString) {
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
        
        // Create a datatask
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            // Check that there were no errors
            if error == nil && data != nil {
                
                // Save the data into cache
                CacheManager.saveData(urlString, data!)
                
                // Check if the url string that the data task went off to download matches the article this cell is set to display
                if recipe.imageUrl == urlString {
                    
                    DispatchQueue.main.async {
                        // Display the image data in the image view
                        self.recipeImage.image = UIImage(data: data!)
                    }
                    
                }
                
            } // End error and data check
            
        } // End data task
        
        // Kick off the datatask
        dataTask.resume()
    }
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        
        let completion : () -> Void = { [weak self] in
            
            guard let self = self else { return }
            
            var recipeCell : recipeCell? = recipeCell()
            self.matchedIngredients = recipeCell!.setMatchedIngredients(selectedIngredients: self.parentVC?.foodsToDisplay, recipe: self.fullRecipe!)
            recipeCell = nil
            
            guard let parentVC = self.parentVC else {
                return
            }
            
            parentVC.navigationController?.pushViewController(MatchedIngredientsViewController(matchedIngredients: self.matchedIngredients!, parentVC: parentVC, recipe: self.fullRecipe!), animated: true)
        }
        
        // Load recipe from recipe ID
        var network : RecipeModel? = RecipeModel()
        network?.delegate1 = self
        network?.getSingleRecipe(id: savedRecipeToDisplay!.id!, completionHandler: completion)
        network = nil
    }
    
    @objc func savedImageTapped(sender : UITapGestureRecognizer) {
        
        guard let parentVC = parentVC else {
            return
        }
        
        if recipeIsSaved {
            parentVC.unsaveRecipe(recipeId: savedRecipeToDisplay!.id!)
            recipeIsSaved = false
            savedButton.image = UIImage(systemName: "heart")
        } else {
            parentVC.saveRecipe(nil, savedRecipeToDisplay!, id: savedRecipeToDisplay!.id!)
            recipeIsSaved = true
            savedButton.image = UIImage(systemName: "heart.fill")
        }
    }
    
}

extension savedRecipeCell : SingleRecipeProtocol {
    
    func recieveSingleRecipe(recipe: Recipe) {
        fullRecipe = recipe
    }
    
}
