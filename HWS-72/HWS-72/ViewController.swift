//
//  ViewController.swift
//  HWS-72
//
//  Created by Comarch-Andrzej on 25/07/2024.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
		// Do any additional setup after loading the view.
	}
	
	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
			if granted {
				print("Yay!")
			} else {
				print("D'oh!")
			}
		}
	}
	
	@objc func scheduleLocal() {
		registerCategories()
		
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird catches the wor, but the second mouse gets the cheese."
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = .default
		
		var dateComponents = DateComponents()
		dateComponents.hour = 10
		dateComponents.minute = 30
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
		
		center.setNotificationCategories([category])
	}

	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom data received: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				// the user swiped to unock
				print("Default identifier")
			
			case "show":
				print("Show more information...")
				
			default:
				break
			}
		}
		
		completionHandler()
	}

}

