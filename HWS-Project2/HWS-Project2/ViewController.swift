//
//  ViewController.swift
//  HWS-Project2
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!
	var buttons = [UIButton]()
	var scoreLabel = UILabel()
	var counterLabel = UILabel()
	var countries = [String]()
	
	var score = 0
	var correctAnswer = 0
	var questionCounter = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		weeklyReminder()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		buttons = [button1, button2, button3]
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		for button in buttons {
			button.layer.borderWidth = 1
			button.layer.borderColor = UIColor.lightGray.cgColor
		}
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
		var buttonTitle = "Continue"
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
		let closeAlert = UIAlertAction(title: "Return", style: .default)
		
		actionSheetController.addAction(closeAlert)
		present(actionSheetController, animated: true, completion: nil)
	}
	
	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
	}
	
	func weeklyReminder() {
		registerCategories()
		
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "It's time to play some flags!"
		content.body = "Wanna go for a Spain whitout the \"a\"?"
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = .default
		
		var dateComponents = DateComponents()
		dateComponents.calendar = Calendar.current
		dateComponents.hour = 13
		dateComponents.minute = 43
		
		for weekday in 1 ... 7 {
			dateComponents.weekday = weekday
			let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
			let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
			center.add(request)
			print(request)
		}
	}
	
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
		let remindMeLater = UNNotificationAction(identifier: "remindMeLater", title: "Remind me later")
		let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [], options: [])
		
		center.setNotificationCategories([category])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom data received: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				showInfoAlert(title: "Let's Go!", message: "Go get'em flags!")
				
			case "show":
				showInfoAlert(title: "You have clicked View", message: "Crazy, right?")
				
			default:
				break
			}
		}
		completionHandler()
	}
	
	func showInfoAlert(title: String, message: String) {
		let showAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let closeAction = UIAlertAction(title: "Close", style: .default)
		showAlertController.addAction(closeAction)
		present(showAlertController, animated: true)
	}
}
