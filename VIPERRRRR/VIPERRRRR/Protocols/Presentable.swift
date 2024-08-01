//
//  Presentable.swift
//  VIPERRRRR
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import Foundation

protocol Presentable {
	associatedtype I: Interactable
	associatedtype R: Routerable
	var dependencies: (interactor: I, router: R) { get }
}
