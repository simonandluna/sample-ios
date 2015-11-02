//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Gang Wu on 10/30/15.
//  Copyright © 2015 Gang Wu. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
  
  // MARK: Properties
  var meals = [Meal]()
  let imgNames = ["meal1", "meal2", "meal3", "meal4", "meal5", "meal6", "meal7", "meal8", "meal9"]
  let mealNames = ["Caprese Salad", "Chicken & Potatoes", "Pasta & Meatballs",
    "Samon Salad", "Japanese Breakfeast", "Food Sample", "One-Pot Meal", "8", "9"]
  let mealRatings = [3, 4, 1, 5, 2, 3, 5, 3, 3]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Use the edit button item provided by the table view controller
    navigationItem.leftBarButtonItem = editButtonItem()
    
    // Load any saved models, otherwise load sample data.
    if let savedMeals = loadMeals() {
      meals += savedMeals
    }
    else {
      // Load the sample data.
      loadSampleMeals()
    }
  }
  
  func loadSampleMeals() {
    for (index, name) in imgNames.enumerate() {
      let mealName = mealNames[index]
      let mealRating = mealRatings[index]
      let photo = UIImage(named: name)
      let meal = Meal(name: mealName, photo: photo, rating: mealRating)!
      meals.append(meal)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Table view cells are reused and should be dequeued using a cell id.
    let cellId = "MealTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! MealTableViewCell
    
    // Fetches the appropriate meal for the data source layout
    let meal = meals[indexPath.row]
    cell.mealName.text = meal.name
    cell.mealImageView.image = meal.photo
    cell.mealRatingControl.rating = meal.rating
    
    return cell
  }
  
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // Delete the row from the data source
      meals.removeAtIndex(indexPath.row)
      saveMeals()
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  // MARK: Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == "ShowDetail" {
      let mealDetailViewController = segue.destinationViewController as! MealViewController
      
      // Get the cell that generated this segue
      if let selectedMealCell = sender as? MealTableViewCell {
        let indexPath = tableView.indexPathForCell(selectedMealCell)!
        let selectedMeal = meals[indexPath.row]
        mealDetailViewController.meal = selectedMeal
      }
    }
    else if segue.identifier == "AddItem" {
      NSLog("Adding new meal.")
    }
  }
  
  // Exit segue to meal tableview by clicking saving button
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        // Update the existing meal
        meals[selectedIndexPath.row] = meal
        tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
      }
      else {
        // Add a new model
        let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
        meals.append(meal)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
      }
      
      // Save the meals
      saveMeals()
    }
  }
  
  // MARK: NSCoding
  
  func saveMeals() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
    if !isSuccessfulSave {
      print("Failed to save meals...")
    }
  }
  
  func loadMeals() -> [Meal]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
  }
}
