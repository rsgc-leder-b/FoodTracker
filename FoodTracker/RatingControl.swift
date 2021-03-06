//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Brendan Leder on 2016-11-02.
//  Copyright © 2016 Brendan Leder. All rights reserved.
//

import UIKit

class RatingControl: UIView {
	// MARK: Properties
	
	var rating = 0 {
		didSet {
			setNeedsLayout() //New stuff alert: didSet-if rating changes, setNeedsLayout-update GUI
		}
	}
	var ratingButtons = [UIButton]()
	let spacing = 3
	let starCount = 5
	// MARK: Initialization
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		let filledStarImage = #imageLiteral(resourceName: "filledStar")
		let emptyStarImage = #imageLiteral(resourceName: "emptyStar")
		for _ in 0..<starCount {
			let button = UIButton()
			button.setImage(emptyStarImage, for: .normal)
			button.setImage(filledStarImage, for: .selected)
			button.setImage(filledStarImage, for: [.highlighted, .selected])
			//button.backgroundColor = UIColor.red
			button.adjustsImageWhenHighlighted = false
			button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchDown)
			ratingButtons += [button]
			addSubview(button)
		}
	}
	override func layoutSubviews() {
		self.layoutIfNeeded()
		let buttonSize = Int(frame.size.height)
		var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		for(index,button) in ratingButtons.enumerated() {
			buttonFrame.origin.x = CGFloat(index * (44 + spacing))
			button.frame = buttonFrame
		}
		updateButtonSelectionStates()
	}
	override public var intrinsicContentSize: CGSize {
		get {
			let buttonSize = Int(self.frame.size.height)
			let width = (buttonSize * starCount) + (spacing * (starCount-1))
			return CGSize(width: width, height: buttonSize) //ERROR: buttonSize is always 1000 despite being 44 in layoutSubviews, meaning this something is improperly linked
		}
	}

	// MARK: Button Action
	func ratingButtonTapped(button: UIButton) {
		rating = ratingButtons.index(of: button)!+1
		updateButtonSelectionStates()
	}
	func updateButtonSelectionStates() {
		for (index,button) in ratingButtons.enumerated() {
			button.isSelected = index < rating
		}
	}
}
