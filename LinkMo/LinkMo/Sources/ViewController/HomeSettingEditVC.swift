//
//  HomeSettingEditVC.swift
//  LinkMo
//
//  Created by 김삼복 on 2020/11/04.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import EMTNeumorphicView

class HomeSettingEditVC: UIViewController, UITextFieldDelegate{
	let backButton = UIButton()
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 41))
	let discripLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 327, height: 44))
	let nameTextField = UITextField()
	let dashView = UIView()
	let saveBtn = EMTNeumorphicButton(type: .custom)
	var saveTitle = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.nameTextField.delegate = self
		setConstraint()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		view.backgroundColor = UIColor.appColor(.bgColor)
		navigationController?.isNavigationBarHidden = true
		self.nameTextField.becomeFirstResponder()
	}
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.nameTextField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	private func setConstraint(){
		self.view.addSubview(backButton)
		self.view.addSubview(titleLabel)
		self.view.addSubview(discripLabel)
		self.view.addSubview(nameTextField)
		self.view.addSubview(dashView)
		self.view.addSubview(saveBtn)
		self.view.addSubview(saveTitle)
		
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
		
//		discripLabel.text = "홈 화면 카테고리 상단에 표시되는 문구입니다. \n나만의 링크 저장소에 이름을 붙여주세요! "
//		discripLabel.numberOfLines = 0
		discripLabel.textColor = UIColor.appColor(.lightGray)
		discripLabel.textAlignment = .left
		discripLabel.font = UIFont(name:"AppleSDGothicNeo-Regular", size:16)
		discripLabel.translatesAutoresizingMaskIntoConstraints = false
		let attributedString = NSMutableAttributedString(string: "홈 화면 카테고리 상단에 표시되는 문구입니다. \n나만의 링크 저장소에 이름을 붙여주세요! ")
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 2
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
		discripLabel.attributedText = attributedString
		
		
		nameTextField.attributedPlaceholder = NSAttributedString(string: "“00님의 링크”", attributes: [
			.foregroundColor: UIColor.appColor(.lightGray),
			.font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
		])
		nameTextField.backgroundColor = UIColor.appColor(.bgColor)
		nameTextField.borderStyle = .none
		nameTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
		nameTextField.textColor = UIColor.appColor(.titleGray)
		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		
		dashView.translatesAutoresizingMaskIntoConstraints = false
		dashView.addDashedBorder()
		
		saveBtn.frame = CGRect(x: 0, y: 0, width: 335, height: 54)
		saveBtn.layer.cornerRadius = 30
		saveBtn.addTarget(self, action: #selector(savebutton(_:)), for: .touchUpInside)
		saveBtn.neumorphicLayer?.elementBackgroundColor = UIColor.appColor(.bgColor).cgColor
		saveBtn.translatesAutoresizingMaskIntoConstraints = false
		
		saveTitle.text = "저장하기"
		saveTitle.font = UIFont(name:"AppleSDGothicNeo-Medium",size:18)
		saveTitle.textAlignment = .center
		saveTitle.textColor = UIColor.appColor(.pureBlue)
		saveTitle.translatesAutoresizingMaskIntoConstraints = false
		
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
			discripLabel.heightAnchor.constraint(equalToConstant: 44),
			
			nameTextField.topAnchor.constraint(equalTo: discripLabel.bottomAnchor, constant: 48),
			nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			nameTextField.heightAnchor.constraint(equalToConstant: 42),
			
			dashView.topAnchor.constraint(equalTo:nameTextField.bottomAnchor, constant: 1),
			dashView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
			dashView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
			
			saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			saveBtn.topAnchor.constraint(equalTo: dashView.bottomAnchor, constant: 31.5),
			saveBtn.heightAnchor.constraint(equalToConstant: 54),
			
			saveTitle.centerXAnchor.constraint(equalTo: saveBtn.centerXAnchor),
			saveTitle.centerYAnchor.constraint(equalTo: saveBtn.centerYAnchor)
		])
		
	}
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func savebutton(_ sender: Any){
		UserDefaults.standard.set(nameTextField.text, forKey: "linkname")
		self.navigationController?.popViewController(animated: true)
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
