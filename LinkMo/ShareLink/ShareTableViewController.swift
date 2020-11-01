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
	
	var categoryID: Int64 = 0
	var categoryIndex = 0
	var categoryAll: Category? = nil
	var sectionList: [TableSection] = []
	let viewModel = TableViewModel()
	let disposeBag = DisposeBag()
	let categoryLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ShareSecondTableViewCell.self, forCellReuseIdentifier: "ShareSecondTableViewCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		
		viewModel.readSections(categoryId: categoryIndex)
		.subscribe(onNext: {[weak self] sections in
			self?.sectionList = sections })
		.disposed(by: disposeBag)
		
		navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 78)
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.layoutIfNeeded()
		navigationController?.navigationBar.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		navigationController?.navigationBar.topItem?.title = ""
		navigationController?.navigationBar.tintColor = .black
		self.title = "카테고리 선택"
		
		categoryLabel.myLabel()
		categoryLabel.text = categoryAll!.title + " >"
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(categoryLabel)
		NSLayoutConstraint.activate([
			categoryLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
			categoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
			categoryLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
			categoryLabel.heightAnchor.constraint(equalToConstant: 30)
		])
		
		setConstraint()
		
	}
	private func setConstraint() {
		self.view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
	
	
}
class ShareSecondTableViewCell: UITableViewCell{
	let tableLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
		label.font = UIFont(name:"AppleSDGothicNeo-Regular" , size: 16)

		return label
	}()
	let imgView: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		img.image = UIImage(named: "checkmark")
		return img
	}()
	
	private func setConstraint() {
		contentView.addSubview(tableLabel)
		contentView.addSubview(imgView)
		tableLabel.translatesAutoresizingMaskIntoConstraints = false
		imgView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
			tableLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			tableLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			tableLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setConstraint()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ShareTableViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: true)
		
//		let vc = ShareAlertViewController()
//		vc.categoryid = categoryID
//		vc.categoryIndex = categoryIndex
//		vc.sectionIndex = indexPath.row
//		vc.categoryAll = categoryAll
//		vc.tablesectionAll = sectionList[indexPath.row].self
//		self.navigationController?.pushViewController(vc, animated: false)
		
		tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
		tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.blue
		
	}
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = true
		tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
	}
}

extension ShareTableViewController: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sectionList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSecondTableViewCell", for: indexPath) as? ShareSecondTableViewCell else { return UITableViewCell() }
		let section = sectionList[indexPath.row]
		
		cell.layer.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100).cgColor
		cell.textLabel?.text = section.header
		cell.textLabel?.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
		cell.textLabel?.font = UIFont(name:"AppleSDGothicNeo-Regular" , size: 16)
		cell.textLabel?.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 36).isActive = true
		cell.accessoryView = cell.imgView
		cell.accessoryView?.isHidden = true
		cell.accessoryView?.leadingAnchor.constraint(equalTo: cell.textLabel!.leadingAnchor).isActive = true
		cell.accessoryView?.topAnchor.constraint(equalTo: cell.textLabel!.topAnchor, constant: 20).isActive = true
		cell.accessoryView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34).isActive = true
		
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 68
	}
}


extension UILabel {
	func myLabel() {
		textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 100)
		font = UIFont(name:"AppleSDGothicNeo-Bold",size:15)
		backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
	}
}

