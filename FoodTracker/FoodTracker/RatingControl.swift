//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Gang Wu on 10/29/15.
//  Copyright © 2015 Gang Wu. All rights reserved.
//

import UIKit

class RatingControl: UIView {
  
  // MARK: Properties
  var rating = 0{
    didSet {
      setNeedsLayout()
    }
  }
  var stars = 5
  var spacing = 5
  var ratingButtons = [UIButton]()
  
  // MARK: Initialization
  override func layoutSubviews() {
    // Set the button's width and height to a square the size of the frame's height
    let buttonSize = Int(frame.size.height)
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    
    // Offset each button's origin by the length of the button plus spacing
    for (index, button) in ratingButtons.enumerate() {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
      button.frame = buttonFrame
    }
    
    updateButtonSelectionStates()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // Create #stars buttons
    let filledStarImage = UIImage(named: "filledStar")
    let emptyStarImage = UIImage(named: "emptyStar")
    for _ in 0..<stars {
      let button = UIButton()
      button.setImage(emptyStarImage, forState: .Normal)
      button.setImage(filledStarImage, forState: .Selected)
      button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
      button.adjustsImageWhenHighlighted = false
      button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
      ratingButtons.append(button)
      addSubview(button)
    }
  }

  override func intrinsicContentSize() -> CGSize {
    let buttonSize = Int(frame.size.height)
    let width = (buttonSize + spacing) * stars
    return CGSize(width: width, height: buttonSize)
  }

  // MARK: Button Action
  func ratingButtonTapped(button: UIButton) {
//    rating = ratingButtons.indexOf(button)! + 1
    if let index = ratingButtons.indexOf(button) {
      rating = index + 1
    }
    
    updateButtonSelectionStates()
  }
  
  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerate() {
      button.selected = index < rating
    }
  }
}
