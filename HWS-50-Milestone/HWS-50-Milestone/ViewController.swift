//
//  ViewController.swift
//  HWS-50-Milestone
//
//  Created by Comarch-Andrzej on 23/07/2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var pictures = [Picture]()
	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Photo gallery"
		load()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
	}
	
	@objc func addPhoto() {
		let chooseSourceAlertController = UIAlertController(title: "Choose source to add picture from:", message: nil, preferredStyle: .actionSheet)
		let galleryAlertAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
			self?.addNewPersonWithGallery()
		}
		let cameraAlertAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
			self?.addNewPersonWithCamera()
		}
		let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		chooseSourceAlertController.addAction(galleryAlertAction)
		chooseSourceAlertController.addAction(cameraAlertAction)
		chooseSourceAlertController.addAction(cancelAlertAction)
		present(chooseSourceAlertController, animated: true)
	}
	
	func addNewPersonWithGallery() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func addNewPersonWithCamera() {
		let picker = UIImagePickerController()
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
			present(picker, animated: true)
		} else {
			let cameraMissingAlertController = UIAlertController(title: "Camera not found", message: nil, preferredStyle: .alert)
			let confirmAlertAction = UIAlertAction(title: "Return", style: .default)
			cameraMissingAlertController.addAction(confirmAlertAction)
			present(cameraMissingAlertController, animated: true)
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
			
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appending(path: imageName)
			
		if let jpegData = image.jpegData(compressionQuality: 0.9) {
			try? jpegData.write(to: imagePath)
		}
		dismiss(animated: true)
		let nameAlertController = UIAlertController(title: "Add caption to photo", message: nil, preferredStyle: .alert)
		nameAlertController.addTextField()
		
		let submitAlertAction = UIAlertAction(title: "Submit", style: .default) { [weak self, unowned nameAlertController] _ in
			let answer = nameAlertController.textFields![0].text
			let Picture = Picture(name: imageName, caption: answer ?? "Unknown")
			self?.pictures.append(Picture)
			self?.tableView.reloadData()
			self?.save()
		}
		nameAlertController.addAction(submitAlertAction)
		present(nameAlertController, animated: true)
	}
	
	func load() {
		if let savedPhotos = defaults.object(forKey: "pictures") as? Data {
			let jsonDecoder = JSONDecoder()
			do {
				pictures = try jsonDecoder.decode([Picture].self, from: savedPhotos)
			} catch {
				print("Error while loading pictures")
			}
		}
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(pictures) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "pictures")
		}
		else {
			print("Error while saving pictures")
		}
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row].caption
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let pictureViewController = storyboard?.instantiateViewController(withIdentifier: "PictureView") as? PictureViewController {
			pictureViewController.picture = pictures[indexPath.row]
			navigationController?.pushViewController(pictureViewController, animated: true)
		}
	}
}
