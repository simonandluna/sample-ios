//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Gang Wu on 10/30/15.
//  Copyright © 2015 Gang Wu. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell, UIScrollViewDelegate {
  
  // MARK: Properties
  
  @IBOutlet weak var mealName: UILabel!
  @IBOutlet weak var mealImageView: UIImageView!
  @IBOutlet weak var mealRatingControl: RatingControl!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
