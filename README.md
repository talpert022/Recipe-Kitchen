# CookForOne

Cook For One is an iOS app, written in Swift, that allows you to add ingredients, check expiration dates, and get recipes for the food in your kitchen. 

- [Screenshots](#Screenshots)
- [Description](#Description)
- [What I learned](#What-I-learned)

Screenshots
------------

<p float="left">
  <img src="https://github.com/talpert022/CookForOne/blob/master/Screenshots/screenshot1.png" width="500" height = "500" />
  <img src="https://github.com/talpert022/CookForOne/blob/master/Screenshots/screenshot2.png" width="500" height = "500" />
  <img src="https://github.com/talpert022/CookForOne/blob/master/Screenshots/screenshot3.png" width="500" height = "500" />
</p>


Description 
------------

Cook For One keeps track of a user's ingredients entered into their pantry, along with information about the ingredients such as its title, quantity, location (fridge, freezer, dry pantry, etc..) and expiration date. The app recomends recipes based on the expiration dates of different foods, and sends notifications when an ingredient is about to expire so nothing goes unused. Cook For One uses the Edamam recipe search API (https://developer.edamam.com/edamam-docs-recipe-api) to find recipes. Recipes can be sorted by calories, time to cook, number of ingredient, and health labels like vegan, vegitarian, sugar-free, high-protien and more! Users can also save their favorite recipes.

What I learned
--------------

* Saving persistent information with the Core Data framework and retrieving information with a NSFetchedResultsController
* Using CocoaPods to integrate certain features 
* API Networking with Alamofire using RESTful web services, HTTP methods (GET), Authentication tokens, and JSON-encoded data strings
* Setting up constraints with AutoLayout and using UIKit and Foundation frameworks
* Creating an MVC architecture for efficient file management 
