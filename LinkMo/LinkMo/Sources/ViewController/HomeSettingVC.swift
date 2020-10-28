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

    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let settingList = ["이름 바꾸기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: "Setting")
        tableView.delegate = self
        tableView.dataSource = self
        tableviewAutolayout()
        
        navigationController?.navigationBar.topItem?.title = "설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(backVC(_:)))
    }

    @objc func backVC(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableviewAutolayout(){
        tableView.snp.makeConstraints { (snp) in
            snp.top.equalTo(view)
            snp.bottom.equalTo(view)
            snp.leading.equalTo(view)
            snp.trailing.equalTo(view)
        }
    }
}
extension HomeSettingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingCell
        cell.textLabel?.text = settingList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            UserDefaults.standard.set("c", forKey: "linkname")
        }
    }
}

class SettingCell: UITableViewCell {
    
}
