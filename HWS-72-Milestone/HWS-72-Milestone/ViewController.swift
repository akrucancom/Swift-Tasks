//
//  ViewController.swift
//  HWS-72-Milestone
//
//  Created by Comarch-Andrzej on 25/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	var notes = [Note]()
	var notesKey = "notesKey"
	var defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadNotes()
		uiSetup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	func loadNotes() {
		if let savedNotes = defaults.object(forKey: notesKey) as? Data {
			let jsonDecoder = JSONDecoder()
			do {
				notes = try jsonDecoder.decode([Note].self, from: savedNotes)
				print(notes)
			} catch {
				print("Failed to load photos")
			}
		}
	}
	
	func saveNotes() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(notes) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: notesKey)
			print("Saved")
		} else {
			print("Failed to save scripts.")
		}
	}
	
	func uiSetup() {
		navigationController?.isToolbarHidden = false
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
		toolbarItems = [addButton]
		title = "Notes"
	}
	
	@objc func addNote() {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let editNoteVC = storyBoard.instantiateViewController(withIdentifier: "NoteEditor") as! NoteViewController
		editNoteVC.notes = notes
		editNoteVC.isBeingCreated = true
		editNoteVC.notesKey = notesKey
		navigationController?.pushViewController(editNoteVC, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
		cell.textLabel?.text = notes[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let editNoteVC = storyBoard.instantiateViewController(withIdentifier: "NoteEditor") as! NoteViewController
		editNoteVC.index = indexPath.row
		editNoteVC.notes = notes
		editNoteVC.isBeingCreated = false
		editNoteVC.textView.text = notes[indexPath.row].content
		editNoteVC.notesKey = notesKey
		navigationController?.pushViewController(editNoteVC, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}
}
