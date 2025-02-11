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
	var imageCount: Int?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "\(imageIndex ?? 1) of \(imageCount ?? 1)"
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

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	     // Get the new view controller using segue.destination.
	     // Pass the selected object to the new view controller.
	 }
	 */
}
