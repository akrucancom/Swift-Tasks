//
//  PictureViewController.swift
//  HWS-50-Milestone
//
//  Created by Comarch-Andrzej on 23/07/2024.
//

import UIKit

class PictureViewController: UIViewController {
	var picture: Picture?
	@IBOutlet var photoImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = picture?.caption
		getPicture()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
	func getPicture() {
		guard let picture else { return }
		let picturePath = getDocumentsDirectory().appendingPathComponent(picture.name)
		photoImageView.image = UIImage(contentsOfFile: picturePath.path)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

}
