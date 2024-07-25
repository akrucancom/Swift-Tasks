//
//  ActionViewController.swift
//  Extenstion
//
//  Created by Comarch-Andrzej on 23/07/2024.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
	@IBOutlet var script: UITextView!
	var scripts = [Script]()
	var barButtons = [UIBarButtonItem]()
	var defaults = UserDefaults.standard
	var scriptsKey = "scripts"
	var scriptName = ""
	var pageTitle = ""
	var pageURL = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadScripts()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))
		let runButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(done))
		let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeExtension))
		let scriptsButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPrewrittenScripts))
		navigationItem.rightBarButtonItems = [closeButton, runButton, scriptsButton]
		navigationItem.leftBarButtonItem = addButton
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, _ in
					guard let itemDictionary = dict as? NSDictionary else { return }
					guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
					self?.pageTitle = javaScriptValues["title"] as? String ?? ""
					self?.pageURL = javaScriptValues["URL"] as? String ?? ""
					print(self?.pageURL ?? "idk")
					
					DispatchQueue.main.async {
						self?.title = self?.pageTitle
					}
				}
			}
		}
	}

	@objc func done() {
		runJavaScript(script: script.text)
	}
	
	@objc func closeExtension() {
		extensionContext?.completeRequest(returningItems: [])
	}
	
	func loadScripts() {
		if let savedScripts = defaults.object(forKey: scriptsKey) as? Data {
			let jsonDecoder = JSONDecoder()
			do {
				scripts = try jsonDecoder.decode([Script].self, from: savedScripts)
				print(scripts)
			} catch {
				print("Failed to load photos")
			}
		}
	}
	
	@objc func addScript() {
		let addScriptController = UIAlertController(title: "Save script", message: "Input name:", preferredStyle: .alert)
		addScriptController.addTextField()
		addScriptController.textFields?[0].text = scriptName
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, unowned addScriptController] _ in
			guard let name = addScriptController.textFields?[0].text else { return }
			guard let content = self?.script.text else {
				self?.showAlert(title: "Script not found", message: "")
				return
			}
			guard let pageURL = self?.pageURL else {
				self?.showAlert(title: "Page URL not found", message: "")
				return
			}
			if name.isEmpty {
				self?.showAlert(title: "Name is empty!", message: "")
				return
			} else {
				let script = Script(name: name, content: content, site: pageURL)
				self?.scripts.append(script)
				self?.save()
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		addScriptController.addAction(submitAction)
		addScriptController.addAction(cancelAction)
		present(addScriptController, animated: true)
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(scripts) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: scriptsKey)
			print("Saved")
		} else {
			print("Failed to save scripts.")
		}
	}
	
	func runJavaScript(script: String) {
		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": script]
		let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier as String)
		item.attachments = [customJavaScript]
		extensionContext?.completeRequest(returningItems: [item])
	}
	
	@objc func showPrewrittenScripts() {
		let storyboard = UIStoryboard(name: "MainInterface", bundle: nil)
		let tableViewVC = storyboard.instantiateViewController(withIdentifier: "Scripts") as! ScriptsTableViewController
		tableViewVC.scripts = scripts.filter { $0.site == pageURL }
		tableViewVC.scriptsKey = scriptsKey
		navigationController?.pushViewController(tableViewVC, animated: true)
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			script.contentInset = .zero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		script.scrollIndicatorInsets = script.contentInset
		
		let selectedRange = script.selectedRange
		script.scrollRangeToVisible(selectedRange)
	}

	func showAlert(title: String, message: String) {
		let showErrorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let returnAction = UIAlertAction(title: "Return", style: .default) { _ in }
		showErrorAlertController.addAction(returnAction)
		present(showErrorAlertController, animated: true)
	}
}
