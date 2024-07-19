//
//  ViewController.swift
//  HWS-Project1
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit

class ViewController: UICollectionViewController {
	var pictures = [String]()
	
	@IBOutlet var collectionImageView: UIImageView!
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let fileManager = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fileManager.contentsOfDirectory(atPath: path)
		
		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
		pictures.sort()
		print(pictures)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		pictures.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? ImageCell else {
			fatalError("ImageCell not found.")
		}
		
		cell.imageView?.image = UIImage(named: pictures[indexPath.item])
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			print("Photo index \(indexPath.item)")
			viewController.selectedImage = pictures[indexPath.item]
			viewController.imageIndex = indexPath.row + 1
			viewController.imageCount = pictures.count
			navigationController?.pushViewController(viewController, animated: true)
		}
	}
}
