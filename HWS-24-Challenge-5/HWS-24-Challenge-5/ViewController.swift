//
//  ViewController.swift
//  HWS-24-Challenge-5
//
//  Created by Comarch-Andrzej on 15/07/2024.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
	var webView: WKWebView!
	var progressView: UIProgressView!
	var websites: [String] = []
	var startWebsiteIndex = 0
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		toolbarItemsLoader()
		
		let url = URL(string: "https://" + websites[startWebsiteIndex])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
	}
	
	func toolbarItemsLoader() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		let back = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
		let forward = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		toolbarItems = [progressButton, spacer, back, forward, refresh]
		navigationController?.isToolbarHidden = false
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}

	@objc func openTapped() {
		let acOpenTapped = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
		for website in websites {
			acOpenTapped.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		acOpenTapped.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		acOpenTapped.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(acOpenTapped, animated: true)
	}
	
	func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { return }
		guard let url = URL(string: "https://" + actionTitle) else { return }
		webView.load(URLRequest(url: url))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
			let actionSheetController = UIAlertController(title: "Error", message: "\(url?.host ?? "This") is not a valid website", preferredStyle: .alert)
			let closeAction = UIAlertAction(title: "Close", style: .destructive) { _ in }
			actionSheetController.addAction(closeAction)
			present(actionSheetController, animated: true, completion: nil)
		}
		decisionHandler(.cancel)
	}
}
