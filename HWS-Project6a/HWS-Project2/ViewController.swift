//
//  ViewController.swift
//  HWS-Project2
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!
	
	var scoreLabel = UILabel()
	var counterLabel = UILabel()
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var questionCounter = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1
		
		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor
		
		askQuestion(action: nil)
	}
	
	func askQuestion(action: UIAlertAction!) {
		countries.shuffle()
		correctAnswer = Int.random(in: 0 ... 2)
		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
		
		title = "\(countries[correctAnswer].uppercased())"
		scoreLabel.text = "S: \(score)"
		counterLabel.text = "Q: \(questionCounter)"
	}
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var message: String
		var buttonTitle: String = "Continue"
		questionCounter += 1
		
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
			message = "Your score is \(score)"
		} else {
			title = "Wrong, you have chosen \(countries[sender.tag])"
			score -= 1
			message = "Your score is \(score)"
		}
		if questionCounter == 10 {
			title = "You have answered all questions"
			message = "Your final score is \(score)"
			buttonTitle = "Restart"
			questionCounter = 0
			score = 0
		}
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: askQuestion))
		
		present(ac, animated: true)
		print(questionCounter)
	}

	@IBAction func scoreButtonTapped(_ sender: UIBarButtonItem) {
		let actionSheetController = UIAlertController(title: "Score", message: "Your score is \(String(score))", preferredStyle: .alert)
		let closeAlert = UIAlertAction(title: "Return", style: .default) {
			_ in
		}
		
		actionSheetController.addAction(closeAlert)
		present(actionSheetController, animated: true, completion: nil)
	}
}
