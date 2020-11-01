//
//  EditTitleViewController.swift
//  LinkMo
//
//  Created by 김삼복 on 2020/11/01.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import EMTNeumorphicView

class EditTitleViewController: UIViewController {
	let buttonSet = EMTNeumorphicButton(type: .custom)
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
	let emojiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
	let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 335, height: 54))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(buttonSet)
		view.addSubview(titleLabel)
		view.addSubview(emojiLabel)
		view.addSubview(textField)
		
		titleLabel.text = "타이틀 수정"
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.appColor(.titleGray)
		titleLabel.font = UIFont(name:"AppleSDGothicNeo-Light",size:16)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		buttonSet.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		buttonSet.layer.cornerRadius = 5
		buttonSet.setImage(UIImage(named: "chevronLeft"), for: .normal)
		buttonSet.setImage(UIImage(named: "chevronLeft"), for: .selected)
		buttonSet.contentVerticalAlignment = .fill
		buttonSet.contentHorizontalAlignment = .fill
		buttonSet.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
		buttonSet.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		buttonSet.neumorphicLayer?.elementBackgroundColor = UIColor.appColor(.bgColor).cgColor
		buttonSet.translatesAutoresizingMaskIntoConstraints = false
		
		emojiLabel.text = "이모지"
		emojiLabel.textColor = UIColor.appColor(.titleGray)
		emojiLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:14)
		emojiLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			buttonSet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			buttonSet.topAnchor.constraint(equalTo: view.topAnchor, constant: 53),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
			emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
			emojiLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32)
		])
	}
	
	override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.appColor(.bgColor)
		navigationController?.isNavigationBarHidden = true
	}
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
}

