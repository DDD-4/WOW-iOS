//
//  ShareTableViewController.swift
//  ShareLink
//
//  Created by 김삼복 on 2020/09/25.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social
import CoreData
import RxSwift
import RxDataSources

class ShareTableViewController: UIViewController {
	private let tableView: UITableView = {
		let tableview = UITableView()
		return tableview
	}()
	
	lazy var categoryID = 0
	var sectionList: [TableSection] = []
	let viewModel = TableViewModel()
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ShareSecondTableViewCell.self, forCellReuseIdentifier: "ShareSecondTableViewCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		setConstraint()
		
		viewModel.readSections(categoryId: categoryID)
		.subscribe(onNext: {[weak self] sections in
			self?.sectionList = sections })
		.disposed(by: disposeBag)
		
	}
	private func setConstraint() {
		self.view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
}
class ShareSecondTableViewCell: UITableViewCell{
	private let label: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.gray
		return label
	}()
	let linkTitle = UILabel()
    let linkUrl = UILabel()
}

extension ShareTableViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	tableView.deselectRow(at: indexPath, animated: true)
	let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
		
	}
}

extension ShareTableViewController: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sectionList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSecondTableViewCell", for: indexPath) as? ShareSecondTableViewCell else { return UITableViewCell() }
		let section = sectionList[indexPath.row]
		cell.textLabel?.text = section.header
		return cell
	}
	
	
}
