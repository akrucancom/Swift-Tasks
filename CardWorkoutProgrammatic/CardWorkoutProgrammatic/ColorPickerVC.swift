//
//  ColorPickerVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Comarch-Andrzej on 09/07/2024.
//

import UIKit

class ColorPickerVC: UIViewController {

	
	let redButton = CWButton(backgroundColor: .systemRed, title: "Red")
	let blueButton = CWButton(backgroundColor: .systemBlue, title: "Blue")
	let greenButton = CWButton(backgroundColor: .systemGreen, title: "Green")
	
	override func viewDidLoad() {
		self.view.backgroundColor = .systemBackground
		super.viewDidLoad()
		configureUI()

	}
	
	func configureUI() {
		configureRedButton()
		configureBlueButton()
		configureGreenButton()
	}
	
	func configureRedButton() {
		view.addSubview(redButton)
		redButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			redButton.widthAnchor.constraint(equalToConstant: 260),
			redButton.heightAnchor.constraint(equalToConstant: 50),
			redButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			redButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
		])
	}
	
	func configureBlueButton() {
		view.addSubview(blueButton)
		blueButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			blueButton.widthAnchor.constraint(equalToConstant: 260),
			blueButton.heightAnchor.constraint(equalToConstant: 50),
			blueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			blueButton.topAnchor.constraint(equalTo: redButton.bottomAnchor, constant: 30)
		])
	}
	
	func configureGreenButton() {
		view.addSubview(greenButton)
		greenButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			greenButton.widthAnchor.constraint(equalToConstant: 260),
			greenButton.heightAnchor.constraint(equalToConstant: 50),
			greenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			greenButton.topAnchor.constraint(equalTo: blueButton.bottomAnchor, constant: 30)
		])
	}
	
	@objc func changeColor(color: CWButton){
		navigationController?.viewControllers.first?.view.backgroundColor = color.backgroundColor
		self.view.backgroundColor = color.backgroundColor
	}

}
