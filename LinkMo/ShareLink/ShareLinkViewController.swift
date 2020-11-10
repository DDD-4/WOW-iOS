//
//  ShareLinkViewController.swift
//  LinkMo
//
//  Created by 김삼복 on 2020/11/10.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social
import CoreData
import RxSwift
import RxDataSources
import LinkPresentation

class ShareLinkViewController: UIViewController {

	let viewModel = TableViewModel()
	let disposeBag = DisposeBag()
	let share = CategoryManager.share
	var categoryAll: Category? = nil
	var categoryIndex = 0
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 89, height: 24))
	let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	let saveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 28, height: 22))
	let categoryLabel = UILabel()
	let sectionLabel = UILabel()
	var sectionIndex: Int = 0
	var tablesectionAll: TableSection? = nil
	let dashView = UIView()
	var thumbnail = UIImage()
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
		self.view.addSubview(titleLabel)
		self.view.addSubview(saveBtn)
		self.view.addSubview(saveLabel)
		self.view.addSubview(categoryLabel)
		self.view.addSubview(sectionLabel)
		view.addSubview(dashView)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		saveBtn.translatesAutoresizingMaskIntoConstraints = false
		saveLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		dashView.translatesAutoresizingMaskIntoConstraints = false
		sectionLabel.translatesAutoresizingMaskIntoConstraints = false
		dashView.addDashedBorder()
		
		categoryLabel.text = categoryAll!.title + " > "
		categoryLabel.textColor =  UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 100)
		categoryLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		
		sectionLabel.text = tablesectionAll!.header
		sectionLabel.textColor =  UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 100)
		sectionLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		
		titleLabel.text = "linkmo"
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor(red: 89/255, green: 86/255, blue: 109/255, alpha: 100)
		titleLabel.font = UIFont(name:"GmarketSansLight",size:18)
		
		saveBtn.layer.cornerRadius = 5
		saveBtn.setImage(UIImage(named: "icLeft"), for: .normal)
		saveBtn.setImage(UIImage(named: "icLeft"), for: .selected)
		saveBtn.contentVerticalAlignment = .fill
		saveBtn.contentHorizontalAlignment = .fill
		saveBtn.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		saveBtn.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		
		saveLabel.text = "저장"
		saveLabel.textAlignment = .center
		saveLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 100)
		saveLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		let tap = UITapGestureRecognizer(target: self, action: #selector(ShareLinkViewController.tapFunction))
        saveLabel.isUserInteractionEnabled = true
        saveLabel.addGestureRecognizer(tap)
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24),
			
			saveBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 14),
			saveBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			
			saveLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
			saveLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			
			categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 62),
			categoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			categoryLabel.heightAnchor.constraint(equalToConstant: 30),
			
			sectionLabel.leftAnchor.constraint(equalTo: categoryLabel.rightAnchor),
			sectionLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
			
			dashView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 7.5),
			dashView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			dashView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
		])
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func tapFunction(_ sender: Any){
		if let item = extensionContext?.inputItems.first as? NSExtensionItem {
			if let attachments = item.attachments as? [NSItemProvider] {
				
				if let attachment = attachments.first {
					attachment.loadPreviewImage(options: nil, completionHandler: { (item, error) in
						if error != nil {
							print("share extension second table VC thumnail image error : ", error)
						} else if let img = item as? UIImage {
							self.thumbnail = img
						}
					})
				}
				
				for attachment: NSItemProvider in attachments {
					if attachment.hasItemConformingToTypeIdentifier("public.url") {
						attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
							if let shareURL = url as? NSURL {
								
								
								self.share.createCells(category: self.categoryAll!, tablesection: self.tablesectionAll!, categoryNumber: self.categoryIndex, sectionNumber: self.sectionIndex, linkTitle: "\(shareURL)", linkUrl: "\(shareURL)", png: (self.thumbnail.pngData() ?? UIImage(named: "appicon")!.pngData())!)
							}
							self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
						})
					}
				}
			}
		}
		
	}
}

