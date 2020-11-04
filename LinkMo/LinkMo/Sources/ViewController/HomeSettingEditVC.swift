//
//  HomeSettingEditVC.swift
//  LinkMo
//
//  Created by 김삼복 on 2020/11/04.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit

class HomeSettingEditVC: UIViewController{
	let backButton = UIButton()
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 41))
	let discripLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 327, height: 44))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setConstraint()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		view.backgroundColor = UIColor.appColor(.bgColor)
		navigationController?.isNavigationBarHidden = true
	}
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}
	
	private func setConstraint(){
		self.view.addSubview(backButton)
		self.view.addSubview(titleLabel)
		self.view.addSubview(discripLabel)
		
		backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		backButton.setImage(UIImage(named: "icLeft"), for: .normal)
		backButton.contentVerticalAlignment = .fill
		backButton.contentHorizontalAlignment = .fill
		backButton.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		backButton.backgroundColor = UIColor.appColor(.bgColor)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.text = "홈 화면 문구 수정"
		titleLabel.textColor = UIColor.appColor(.blackLabel)
		titleLabel.font = UIFont(name:"GmarketSansMedium", size:25)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		discripLabel.text = "비밀번호 재설정 인증번호를 받기 위해 가입한 \n이메일을 입력해주세요. "
		discripLabel.numberOfLines = 0
		discripLabel.textColor = UIColor.appColor(.lightGray)
		discripLabel.textAlignment = .left
		discripLabel.font = UIFont(name:"AppleSDGothicNeo-Regular", size:16)
		discripLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
			backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14),
			backButton.widthAnchor.constraint(equalToConstant: 44),
			backButton.heightAnchor.constraint(equalToConstant: 44),
			
			titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 51),
			titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			titleLabel.heightAnchor.constraint(equalToConstant: 41),
			
			discripLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
			discripLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			discripLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			discripLabel.heightAnchor.constraint(equalToConstant: 44)
			
		])
		
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
}
