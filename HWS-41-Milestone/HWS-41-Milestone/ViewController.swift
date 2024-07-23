//
//  ViewController.swift
//  HWS-41-Milestone
//
//  Created by Comarch-Andrzej on 22/07/2024.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	var scoreLabel: UILabel!
	var attemptLabel: UILabel!
	var currentAnswer: UILabel!
	var attemptTextField: UITextField!
	var livesLabel: UILabel!
	var invalidGuessesLabel: UILabel!
	var allWords = [String]()
	var validGuesses: String = ""
	var invalidGuesses: String = "" {
		didSet {
			invalidGuessesLabel.text = "Used letters: \(invalidGuesses)"
		}
	}

	var seekedWord = ""
	let separator = "-"
	var lives: Int = 7 {
		didSet {
			livesLabel.text = "Lives: \(String(lives))"
		}
	}
	
	var attemptedWord: String = "" {
		didSet {
			attemptLabel.text = "\(attemptedWord)"
		}
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		livesLabel = UILabel()
		livesLabel.translatesAutoresizingMaskIntoConstraints = false
		livesLabel.font = UIFont.systemFont(ofSize: 24)
		livesLabel.text = "Lives: \(String(lives))"
		view.addSubview(livesLabel)
		
		invalidGuessesLabel = UILabel()
		invalidGuessesLabel.translatesAutoresizingMaskIntoConstraints = false
		invalidGuessesLabel.font = UIFont.systemFont(ofSize: 24)
		invalidGuessesLabel.text = "Used letters: \(invalidGuesses)"
		view.addSubview(invalidGuessesLabel)
		
		attemptLabel = UILabel()
		attemptLabel.translatesAutoresizingMaskIntoConstraints = false
		attemptLabel.font = UIFont.systemFont(ofSize: 40)
		attemptLabel.text = attemptedWord
		view.addSubview(attemptLabel)
		
		attemptTextField = UITextField()
		attemptTextField.translatesAutoresizingMaskIntoConstraints = false
		attemptTextField.font = UIFont.systemFont(ofSize: 24)
		attemptTextField.layer.borderWidth = 1
		attemptTextField.borderStyle = .roundedRect
		attemptTextField.placeholder = "Input your guess here"
		view.addSubview(attemptTextField)
		
		NSLayoutConstraint.activate([
			attemptLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			attemptLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
			invalidGuessesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
			invalidGuessesLabel.topAnchor.constraint(equalTo: attemptLabel.bottomAnchor, constant: 20),
			attemptTextField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
			attemptTextField.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
			livesLabel.topAnchor.constraint(equalTo: invalidGuessesLabel.bottomAnchor, constant: 20),
			livesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
		])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadWords()
		startGame()
		attemptTextField.delegate = self
	}
	
	func loadWords() {
		guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"), let startWords = try? String(contentsOf: startWordsURL) else {
			showAlert(title: "File not found", message: "Loading backup option...")
			allWords = ["METAMORPH", "ULTIMATUM", "MIRROR", "ASCENDENCY", "BLIGHT"]
			print(allWords)
			return
		}
		allWords = startWords.components(separatedBy: "\n")
		print(allWords)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let answer = textField.text
		if answer!.isEmpty {
			return true
		}
		checkLetter(letter: answer)
		textField.text = ""
		return true
	}

	func checkLetter(letter: String?) {
		if validGuesses.contains(letter ?? "?") || invalidGuesses.contains(letter ?? "?") {
			showAlert(title: "Letter \"\(String(describing: letter ?? ""))\" has been guessed already", message: "Try again!")
			return
		}
		if seekedWord.contains(letter!) {
			validGuesses += letter ?? ""
			attemptedWord = ""
			var addedLetter = false
			for character in seekedWord {
				for validCharacter in validGuesses {
					if character == validCharacter {
						attemptedWord += String(validCharacter)
						addedLetter = true
					}
				}
				if !addedLetter {
					attemptedWord += separator
				}
				addedLetter = false
			}
			print(attemptedWord)
			if !(attemptedWord.contains(separator)) {
				showAlert(title: "You won!", message: "\"\(seekedWord)\" was the seeked word!")
				startGame()
			}
			return
		}
		invalidGuesses += " \(letter ?? "?")"
		lives -= 1
		if lives == 0 {
			showAlert(title: "Game over!", message: "You have run out of lives! \"\(seekedWord)\" was the seeked word")
			startGame()
		}
		showAlert(title: "Wrong!", message: "\"\(String(describing: letter ?? "?"))\" is not found in seeked word!\nLives left: \(lives)")
		print(attemptedWord.contains(separator))
	}
	
	func startGame() {
		seekedWord = allWords.randomElement()?.uppercased() ?? "METAMORPH"
		attemptedWord = ""
		for _ in seekedWord {
			attemptedWord += separator
		}
		invalidGuesses = ""
		validGuesses = ""
		lives = 7
	}
	
	func showAlert(title: String, message: String) {
		let showErrorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let returnAction = UIAlertAction(title: "Return", style: .default) { _ in }
		showErrorAlertController.addAction(returnAction)
		present(showErrorAlertController, animated: true)
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return false }
		let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
		return updatedText.count <= 1
	}
}
