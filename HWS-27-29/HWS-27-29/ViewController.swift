//
//  ViewController.swift
//  HWS-27-29
//
//  Created by Comarch-Andrzej on 16/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	var allWords = [String]()
	var usedWords = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))

		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}

			if allWords.isEmpty {
				allWords = ["silkworm"]
			}
			
			startGame()
		}
	}
	
	func startGame() {
		title = allWords.randomElement()
		usedWords.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) {
			[weak self, weak ac] _ in
			guard let answer = ac?.textFields?[0].text?.lowercased() else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	@objc func restartGame() {
		let restartGameAC = UIAlertController(title: "Restart game?", message: "New title word will be generated and answers will be wiped", preferredStyle: .alert)
		let restartAA = UIAlertAction(title: "Proceed", style: .destructive) { _ in
			self.startGame()
		}
		let closeAA = UIAlertAction(title: "Close", style: .default) { _ in
		}
		
		restartGameAC.addAction(restartAA)
		restartGameAC.addAction(closeAA)
		present(restartGameAC, animated: true)
	}
	
	func submit(_ answer: String) {
		let lowerAnswer = answer.lowercased()
		
		let errorTitle: String
		let errorMessage: String
		
		if isPossible(word: lowerAnswer) {
			if isoriginal(word: lowerAnswer) {
				if isReal(word: lowerAnswer) {
					usedWords.insert(answer, at: 0)
					
					let indexPath = IndexPath(row: 0, section: 0)
					tableView.insertRows(at: [indexPath], with: .automatic)
					return
				} else {
					errorTitle = "Word not real"
					errorMessage = "Eloquent lika a 5 year old, are we?"
					showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
				}
			} else {
				errorTitle = "Word was used already"
				errorMessage = "Basic bozo"
				showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
			}
		} else {
			errorTitle = "Word not possible"
			errorMessage = "Where do you see letters you used in \(title!.lowercased())"
			showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
		}
	}
	
	func isPossible(word: String) -> Bool {
		guard var tempWord = title?.lowercased() else { return false }
		
		for letter in word {
			if let position = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: position)
			} else {
				return false
			}
		}
		if word.count < 4 || word == tempWord {
			return false
		} else {
			return true
		}
	}
	
	func isoriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	
	func showErrorMessage(errorTitle: String, errorMessage: String) {
		let errorAC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
		let errorAction = UIAlertAction(title: "OK", style: .default)
		errorAC.addAction(errorAction)
		present(errorAC, animated: true)
	}
}
