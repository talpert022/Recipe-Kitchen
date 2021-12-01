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
        
        recipeTitle.text = recipe.title ?? ""
        recipeImage.layer.cornerRadius = 5
        
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
        
    }
    
}
