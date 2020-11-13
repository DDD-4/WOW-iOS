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

class ShareLinkViewController: UIViewController , UITextFieldDelegate{

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
	let urlTitle = UILabel()
	var urlTitleText = UITextField()
	let urlLabel = UILabel()
	var urlText = UITextField()
	let dashView2 = UIView()
	let dashView3 = UIView()
	var shareUrl:String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getURL()
		setConstraint()
		self.urlTitleText.delegate = self
		self.urlTitleText.becomeFirstResponder()
		
//		urlTitleText.rx.controlEvent(.editingChanged)
//			.asObservable()
//			.subscribe(onNext: { _ in
//				
//				self.saveBtn.tintColor = UIColor(red: 0/255, green: 17/255, blue: 232/255, alpha: 1.0)
//			})
//			.disposed(by: disposeBag)

			

	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
		view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.urlTitleText.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func getURL(){
		
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
								self.shareUrl = "\(shareURL)"
								DispatchQueue.main.async {
									self.urlText.attributedPlaceholder = NSAttributedString(string: "\(self.shareUrl)", attributes: [
										.foregroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 100),
										.font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
									])
									self.urlText.text = self.shareUrl
								}
								
								
							}
							
						})
					}
				}
			}
		}
	}
	
	private func setConstraint() {
		
		self.view.addSubview(titleLabel)
		self.view.addSubview(saveBtn)
		self.view.addSubview(saveLabel)
		self.view.addSubview(categoryLabel)
		self.view.addSubview(sectionLabel)
		self.view.addSubview(urlTitle)
		self.view.addSubview(urlTitleText)
		self.view.addSubview(urlLabel)
		self.view.addSubview(urlText)
		view.addSubview(dashView)
		view.addSubview(dashView2)
		view.addSubview(dashView3)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		saveBtn.translatesAutoresizingMaskIntoConstraints = false
		saveLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		dashView.translatesAutoresizingMaskIntoConstraints = false
		sectionLabel.translatesAutoresizingMaskIntoConstraints = false
		urlTitle.translatesAutoresizingMaskIntoConstraints = false
		urlTitleText.translatesAutoresizingMaskIntoConstraints = false
		urlLabel.translatesAutoresizingMaskIntoConstraints = false
		urlText.translatesAutoresizingMaskIntoConstraints = false
		dashView2.translatesAutoresizingMaskIntoConstraints = false
		dashView3.translatesAutoresizingMaskIntoConstraints = false
		dashView.addDashedBorder()
		dashView2.addDashedBorder()
		dashView3.addDashedBorder()
		
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
		saveLabel.textColor = UIColor(red: 0/255, green: 17/255, blue: 232/255, alpha: 100)
		saveLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:16)
		let tap = UITapGestureRecognizer(target: self, action: #selector(ShareLinkViewController.tapFunction))
        saveLabel.isUserInteractionEnabled = true
        saveLabel.addGestureRecognizer(tap)
		
		urlTitle.text = "URL 이름"
		urlTitle.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
		urlTitle.font = UIFont(name:"AppleSDGothicNeo-Medium",size:14)
		
		urlTitleText.placeholder = "url title"
		urlTitleText.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 100)
		urlTitleText.font = UIFont(name:"AppleSDGothicNeo-Medium",size:16)
		
		urlLabel.text = "URL"
		urlLabel.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 100)
		urlLabel.font = UIFont(name:"AppleSDGothicNeo-Medium",size:14)
		
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
			dashView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			
			urlTitle.topAnchor.constraint(equalTo: dashView.bottomAnchor, constant: 35.5),
			urlTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			urlTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			
			urlTitleText.topAnchor.constraint(equalTo: urlTitle.bottomAnchor, constant: 16),
			urlTitleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			urlTitleText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),

			dashView2.topAnchor.constraint(equalTo: urlTitleText.bottomAnchor, constant: 11.5),
			dashView2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			dashView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),

			urlLabel.topAnchor.constraint(equalTo: dashView2.bottomAnchor, constant: 35.5),
			urlLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			urlLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),

			urlText.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 16),
			urlText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			urlText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),

			dashView3.topAnchor.constraint(equalTo: urlText.bottomAnchor, constant: 11.5),
			dashView3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			dashView3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
		])
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func tapFunction(_ sender: Any){
		self.share.createCells(category: self.categoryAll!, tablesection: self.tablesectionAll!, categoryNumber: self.categoryIndex, sectionNumber: self.sectionIndex, linkTitle: self.urlTitleText.text ?? shareUrl, linkUrl: shareUrl, png: (self.thumbnail.pngData() ?? UIImage(named: "appicon")!.pngData())!)
		
		self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		urlText.text = shareUrl
		
	}
}

