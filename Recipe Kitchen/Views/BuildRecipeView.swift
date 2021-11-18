//
//  BuildRecipeView.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/11/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import SwiftUI

protocol AddMultipleIngredientsProtocol {
    func addMultipleIngredients(ingredients : [String])
}

struct BuildRecipeView: View {
    
    var delegate : AddMultipleIngredientsProtocol?
    let dismissView : () -> Void
    
    @State private var isShowingWarning : Bool = false
    @State private var shouldDismissView : Bool = false
    @State private var numIngredients : Int = 1
    @State private var ingredients : [Ingredients] = {
        var ingredientArr : [Ingredients] = []
        ingredientArr.append(Ingredients(ingrNum: 1))
        return ingredientArr
    }()
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Build Recipe")
                .font(.custom("Avenir-Black", size: 25.0))
                .foregroundColor(Color(red: 164/255, green: 0, blue: 0))
            
            ScrollView {
                VStack {
                    ForEach(ingredients) { ingredient in
                        AddIngredientView(ingredient: ingredient)
                    }
                }
            }
            
            WarningLabel(isShowing: $isShowingWarning)
                        
            HStack(spacing: 50) {
                EditButton(isAdd: .constant(true), ingredients: $ingredients)
                EditButton(isAdd: .constant(false), ingredients: $ingredients)
            }
            
            Button{
                buildRecipe()
                if shouldDismissView {
                    dismissView()
                }
            } label: {
                Text("Create Recipe")
                    .font(.custom("Avenir-Black", size: 25.0))
                    .foregroundColor(Color(red: 164/255, green: 0, blue: 0))
            }
            
        }
        .padding()
    }
    
    func buildRecipe() {
        
        guard let delegate = delegate else {
            return
        }
        
        let ingredientStrs = getIngredientStrs(ingredients: ingredients)
        if let ingrStrs = ingredientStrs {
            shouldDismissView = true
            delegate.addMultipleIngredients(ingredients: ingrStrs)
            return
        }
        
        // Delays the warning so that it brings extra attention to the user
        isShowingWarning = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            isShowingWarning = true
        }
    }
    
    /// Returns the list of strings of entered ingredients, or nil indicating that a name has to be given for each ingredient
    func getIngredientStrs(ingredients : [Ingredients]) -> [String]? {
        
        var ingrStrs = [String]()
        for ingr in ingredients {
            if ingr.ingrString.isEmpty {
                return nil
            }
            ingrStrs.append(ingr.ingrString)
        }
        return ingrStrs
    }
}

struct AddIngredientView : View {
    
    @ObservedObject var ingredient : Ingredients
    
    var body : some View {
        let num = ingredient.ingrNum
        
        Text("Ingredient \(ingredient.ingrNum)")
            .font(.custom("Avenir-Heavy", size: 18.0))
        
        TextField("Add Ingredient \(num)...", text: $ingredient.ingrString)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

class Ingredients: ObservableObject, Identifiable {
    
    @Published var ingrNum : Int
    @Published var ingrString : String = ""
    let id: String = UUID().uuidString
    
    init(ingrNum: Int) {
        self.ingrNum = ingrNum
    }
}

struct EditButton: View {
    
    @Binding var isAdd: Bool
    @Binding var ingredients : [Ingredients]
    
    var body: some View {
        Button {
            editNumIngredients(isAdd: isAdd)
            // TODO: Always scroll to bottom when new ingredient is added
            // TODO: Immediately start editing new ingredient
        } label: {
            HStack {
                Image(systemName: isAdd ? "plus.circle" : "minus.circle")
                Text(isAdd ? "Add" : "Remove")
            }
            .font(.custom("Avenir-Medium", size: 19.0))
        }
    }
    
    func editNumIngredients(isAdd : Bool) {
        
        if !isAdd && ingredients.count > 1 {
            ingredients.removeLast()
        } else if isAdd {
            let newIngredient = Ingredients(ingrNum: ingredients.count + 1)
            ingredients.append(newIngredient)
        }
    }
}

struct WarningLabel: View {
    
    @Binding var isShowing : Bool
    
    var body: some View {
        if isShowing {
            Text("Each ingredient must have a title ⚠️")
                .font(.system(size: 13.0))
                .foregroundColor(.red)
        }
    }
}

struct BuildRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRecipeView(dismissView: {})
    }
}

