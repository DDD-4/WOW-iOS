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
    
    let settingList = ["이름 바꾸기"]
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: "Setting")
        tableView.delegate = self
        tableView.dataSource = self
        tableviewAutolayout()
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
            UserDefaults.standard.set("A", forKey: "linkname")
        }
    }
}

class SettingCell: UITableViewCell {
    
}
