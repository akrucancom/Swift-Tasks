//
//  ViewController.swift
//  HWS-42
//
//  Created by Comarch-Andrzej on 19/07/2024.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
			fatalError("PersonCell not found.")
		}
		
		let person = people[indexPath.item]
		
		cell.name.text = person.name
		
		let path = getDocumentsDirectory().appending(path: person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		
		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		return cell
	}
	
	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appending(path: imageName)
		
		if let jpegData = image.jpegData(compressionQuality: 0.9) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView.reloadData()
		
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]
		
		let addNameAlertController = UIAlertController(title: "Rename person:", message: nil, preferredStyle: .alert)
		
		addNameAlertController.addTextField()
		
		addNameAlertController.addAction(UIAlertAction(title: "OK", style: .default) {
			[weak self, weak addNameAlertController] _ in
			guard let newName = addNameAlertController?.textFields?[0].text else { return }
			person.name = newName
			self?.collectionView.reloadData()
		})
	}
}
