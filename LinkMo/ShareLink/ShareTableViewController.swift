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
import LinkPresentation

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
	let share = CategoryManager.share
	let categoryLabel = UILabel()
	var sectionIndex: Int = 0
	var tablesectionAll: TableSection? = nil
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 89, height: 24))
	let buttonSet = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	let dashView = UIView()
	var thumbnail = UIImage()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.readSections(categoryId: categoryIndex)
			.subscribe(onNext: {[weak self] sections in
				self?.sectionList = sections })
			.disposed(by: disposeBag)
		
		setConstraint()
		

	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
		view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}
	
	private func setConstraint() {
		self.view.addSubview(tableView)
		self.view.addSubview(categoryLabel)
		self.view.addSubview(titleLabel)
		self.view.addSubview(buttonSet)
		view.addSubview(dashView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ShareSecondTableViewCell.self, forCellReuseIdentifier: "ShareSecondTableViewCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.myLabel()
		categoryLabel.text = categoryAll!.title + " >"
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		buttonSet.translatesAutoresizingMaskIntoConstraints = false
		dashView.translatesAutoresizingMaskIntoConstraints = false
		dashView.addDashedBorder()
		
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
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 40),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			
			titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24),
			
			buttonSet.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 14),
			buttonSet.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			
			categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 62),
			categoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			categoryLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			categoryLabel.heightAnchor.constraint(equalToConstant: 30),
			
			dashView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 7.5),
			dashView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			dashView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
			
		])
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
		
}
class ShareSecondTableViewCell: UITableViewCell{
	let imgView1: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
		return img
	}()
	let imgView2: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
		return img
	}()
	let imgView3: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
		return img
	}()
	let imgView4: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
		return img
	}()
	
	let tableLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 100)
		label.font = UIFont(name:"AppleSDGothicNeo-Medium" , size: 17)

		return label
	}()
	
	let checkView: UIImageView = {
		var img = UIImageView()
		img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		img.image = UIImage(named: "checkmark")
		return img
	}()
	
	private func setConstraint() {
		contentView.addSubview(tableLabel)
		contentView.addSubview(checkView)
		contentView.addSubview(imgView1)
		contentView.addSubview(imgView2)
		contentView.addSubview(imgView3)
		contentView.addSubview(imgView4)
		tableLabel.translatesAutoresizingMaskIntoConstraints = false
		checkView.translatesAutoresizingMaskIntoConstraints = false
		imgView1.translatesAutoresizingMaskIntoConstraints = false
		imgView2.translatesAutoresizingMaskIntoConstraints = false
		imgView3.translatesAutoresizingMaskIntoConstraints = false
		imgView4.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imgView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			imgView1.widthAnchor.constraint(equalToConstant: 18),
			imgView1.heightAnchor.constraint(equalToConstant: 18),
			imgView2.widthAnchor.constraint(equalToConstant: 18),
			imgView2.heightAnchor.constraint(equalToConstant: 18),
			imgView3.widthAnchor.constraint(equalToConstant: 18),
			imgView3.heightAnchor.constraint(equalToConstant: 18),
			imgView4.widthAnchor.constraint(equalToConstant: 18),
			imgView4.heightAnchor.constraint(equalToConstant: 18),
			
			imgView2.leftAnchor.constraint(equalTo: imgView1.rightAnchor, constant: 2),
			imgView2.centerYAnchor.constraint(equalTo: imgView1.centerYAnchor),
			imgView3.topAnchor.constraint(equalTo: imgView1.bottomAnchor, constant: 2),
			imgView3.centerXAnchor.constraint(equalTo: imgView1.centerXAnchor),
			imgView4.leftAnchor.constraint(equalTo: imgView3.rightAnchor, constant: 2),
			imgView4.centerYAnchor.constraint(equalTo: imgView3.centerYAnchor),
			
			tableLabel.leftAnchor.constraint(equalTo: imgView2.rightAnchor, constant: 8),
			tableLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),
			tableLabel.heightAnchor.constraint(equalToConstant: 38)
			
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
		tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
		tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.blue
		
		self.sectionIndex = indexPath.row
		self.tablesectionAll = sectionList[indexPath.row].self
		
		let vc = ShareLinkViewController()
		vc.categoryAll = categoryAll
		vc.categoryIndex = categoryIndex
		vc.sectionIndex = indexPath.row
		vc.tablesectionAll = sectionList[indexPath.row].self
		self.navigationController?.pushViewController(vc, animated: true)
		
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
		
		if(section.thumbnail.count == 0){
			cell.imgView1.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView2.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView3.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView4.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
		}else if(section.thumbnail.count == 1){
			cell.imgView1.image = UIImage(data: section.thumbnail[0])
			cell.imgView2.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView3.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView4.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
		}else if(section.thumbnail.count == 2){
			cell.imgView1.image = UIImage(data: section.thumbnail[0])
			cell.imgView2.image = UIImage(data: section.thumbnail[1])
			cell.imgView3.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
			cell.imgView4.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
		}else if(section.thumbnail.count == 3){
			cell.imgView1.image = UIImage(data: section.thumbnail[0])
			cell.imgView2.image = UIImage(data: section.thumbnail[1])
			cell.imgView3.image = UIImage(data: section.thumbnail[2])
			cell.imgView4.image = UIImage(named: "appicon")?.withTintColor(.systemGray)
		}else if(section.thumbnail.count >= 4){
			cell.imgView1.image = UIImage(data: section.thumbnail[0])
			cell.imgView2.image = UIImage(data: section.thumbnail[1])
			cell.imgView3.image = UIImage(data: section.thumbnail[2])
			cell.imgView4.image = UIImage(data: section.thumbnail[3])
		}
		
		cell.layer.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100).cgColor
		cell.tableLabel.text = section.header
		
		
		cell.accessoryView = cell.checkView
		cell.accessoryView?.isHidden = true
		cell.accessoryView?.widthAnchor.constraint(equalToConstant: 38).isActive = true
		cell.accessoryView?.heightAnchor.constraint(equalToConstant: 38).isActive = true
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
		textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 100)
		font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
	}
}

extension UIView {
    func addDashedBorder() {
        let shapeLayer = CAShapeLayer()
		shapeLayer.strokeColor = UIColor(red: 231/255, green: 234/255, blue: 240/255, alpha: 100).cgColor
        shapeLayer.lineWidth = 1
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.frame.height),
								CGPoint(x: UIScreen.main.bounds.width - 48, y: self.frame.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
