//
//  MatchedIngredientsView.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/24/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import SwiftUI

struct MatchedIngredientsView: View {
        
    let matchedItems : [String : [String]]
    var parentVC : HomeViewController?
    let segueToRecipe : (() -> Void)
    
    var body: some View {
        let matchedLocalIngredients = getmatchedLocalIngredients()
                
        VStack(alignment: .center, spacing: 7) {
            
            SeeRecipeButton(segueToRecipe: segueToRecipe)
                .padding()
            
            Text("Ingredients Matched: \(matchedLocalIngredients.count)/\(parentVC?.foodsToDisplay.count ?? 0)")
                .font(.custom("Avenir", size: 15.0))
                .foregroundColor(Color(red: 0, green: 0, blue: 0))
                .alignmentGuide(HorizontalAlignment.center, computeValue: { _ in 170.0 })
            
            ExDivider()
            
            VStack {
                MatchedLocalIngredients(parentVC: parentVC, matchedItems: matchedItems, matchedLocalIngredients: matchedLocalIngredients)
            }
            .padding(.bottom, 19)
            .padding(.top, 4)
            
            Text("All Recipe Ingredients")
                .font(.custom("Avenir", size: 15.0))
                .foregroundColor(Color(red: 0, green: 0, blue: 0))
                .alignmentGuide(HorizontalAlignment.center, computeValue: { _ in 170.0 })
            
            List {
                MatchedSection(matchedItems: matchedItems)
                UnmatchedSection(matchedItems: matchedItems)
            }
            
        }.frame(alignment: .center).navigationBarTitle(Text("Recipe Ingredients"))
        
    }
    
    func getmatchedLocalIngredients() -> [String] {
        var localIngredients : [String] = []
        for localIngr in matchedItems.values {
            if localIngr.first != Global.NO_LOCAL_INGR_MATCH {
                localIngredients += localIngr
            }
        }
        return localIngredients
    }
}

struct MatchedIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedIngredientsView(matchedItems: ["1/3 lbs chicken" : ["Chicken"], "1/3 lbs pork" : [Global.NO_LOCAL_INGR_MATCH]], parentVC: nil, segueToRecipe: {})
    }
}

struct UnmatchedSection: View {
    let matchedItems : [String : [String]]
    
    var body: some View {
        let recipeIngredients = matchedItems.map { $0.key }
        
        // If recipe ingredient has no matching local ingredient
        Section(header: Text("Unmatched Ingredients")) {
            ForEach(recipeIngredients, id: \.self) { ingr in
                if matchedItems[ingr]?.first == Global.NO_LOCAL_INGR_MATCH {
                    HStack {
                        Text(ingr)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add to Grocery List")
                                .font(.custom("Avenir", size: 12.0))
                        }
                    }
                }
            }
        }
    }
}

struct MatchedSection: View {
    let matchedItems : [String : [String]]
    
    var body: some View {
        let recipeIngredients = matchedItems.map { $0.key }
        
        // If recipe does have matching local ingredients
        Section(header: Text("Matched Ingredients")) {
            ForEach(recipeIngredients, id: \.self) { ingr in
                if matchedItems[ingr]?.first != Global.NO_LOCAL_INGR_MATCH {
                    Text(ingr)
                }
            }
        }
    }
}

struct MatchedLocalIngredients: View {
    let parentVC : HomeViewController?
    let matchedItems : [String : [String]]
    let matchedLocalIngredients : [String]
    
    var body: some View {
        
        // Checks all the local ingredients currently generating the recipe and checks if they are in the current recipe
        ForEach(parentVC?.foodsToDisplay ?? [], id: \.self) { ingr in
            VStack {
                HStack {
                    Text(ingr)
                    Spacer()
                    Image(systemName: matchedLocalIngredients.contains(ingr) ? "checkmark" : "xmark")
                }
                .padding([.leading, .trailing], 30)
                
                Divider()
            }
        }
    }
}

struct SeeRecipeButton: View {
    
    let segueToRecipe : (() -> Void)
    
    // Transistions to RecipeViewController
    var body: some View {
        Button {
            segueToRecipe()
        } label: {
            Text("See Recipe")
                .font(.headline)
                .frame(width: 298, height: 53)
                .foregroundColor(.white)
                .background(Color(red: 0, green: 0, blue: 1))
                .cornerRadius(5)
                .padding(.bottom, 20)
        }
    }
}

struct ExDivider: View {
    let color: Color = .black
    let width: CGFloat = 3
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
