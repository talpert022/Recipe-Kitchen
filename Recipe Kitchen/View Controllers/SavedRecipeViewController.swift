//
//  SavedRecipeViewController.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/30/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit
import CoreData

protocol SaveRecipeHandlerProtocol {
    func saveRecipe(_ recipe : Recipe?,_ savedRecipe : SavedRecipe?, id : String)
    func unsaveRecipe(recipeId : String)
    func checkRecipeIsSaved(recipeId : String) -> Bool
}

class SavedRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC : NSFetchedResultsController<SavedRecipe>!
    private var savedRecipes : [SavedRecipe] = []
    public var parentVC : HomeViewController?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Saved Recipes"
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.pullRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
        tableView.reloadData()
    }
    
    @objc func pullRefresh(_ sender: AnyObject) {
        refresh()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func refresh() {
        let request = SavedRecipe.fetchRequest() as NSFetchRequest<SavedRecipe>
        let dateSort = NSSortDescriptor(key: "enteredDate", ascending: false)
        request.sortDescriptors = [dateSort]
        
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "recipeSegue" {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            guard indexPath != nil else {
                return
            }
            
            let recipeVC = segue.destination as! RecipeViewController
            let savedRecipe = fetchedRC.fetchedObjects![indexPath!.row]
            recipeVC.parentVC = parentVC
            recipeVC.id = savedRecipe.id!
        }
    }
}

extension SavedRecipeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedRC.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: savedRecipeCell.reuseIdentifier, for: indexPath) as? savedRecipeCell else {
            fatalError("Could not create save recipe cell")
        }
        
        cell.parentVC = parentVC
        cell.displayCell(recipe: fetchedRC.fetchedObjects![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: indexPath)
    }
    
}
