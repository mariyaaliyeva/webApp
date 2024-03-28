//
//  ViewController.swift
//  webApp
//
//  Created by Mariya Aliyeva on 21.03.2024.
//

import UIKit
import SnapKit

final class AddWebSiteViewController: UIViewController {
	
	var websites: [Website] = [
		Website(title: "Youtube", siteUrl: "https://www.youtube.com/"),
		Website(title: "Stepik", siteUrl: "https://stepik.org/lesson/744711/step/4?unit=746480")
	]
	var favouriteWebsites: [Website] = [
		Website(title: "Stepik", siteUrl: "https://stepik.org/lesson/744711/step/4?unit=746480")
	]
	lazy var listWebsite = websites

// MARK: - UI
	
	private var favouritesSegments: UISegmentedControl = {
		let segment = UISegmentedControl(items: ["List", "Favourites"])
		segment.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
		return segment
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - Navigation bar
	private func setupNavigationBar() {
		self.navigationItem.title = "Websites"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "plus"),
			style: .plain,
			target: self,
			action: #selector(addButtonTapped))
	}
	
	@objc
	func addButtonTapped() {
		let alert = UIAlertController(title: "Add website", message: "Fill all the fields", preferredStyle: .alert)
		alert.addTextField { (textField:UITextField) in
			textField.placeholder = "Enter title"
		}
		alert.addTextField { (textField:UITextField) in
			textField.placeholder = "Enter url"
		}
		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] (action:UIAlertAction) in
			guard let textField =  alert.textFields?.first, ((alert.textFields?.first?.hasText) != nil) else {
				return
			}
			guard let textField2 =  alert.textFields?[1], ((alert.textFields?[1].hasText) != nil) else {
				return
			}
			let web = Website(title: textField.text!, siteUrl: textField2.text!)
			listWebsite.append(web)
			tableView.reloadData()
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc
	func segmentAction(_ sender: UISegmentedControl) {
		
		let index = sender.selectedSegmentIndex
		print(index)
		switch index {
		case 0:
			listWebsite = websites
		case 1:
			listWebsite = favouriteWebsites
		default:
			break
		}
		tableView.reloadData()
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		view.addSubview(favouritesSegments)
		favouritesSegments.selectedSegmentIndex = 0
		view.addSubview(tableView)
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		favouritesSegments.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
			make.centerX.equalToSuperview()
		}
		
		tableView.snp.makeConstraints { make in
			make.top.equalTo(favouritesSegments.snp.bottom).offset(24)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
}

extension AddWebSiteViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listWebsite.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
		let websites = listWebsite[indexPath.row]
		cell.textLabel?.text = websites.title
		let right = UIImage(systemName: "chevron.right")
		cell.accessoryView = UIImageView(image: right)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = WebViewController()
		let websites = listWebsite[indexPath.row]
		controller.website = websites
		controller.addFavDelegate = self
		splitViewController?.showDetailViewController(controller, sender: self)
	}
}

extension AddWebSiteViewController: AddFavWebsiteDelegate {
	func addFavWeb(favWebsite: Website) {
		self.dismiss(animated: true) {
			self.favouriteWebsites.append(favWebsite)
			self.tableView.reloadData()
		}
	}
}
