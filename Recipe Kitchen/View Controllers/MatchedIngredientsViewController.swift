//
//  MatchedIngredientsViewController.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/25/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit
import SwiftUI

class MatchedIngredientsViewController: UIViewController {
    
    private var matchedIngredients : [String : [String]] = [:]
    private var parentVC : HomeViewController?
    private var recipe : Recipe?
    
    init(matchedIngredients : [String : [String]], parentVC : HomeViewController, recipe : Recipe) {
        self.matchedIngredients = matchedIngredients
        self.parentVC = parentVC
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = MatchedIngredientsView(matchedItems: matchedIngredients, parentVC: parentVC, segueToRecipe: segueToRecipe)
        let child = UIHostingController(rootView: rootView)
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navigationItem.title = "Recipe Ingredients"
    }
    
    func segueToRecipe() {
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recipeVC") as! RecipeViewController
        destination.parentVC = parentVC
        destination.urlString = recipe!.url!
        destination.recipe = recipe
        parentVC?.navigationController?.pushViewController(destination, animated: true)
    }

}
