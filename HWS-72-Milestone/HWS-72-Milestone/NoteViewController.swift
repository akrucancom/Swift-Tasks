//
//  NoteViewController.swift
//  HWS-72-Milestone
//
//  Created by Comarch-Andrzej on 25/07/2024.
//

import UIKit

class NoteViewController: UIViewController {
	var notes = [Note]()
	var index: Int = 0
	let textView = UITextView()
	var isBeingCreated: Bool = false
	var notesKey = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTextField()
		configureTopBar()
	}
	
	func configureTopBar() {
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
		let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
		let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
		if !isBeingCreated {
			title = notes[index].name
			navigationItem.rightBarButtonItems = [saveButton, deleteButton, shareButton]
		} else {
			title = ""
			navigationItem.rightBarButtonItem = saveButton
		}
	}
	
	@objc func saveNote() {
		let saveNoteAlertController = UIAlertController(title: "Save note?", message: "Input name", preferredStyle: .alert)
		saveNoteAlertController.addTextField()
		if !isBeingCreated {
			saveNoteAlertController.textFields?[0].text = notes[index].name
		}
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, unowned saveNoteAlertController] _ in
			guard let name = saveNoteAlertController.textFields?[0].text else { return }
			guard let content = self?.textView.text else { return }
			let note = Note(name: name, content: content)
			if name.isEmpty {
				self?.showAlert(title: "Name is empty!", message: "Input name")
				return
			} else {
				let notesFiltered = self?.notes.filter { $0.name == name }
				if notesFiltered?.isEmpty ?? false {
					self?.notes.append(note)
					if let rootVC = self?.navigationController?.viewControllers.first as? ViewController {
						rootVC.notes = self!.notes
						rootVC.saveNotes()
					}
					self?.navigationController?.popToRootViewController(animated: true)
				} else {
					let overwriteAlertController = UIAlertController(title: "Name \(name) already exists", message: "Do you want to overwrite the existing note?", preferredStyle: .alert)
					let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
						guard let index = self?.index else { return }
						self?.notes[index].content = content
						if let rootVC = self?.navigationController?.viewControllers.first as? ViewController {
							guard let notes = self?.notes else { return }
							rootVC.notes = notes
							rootVC.saveNotes()
						}
						self?.navigationController?.popToRootViewController(animated: true)
					}
					let declineAction = UIAlertAction(title: "No", style: .destructive) { [weak self] _ in
						self?.saveNote()
					}
					overwriteAlertController.addAction(confirmAction)
					overwriteAlertController.addAction(declineAction)
					self?.present(overwriteAlertController, animated: true)
				}
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		saveNoteAlertController.addAction(submitAction)
		saveNoteAlertController.addAction(cancelAction)
		present(saveNoteAlertController, animated: true)
	}
	
	@objc func deleteNote() {
		let deleteAlertController = UIAlertController(title: "Do you want to remove \(notes[index].name)?", message: "This action can't be undone", preferredStyle: .alert)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
			guard let index = self?.index else { return }
			self?.notes.remove(at: index)
			if let rootVC = self?.navigationController?.viewControllers.first as? ViewController {
				guard let notes = self?.notes else { return }
				rootVC.notes = notes
				rootVC.saveNotes()
			}
			self?.navigationController?.popToRootViewController(animated: true)
		}
		let returnAction = UIAlertAction(title: "Return", style: .default)
		deleteAlertController.addAction(deleteAction)
		deleteAlertController.addAction(returnAction)
		present(deleteAlertController, animated: true)
	}
	
	@objc func shareNote() {
		let shareNoteTapped = UIActivityViewController(activityItems: ["\(notes[index].name)\n\(textView.text ?? "")"], applicationActivities: [])
		shareNoteTapped.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(shareNoteTapped, animated: true)
	}
	
	func configureTextField() {
		view.addSubview(textView)
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.text = "Note:"
		textView.font = .systemFont(ofSize: 24)
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
			textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
			textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
		])
		if !isBeingCreated {
			textView.text = notes[index].content
		}
	}
	
	func showAlert(title: String, message: String) {
		let showErrorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let returnAction = UIAlertAction(title: "Return", style: .default) { _ in }
		showErrorAlertController.addAction(returnAction)
		present(showErrorAlertController, animated: true)
	}
}
