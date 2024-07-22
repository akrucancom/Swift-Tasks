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
	let defaults = UserDefaults.standard
	var challengeWord: String = ""

	override func viewDidLoad() {
		allWords = defaults.object(forKey: "allWords") as? [String] ?? []
		usedWords = defaults.object(forKey: "usedWords") as? [String] ?? []
		challengeWord = defaults.object(forKey: "challengeWord") as? String ?? "silkworm"
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
		loadWords()
		startGame()
	}
	
	func loadWords() {
		if allWords.isEmpty {
			if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
				if let startWords = try? String(contentsOf: startWordsURL) {
					allWords = startWords.components(separatedBy: "\n")
				}
			}
			defaults.setValue(allWords, forKey: "allWords")
		}
	}
	
	func startGame() {
		title = challengeWord
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
		let answerPromptAlertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		answerPromptAlertController.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) {
			[weak self, weak answerPromptAlertController] _ in
			guard let answer = answerPromptAlertController?.textFields?[0].text?.lowercased() else { return }
			self?.submit(answer)
		}
		
		answerPromptAlertController.addAction(submitAction)
		present(answerPromptAlertController, animated: true)
	}
	
	@objc func restartGame() {
		let restartGameAlertController = UIAlertController(title: "Restart game?", message: "New title word will be generated and answers will be wiped", preferredStyle: .alert)
		let restartAlertAction = UIAlertAction(title: "Proceed", style: .destructive) { [weak self] _ in
			self?.challengeWord = self?.allWords.randomElement() ?? "silkworm"
			self?.usedWords = []
			self?.defaults.set(self?.challengeWord, forKey: "challengeWord")
			self?.defaults.set(self?.usedWords, forKey: "usedWords")
			self?.startGame()
		}
		let closeAction = UIAlertAction(title: "Close", style: .default) { _ in
		}
		
		restartGameAlertController.addAction(restartAlertAction)
		restartGameAlertController.addAction(closeAction)
		present(restartGameAlertController, animated: true)
	}
	
	func submit(_ answer: String) {
		let lowerAnswer = answer.lowercased()
		
		let errorTitle: String
		let errorMessage: String
		
		if isPossible(word: lowerAnswer) {
			if isOriginal(word: lowerAnswer) {
				if isReal(word: lowerAnswer) {
					usedWords.insert(answer, at: 0)
					defaults.setValue(usedWords, forKey: "usedWords")
					
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
			errorMessage = "At least 3 characters that are contained in provided word, ok?"
			showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
		}
	}
	
	func isPossible(word: String) -> Bool {
		guard var tempWord = title?.lowercased() else { return false }
		
		if word.count < 3 || word == tempWord {
			return false
		} else {
			for letter in word {
				if let position = tempWord.firstIndex(of: letter) {
					tempWord.remove(at: position)
				} else {
					return false
				}
			}
			return true
		}
	}
	
	func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	
	func showErrorMessage(errorTitle: String, errorMessage: String) {
		let errorAlertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
		let errorAction = UIAlertAction(title: "OK", style: .default)
		errorAlertController.addAction(errorAction)
		present(errorAlertController, animated: true)
	}
}
