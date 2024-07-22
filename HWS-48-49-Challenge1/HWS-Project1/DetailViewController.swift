//
//  DetailViewController.swift
//  HWS-Project1
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var selectedImage: String?
	var imageIndex: Int?
	var imageViews: Int?
	

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Views: \(String(imageViews ?? 0))"
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

		if let imageToLoad = selectedImage {
			imageView.image = UIImage(named: imageToLoad)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.9) else {
			print("No image found")
			return
		}
		
		let vcShareTapped = UIActivityViewController(activityItems: [image, selectedImage ?? "stormViewImage.jpg"], applicationActivities: [])
		vcShareTapped.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vcShareTapped, animated: true)
	}
}
