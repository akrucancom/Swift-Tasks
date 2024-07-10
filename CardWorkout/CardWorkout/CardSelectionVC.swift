//
//  CardSelectionVC.swift
//  CardWorkout
//
//  Created by Comarch-Andrzej on 05/07/2024.
//

import UIKit

class CardSelectionVC: UIViewController {

	var timer: Timer!
	
	@IBOutlet var cardImageView: UIImageView!
	
	var cards:  [UIImage] = Deck.allValues
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		timer.invalidate()
	}
	
	
	func startTimer() {
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(showRandomImage), userInfo: nil, repeats: true)
	}
	
	@objc func showRandomImage() {
		cardImageView.image = cards.randomElement() ?? UIImage(named: "AS")
	}

	@IBAction func stopButtonTapped(_ sender: Any) {
		timer.invalidate()
	}
	
	@IBAction func restartButtonTapped(_ sender:Any) {
		timer.invalidate()
		startTimer()
	}
	
}
