//
//  BuildRecipeViewController.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/14/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit
import SwiftUI

class BuildRecipeViewController: UIViewController {
    
    /*
     This view controller hosts the SwiftUI view found in RecipeKitchen/Views folder in the file BuildRecipeView.swift. The implementation for its
     functionality lives there.
     */

    @IBOutlet weak var hostingView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate : AddMultipleIngredientsProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let rootView = BuildRecipeView(delegate: delegate, dismissView: dismissView)
        let child = UIHostingController(rootView: rootView)
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        hostingView.addSubview(child.view)
        child.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            child.view.widthAnchor.constraint(equalTo: hostingView.widthAnchor),
            child.view.heightAnchor.constraint(equalTo: hostingView.heightAnchor),
            child.view.centerXAnchor.constraint(equalTo: hostingView.centerXAnchor),
            child.view.centerYAnchor.constraint(equalTo: hostingView.centerYAnchor)
        ])
        
        hostingView.layer.cornerRadius = 15
        hostingView.addSubview(cancelButton)
        
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
