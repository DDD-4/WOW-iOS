//
//  LaunchScreenVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/10/17.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import SnapKit

class LaunchScreenVC: UIViewController {

    let linkLbl = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor.appColor(.pureBlue)
    }

    func linkLabel(){
        
        linkLbl.text = "link"
        linkLbl.font = UIFont(name: "GmarketSansLight", size: 35)
    }
}
