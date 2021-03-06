//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Brendan Leder on 2016-11-05.
//  Copyright © 2016 Brendan Leder. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
	//MARK: Properties
	var meals = [Meal]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = editButtonItem
		if let savedMeals = loadMeals() {
			print("Loaded")
			meals += savedMeals
		} else {
			loadSampleMeals()
		}
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}
	
	func loadSampleMeals() {
		let photo1 = #imageLiteral(resourceName: "meal1")
		let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
		let photo2 = #imageLiteral(resourceName: "meal2")
		let meal2 = Meal(name: "Chicken n Taters", photo: photo2, rating: 5)!
		let photo3 = #imageLiteral(resourceName: "meal3")
		let meal3 = Meal(name: "Meatball Pasta", photo: photo3, rating: 3)!
		meals += [meal1, meal2, meal3]
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "MealTableViewCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
		let meal = meals[indexPath.row]
		cell.nameLabel.text = meal.name
		cell.photoImageView.image = meal.photo
		cell.ratingControl.rating = meal.rating
		return cell
	}
	
	
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			meals.remove(at: indexPath.row)
			saveMeals()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	
	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
	
	}
	*/
	
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the item to be re-orderable.
	return true
	}
	*/
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail" {
			let mealDetailViewController = segue.destination as! MealViewController
			if let selectedMealCell = sender as? MealTableViewCell {
				let indexPath = tableView.indexPath(for: selectedMealCell)!
				let selectedMeal = meals[indexPath.row]
				mealDetailViewController.meal = selectedMeal
			}
		} else if segue.identifier == "AddItem" {
			print("Adding New Meal")
		}
	}
	
	@IBAction func unWindToMealList(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				meals[selectedIndexPath.row] = meal
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
				let newIndexPath = IndexPath(row: meals.count, section: 0)
				meals.append(meal)
				tableView.insertRows(at: [newIndexPath], with: .bottom)
			}
			saveMeals()
		}
	}
	//MARK: NSCoding
	func saveMeals() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
		if isSuccessfulSave {
			print("Saved")
		} else {
			print("Failed to save")
		}
	}
	func loadMeals() -> [Meal]? {
		print("Loading")
		return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
	}
}
