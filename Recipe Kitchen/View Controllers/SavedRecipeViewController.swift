//
//  SavedRecipeViewController.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/30/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit
import CoreData

class SavedRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC : NSFetchedResultsController<SavedRecipe>!
    private var savedRecipes : [SavedRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Saved Recipes"
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SavedRecipeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedRC.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: savedRecipeCell.reuseIdentifier, for: indexPath) as? savedRecipeCell else {
            fatalError("Could not create save recipe cell")
        }
        
        cell.displayCell(recipe: fetchedRC.fetchedObjects![indexPath.row])
        
        return cell
    }
    
}
