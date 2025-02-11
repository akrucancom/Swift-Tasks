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

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	     // Get the new view controller using segue.destination.
	     // Pass the selected object to the new view controller.
	 }
	 */
}
