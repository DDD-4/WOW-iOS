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
	let viewModel = HomeViewModel()
	let backButton = UIButton()
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
	let emojiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
	let categoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
	let emojiTextField = CustomField()
	let categoryTextField = CustomField()
	var originCategory :Category? = nil
	let saveBtn = EMTNeumorphicButton(type: .custom)
	var saveTitle = UILabel()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(backButton)
		view.addSubview(titleLabel)
		view.addSubview(emojiLabel)
		view.addSubview(categoryLabel)
		view.addSubview(emojiTextField)
		view.addSubview(categoryTextField)
		view.addSubview(saveBtn)
		view.addSubview(saveTitle)
		
		titleLabel.text = "타이틀 수정"
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.appColor(.titleGray)
		titleLabel.font = UIFont(name:"AppleSDGothicNeo-Light",size:16)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		backButton.setImage(UIImage(named: "icLeft"), for: .normal)
		backButton.contentVerticalAlignment = .fill
		backButton.contentHorizontalAlignment = .fill
		backButton.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		backButton.backgroundColor = UIColor.appColor(.bgColor)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		
		saveTitle.text = "수정 완료"
		saveTitle.font = UIFont(name:"AppleSDGothicNeo-Medium",size:18)
		saveTitle.textAlignment = .center
		saveTitle.textColor = UIColor.appColor(.pureBlue)
		saveTitle.translatesAutoresizingMaskIntoConstraints = false
		
		saveBtn.frame = CGRect(x: 0, y: 0, width: 335, height: 54)
		saveBtn.layer.cornerRadius = 30
		saveBtn.addTarget(self, action: #selector(savebutton(_:)), for: .touchUpInside)
		saveBtn.neumorphicLayer?.elementBackgroundColor = UIColor.appColor(.bgColor).cgColor
		saveBtn.translatesAutoresizingMaskIntoConstraints = false
		
		emojiLabel.text = "이모지"
		emojiLabel.textColor = UIColor.appColor(.titleGray)
		emojiLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:14)
		emojiLabel.translatesAutoresizingMaskIntoConstraints = false
		
		categoryLabel.text = "카테고리 이름"
		categoryLabel.textColor = UIColor.appColor(.titleGray)
		categoryLabel.font = UIFont(name:"AppleSDGothicNeo-Regular",size:14)
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		
		emojiTextField.placeholder = "   \(originCategory?.icon ?? " ")"
		emojiTextField.translatesAutoresizingMaskIntoConstraints = false
		
		categoryTextField.placeholder = "   \(originCategory?.title ?? " ")"
		categoryTextField.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
			backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14),
			
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
			emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 143),
			emojiLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
			emojiTextField.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 6),
			emojiTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			emojiTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			emojiTextField.heightAnchor.constraint(equalToConstant: 54),
			categoryLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
			categoryLabel.trailingAnchor.constraint(equalTo: emojiLabel.trailingAnchor),
			categoryLabel.topAnchor.constraint(equalTo: emojiTextField.bottomAnchor, constant: 28),
			categoryTextField.leadingAnchor.constraint(equalTo: emojiTextField.leadingAnchor),
			categoryTextField.trailingAnchor.constraint(equalTo: emojiTextField.trailingAnchor),
			categoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 6),
			categoryTextField.heightAnchor.constraint(equalToConstant: 54),
			saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -94),
			saveBtn.heightAnchor.constraint(equalToConstant: 54),
			saveTitle.centerXAnchor.constraint(equalTo: saveBtn.centerXAnchor),
			saveTitle.centerYAnchor.constraint(equalTo: saveBtn.centerYAnchor)
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
	
	@objc func savebutton(_ sender: Any){
		var iconNew = emojiTextField.text
		var titleNew = categoryTextField.text
		if((iconNew?.isEmpty)!) {
			iconNew = originCategory?.icon
		}
		if((titleNew?.isEmpty)!) {
			titleNew = originCategory?.title
		}
		self.viewModel.inputs.updateTitle(category: originCategory!, title: titleNew!, icon: iconNew!)
		self.navigationController?.popViewController(animated: true)
	}
}


class CustomField: UITextField {

    lazy var innerShadow: CALayer = {
        let innerShadow = CALayer()
        layer.addSublayer(innerShadow)
        return innerShadow
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }

    func applyDesign() {
		innerShadow.frame = safeAreaLayoutGuide.layoutFrame
        let radius = self.frame.size.height/2
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy:-1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()

        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.darkGray.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 2)
        innerShadow.shadowOpacity = 0.5
        innerShadow.shadowRadius = 4
		innerShadow.cornerRadius = self.frame.size.height/2
    }
}
