//
//  DetailViewController.swift
//  HWS-23-Challenge-4
//
//  Created by Comarch-Andrzej on 15/07/2024.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var selectedImage: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let imageToLoad = selectedImage {
			imageView.image = UIImage(named: imageToLoad.lowercased() + "@3x.png")
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(shareTapped))
	}
	
	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.9) else {
			print("No image found")
			return
		}
		
		let vcShareTapped = UIActivityViewController(activityItems: [image, selectedImage ?? "flag.jpg"], applicationActivities: [])
		vcShareTapped.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vcShareTapped, animated: true)
	}
}
