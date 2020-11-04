//
//  HomeSettingVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/10/21.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import SnapKit

class HomeSettingVC: UIViewController {

    let tableView = UITableView()
    let backButton = UIButton()
	let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
    let settingList = ["홈 화면 이름 수정", "비밀번호 재설정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
		tableView.tableFooterView = UIView()
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
		self.view.addSubview(tableView)
		self.view.addSubview(backButton)
		self.view.addSubview(titleLabel)
		
        tableView.delegate = self
        tableView.dataSource = self
		tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
		tableView.backgroundColor = UIColor.appColor(.bgColor)
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		backButton.setImage(UIImage(named: "icLeft"), for: .normal)
		backButton.contentVerticalAlignment = .fill
		backButton.contentHorizontalAlignment = .fill
		backButton.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		backButton.backgroundColor = UIColor.appColor(.bgColor)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.text = "마이페이지"
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.appColor(.titleGray)
		titleLabel.font = UIFont(name:"AppleSDGothicNeo-Medium",size:16)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
			backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14),
			backButton.widthAnchor.constraint(equalToConstant: 44),
			backButton.heightAnchor.constraint(equalToConstant: 44),
			
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
			
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 91),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24)
		])
    }
	
	@objc func barbutton(_ sender: Any){
		self.navigationController?.popViewController(animated: true)
	}
}
extension HomeSettingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.textLabel?.text = settingList[indexPath.row]
		cell.textLabel?.font = UIFont(name:"AppleSDGothicNeo-Regular",size:17)
		cell.textLabel?.textColor = UIColor.appColor(.blackLabel)
		cell.layer.backgroundColor = UIColor.appColor(.bgColor).cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 0{
//            UserDefaults.standard.set("c", forKey: "linkname")
//        }
		let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
		let settingVC = storyBoard.instantiateViewController(withIdentifier: "HomeSettingVC") as! HomeSettingVC
		self.navigationController?.pushViewController(settingVC, animated: true)
    }
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 57
	}
}

class SettingCell: UITableViewCell {
    
}
