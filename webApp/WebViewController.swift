//
//  WebViewController.swift
//  webApp
//
//  Created by Mariya Aliyeva on 23.03.2024.
//

import UIKit
import WebKit

protocol AddFavWebsiteDelegate: AnyObject {
	func addFavWeb(favWebsite: Website)
}

final class WebViewController: UIViewController {
	
	var website: Website?
	weak var addFavDelegate: AddFavWebsiteDelegate?
	var spinner = UIActivityIndicatorView()
	private var timer: Timer!
	
	// MARK: - UI
	private let webView: WKWebView = {
		let prefs = WKWebpagePreferences()
		prefs.allowsContentJavaScript = true
		let config = WKWebViewConfiguration()
		config.defaultWebpagePreferences = prefs
		let webView = WKWebView(frame: .zero, configuration: config)
		return webView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		loadWebSite()
		setupNavigationBar()
		setupViews()
		setupConstraints()
		doubleTap()
	//	spinner.startAnimating()
		webView.navigationDelegate = self
	//	spinner.hidesWhenStopped = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
			self.spinner.hidesWhenStopped = true
		}
	}
	
	// MARK: - SetupNavigationBar
	
	private func setupNavigationBar() {
		title = website?.title
		self.navigationItem.setHidesBackButton(true, animated: false)
	}
	
	private func loadWebSite() {
		if website?.siteUrl != nil {
			spinner.startAnimating()
		}
		guard let siteUrl = URL(string: website?.siteUrl ?? "") else { return }
		let request = URLRequest(url: siteUrl)
		webView.load(request)
	}
	
	private func doubleTap() {
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
		doubleTapGestureRecognizer.delegate = self
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		webView.addGestureRecognizer(doubleTapGestureRecognizer)
		
		timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.setBackgroundColor), userInfo: nil, repeats: true)
	}
	
	@objc
	func handleDoubleTap(gestureReconizer: UITapGestureRecognizer) {
	
		view.backgroundColor = .yellow
		
		let favWebsite = Website(title: website?.title ?? "", siteUrl: website?.siteUrl ?? "")
		addFavDelegate?.addFavWeb(favWebsite: favWebsite)
		return
	}
	
	@objc
	func setBackgroundColor() {
		self.view.backgroundColor = .white
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		view.addSubview(webView)
		webView.addSubview(spinner)
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		webView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		spinner.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
}

// MARK: - UIGestureRecognizerDelegate

extension WebViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(
		_: UIGestureRecognizer,
		shouldRecognizeSimultaneouslyWith: UIGestureRecognizer)
	-> Bool {
		return true
	}
	
	func gestureRecognizer(
		_: UIGestureRecognizer,
		shouldReceive:UITouch)
	-> Bool {
		return true
	}
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
	
	func webView(
		_ webView: WKWebView,
		didFinish navigation: WKNavigation!) {
			spinner.stopAnimating()
		}
	
	func webView(
		_ webView: WKWebView,
		didFail navigation: WKNavigation!,
		withError error: Error) {
			spinner.stopAnimating()
		}
}
