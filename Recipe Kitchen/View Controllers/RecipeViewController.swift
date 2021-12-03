//
//  RecipeViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/3/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import WebKit
import SwiftUI

class RecipeViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var parentVC : HomeViewController?
    public var recipe : Recipe?
    private var isSaved : Bool = false
    var urlString = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        spinner.startAnimating()
        spinner.isHidden = false
        spinner.hidesWhenStopped = true
        
        var url : URL?
        if urlString.isEmpty {
            loadRecipeModel() { [weak self] in
                
                guard let self = self else {
                    return
                }
                
                url = URL(string: self.recipe!.url!)
                self.webView.load(URLRequest(url: url!))
                self.configureNavBar()
            }
        } else {
            url = URL(string: urlString)
            webView.load(URLRequest(url: url!))
            id = getRecipeId(recipeURI: recipe!.uri ?? "")
            configureNavBar()
        }
    }
    
    func configureNavBar() {
        isSaved = parentVC!.checkRecipeIsSaved(recipeId: id)
        let savedImage = UIImage(systemName: isSaved ? "heart.fill" : "heart")
        let savedRecipeItem = UIBarButtonItem(image: savedImage, style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = savedRecipeItem
    }
    
    @objc func saveButtonTapped() {
        
        if isSaved {
            parentVC!.unsaveRecipe(recipeId: id)
            isSaved = false
            let savedRecipeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = savedRecipeItem
        } else {
            parentVC!.saveRecipe(recipe, nil, id: id)
            isSaved = true
            let savedRecipeItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = savedRecipeItem
        }
    }
    
    func getRecipeId(recipeURI : String) -> String {
        var id = ""
        for char in recipeURI.reversed() {
            if char == "_" {
                break
            }
            id.insert(char, at: id.startIndex)
        }
        
        return id
    }
    
    func loadRecipeModel(completionHandler : @escaping () -> Void) {
        var network: RecipeModel? = RecipeModel()
        network!.delegate1 = self
        network!.getSingleRecipe(id: id, completionHandler: completionHandler)
        network = nil
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
}

extension RecipeViewController : SingleRecipeProtocol {
    
    func recieveSingleRecipe(recipe: Recipe) {
        self.recipe = recipe
    }
}
