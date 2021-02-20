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
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 89, height: 24))
	let buttonSet = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	let saveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 28, height: 22))
	let nameLabel = UILabel()
	
	//MARK: - Views
	private let tableView: UITableView = {
		let tableview = UITableView()
		return tableview
	}()
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
		viewModel.outputs.categories
			.subscribe(onNext: {[weak self] categories in
				self?.categoryList = categories })
			.disposed(by: disposeBag)
		
		tableView.delegate = self
		tableView.dataSource = self
		setConstraint()
		tableView.register(ShareTableViewCell.self, forCellReuseIdentifier: "ShareTableViewCell")
		
		//view
		tableView.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		tableView.tableFooterView = UIView()
		
		
		titleLabel.text = "linkmo"
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor(red: 89/255, green: 86/255, blue: 109/255, alpha: 100)
		titleLabel.font = UIFont(name:"GmarketSansLight",size:18)
		
		
		buttonSet.layer.cornerRadius = 5
		buttonSet.setImage(UIImage(named: "icLeft"), for: .normal)
		buttonSet.setImage(UIImage(named: "icLeft"), for: .selected)
		buttonSet.contentVerticalAlignment = .fill
		buttonSet.contentHorizontalAlignment = .fill
		buttonSet.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		buttonSet.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		
		saveLabel.text = "저장"
		saveLabel.textAlignment = .center
		saveLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 100)
		saveLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		
		nameLabel.text = "linkmo님의 링크."
		nameLabel.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
		nameLabel.font = UIFont(name:"GmarketSansLight",size:26)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.inputs.readTitle()
		navigationController?.isNavigationBarHidden = true
		view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
        tableView.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}
	
	// MARK: - Methods
	private func setConstraint() {
		self.view.addSubview(tableView)
		self.view.addSubview(titleLabel)
		self.view.addSubview(buttonSet)
		self.view.addSubview(saveLabel)
		self.view.addSubview(nameLabel)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		buttonSet.translatesAutoresizingMaskIntoConstraints = false
		saveLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24),
			
			buttonSet.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 14),
			buttonSet.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			
			saveLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
			saveLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45),
			nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
			
			tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 41),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24)
		])
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
	
}

class ShareTableViewCell: UITableViewCell{
	var emojilabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name:"AppleColorEmoji" , size: 15)
		return label
	}()
	
	var titlelabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 100)
		label.font = UIFont(name:"AppleSDGothicNeo-Medium" , size: 17)
		return label
	}()
	
	private func setConstraint() {
		contentView.addSubview(emojilabel)
		contentView.addSubview(titlelabel)
		emojilabel.translatesAutoresizingMaskIntoConstraints = false
		titlelabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			emojilabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			emojilabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
			titlelabel.leftAnchor.constraint(equalTo: emojilabel.rightAnchor, constant: 7),
			titlelabel.centerYAnchor.constraint(equalTo: emojilabel.centerYAnchor)
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

		//navigation
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
		cell.emojilabel.text = categoryList[indexPath.row].icon
		cell.titlelabel.text = categoryList[indexPath.row].title
        cell.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}
