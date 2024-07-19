//
//  ViewController.swift
//  HWS-30-6b
//
//  Created by Comarch-Andrzej on 16/07/2024.
//

import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let label1 = UILabel()
		label1.backgroundColor = .red
		label1.text = "THESE"
		
		let label2 = UILabel()
		label2.backgroundColor = .cyan
		label2.text = "NUTS"
		
		let label3 = UILabel()
		label3.backgroundColor = .yellow
		label3.text = "MAKE"
		
		let label4 = UILabel()
		label4.backgroundColor = .green
		label4.text = "GREAT"
		
		let label5 = UILabel()
		label5.backgroundColor = .orange
		label5.text = "NUTRITION"
		
		var labels = [label1, label2, label3, label4, label5]
		
		for label in labels {
			label.translatesAutoresizingMaskIntoConstraints = false
			label.sizeToFit()
			view.addSubview(label)
		}
		var previous: UILabel?
		
		for label in labels {
			label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
			label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
			label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -8).isActive = true
			
			if let previous = previous {
				label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
			} else {
				label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
			}
			
			previous = label
		}
	}
}
