//
//  ViewController.swift
//  HWS-72
//
//  Created by Comarch-Andrzej on 25/07/2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(buttonScheduleLocal))
	}
	
	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
			if granted {
				print("Yay!")
			} else {
				print("D'oh!")
			}
		}
	}
	
	@objc func buttonScheduleLocal() {
		scheduleLocal(5)
	}
	
	@objc func scheduleLocal(_ sender: TimeInterval) {
		registerCategories()
		
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird catches the wor, but the second mouse gets the cheese."
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = .default
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: sender, repeats: false)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
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
				showInfoAlert(title: "You swiped me!", message: "Not cool")
				
			case "show":
				showInfoAlert(title: "You have clicked show", message: "Crazy, right?")
				
			case "remindMeLater":
				scheduleLocal(15)
				
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
