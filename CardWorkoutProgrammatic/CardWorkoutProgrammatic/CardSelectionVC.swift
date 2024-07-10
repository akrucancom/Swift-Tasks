//
//  cardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Comarch-Andrzej on 08/07/2024.
//

import UIKit

class CardSelectionVC: UIViewController {

	
	var timer: Timer!
	
	var cards: [UIImage] = Deck.allValues
	
	let cardImageView = UIImageView()
	let stopButton = CWButton(backgroundColor: .systemRed, title: "Stop!")
	let resetButton = CWButton(backgroundColor: .systemGreen, title: "Reset")
	let rulesButton = CWButton(backgroundColor: .systemBlue, title: "Rules")
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		self.navigationItem.title = "Title"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Color", style: .plain, target: self, action: #selector(didTapButton))
		configureUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		startTimer()
	}
	
	@objc func didTapButton() {
		let vc = ColorPickerVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func startTimer() {
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(showRandomImage), userInfo: nil, repeats: true)
	}
	
	@objc func stopTimer(){
		timer.invalidate()
	}
	
	@objc func restartTimer(){
		stopTimer()
		startTimer()
	}
	
	
	@objc func showRandomImage() {
		cardImageView.image = cards.randomElement() ?? UIImage(named: "AS")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		timer.invalidate()
	}
	
	
	func configureUI() {
		configureCardImageView()
		configureStopButton()
		configureResetButton()
		configureRulesButton()
	}

	func configureCardImageView() {
		view.addSubview(cardImageView)
		cardImageView.translatesAutoresizingMaskIntoConstraints = false
		cardImageView.image = UIImage(named: "AS")
		
		NSLayoutConstraint.activate([
			cardImageView.widthAnchor.constraint(equalToConstant: 250),
			cardImageView.heightAnchor.constraint(equalToConstant: 350),
			cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)
		])
	}
	
	
	
	func configureStopButton() {
		view.addSubview(stopButton)
		stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			stopButton.widthAnchor.constraint(equalToConstant: 260),
			stopButton.heightAnchor.constraint(equalToConstant: 50),
			stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stopButton.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 30)
		])
	}
		
	func configureResetButton() {
		view.addSubview(resetButton)
		resetButton.addTarget(self, action: #selector(restartTimer), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			resetButton.widthAnchor.constraint(equalToConstant: 115),
			resetButton.heightAnchor.constraint(equalToConstant: 50),
			resetButton.leadingAnchor.constraint(equalTo: stopButton.leadingAnchor),
			resetButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 20)
		])
	}
	
	func configureRulesButton() {
		view.addSubview(rulesButton)
			rulesButton.addTarget(self, action: #selector(presentRulesVC), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			rulesButton.widthAnchor.constraint(equalToConstant: 115),
			rulesButton.heightAnchor.constraint(equalToConstant: 50),
			rulesButton.trailingAnchor.constraint(equalTo: stopButton.trailingAnchor),
			rulesButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 20)
		])
	}
	
	@objc func presentRulesVC() {
		let RulesVC = RulesVC()
		RulesVC.view.backgroundColor = self.view.backgroundColor
		present(RulesVC, animated: true)
	}
}
