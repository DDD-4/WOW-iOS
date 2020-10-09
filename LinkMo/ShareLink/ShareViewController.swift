//
//  ShareViewController.swift
//  ShareLink
//
//  Created by 김삼복 on 2020/09/08.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social
import CoreData
import RxSwift
import EMTNeumorphicView

class ShareViewController: UIViewController {
	//MARK: - Properties
	let viewModel = HomeViewModel()
	let disposeBag = DisposeBag()
	var categoryList: [Category] = [] {
		didSet{
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	//MARK: - Views
	private let tableView: UITableView = {
		let tableview = UITableView()
		return tableview
	}()
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.outputs.categories
		.subscribe(onNext: {[weak self] categories in
			self?.categoryList = categories })
		.disposed(by: disposeBag)
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ShareTableViewCell.self, forCellReuseIdentifier: "ShareTableViewCell")
		setConstraint()
		// autoHeight
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.inputs.readTitle()
	}
	
	// MARK: - Methods
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

class ShareTableViewCell: UITableViewCell{
	private let label: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.gray
		return label
	}()
	
	private func setConstraint() {
		contentView.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16)
		])
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setConstraint()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
	
extension ShareViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
		
		let vc = ShareTableViewController()
		vc.categoryIndex = indexPath.row
		vc.categoryID = categoryList[indexPath.row].id
		vc.categoryAll = categoryList[indexPath.row].self
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

extension ShareViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryList.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as? ShareTableViewCell else { return UITableViewCell() }
		cell.textLabel?.text = categoryList[indexPath.row].title
		return cell
	}
}
