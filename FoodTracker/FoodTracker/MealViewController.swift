//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Gang Wu on 10/28/15.
//  Copyright © 2015 Gang Wu. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  /*
  This Value is either passed by `MealTableViewController` in 
  `prepareForSegue(_:sender:)` or constructed as part of adding a new meal.
  */
  var meal: Meal?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Handle the text field's user input through delegate callbacks
    nameTextField.delegate = self
    
    // Set up views if editing an existing Meal.
    if let meal = meal {
      navigationItem.title = meal.name
      nameTextField.text = meal.name
      photoImageView.image = meal.photo
      ratingControl.rating = meal.rating
    }
    
    // Enable the Save button only if the text field has a valid Meal name
    checkValidMealName()
  }
  
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    // Hide the keyboard
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    // Disable the Save button while editing
    saveButton.enabled = false
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    checkValidMealName()
    navigationItem.title = textField.text
  }
  
  func checkValidMealName() {
    // Disable the Save button if the text field is empty
    let text = nameTextField.text ?? ""
    nameTextField.text?.isEmpty
    saveButton.enabled = !text.isEmpty
  }
  
  // MARK: UIImagePickerControllerDelegate
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    // The info dictionary contains multiple representations of the image, and this uses the original.
    let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    
    // Set photoImageView to display the selected image.
    photoImageView.image = selectedImage
    
    // Dismiss the picker
    dismissViewControllerAnimated(true, completion: nil)
  }

  // MARK: Navigation

  @IBAction func cancel(sender: UIBarButtonItem) {
    // Depending on style of presentation (modal or push), this view controller
    // needs to be dimissed in two different ways
    let isPresentingInAddMealMode = presentingViewController is UINavigationController
    if isPresentingInAddMealMode {
      dismissViewControllerAnimated(true, completion: nil)
    } else {
      navigationController!.popViewControllerAnimated(true)
    }
  }
  
  // This method lets you configure a view controller before it's presented
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if saveButton === sender {
      let name = nameTextField.text ?? ""
      let photo = photoImageView.image
      let rating = ratingControl.rating
      
      // Set the temal to be passed to MealTableViewController after the unwind segue
      meal = Meal(name: name, photo: photo, rating: rating)
    }
    
  }
  // MARK: Actions  
  @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
    // Hide the keyboard
    nameTextField.resignFirstResponder()
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .PhotoLibrary
    imagePickerController.delegate = self
    presentViewController(imagePickerController, animated: true, completion: nil)
  }
}

