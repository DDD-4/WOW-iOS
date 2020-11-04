//
//  LinkTitleUpdateVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/11/03.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import EMTNeumorphicView
import SnapKit
import RxSwift
import RxCocoa
import LinkPresentation

class LinkTitleUpdateVC: UIViewController, UITextFieldDelegate {

    let designLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let buttonSet = UIButton(type: .custom)
    
    // title
    let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    let titleTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    // link
    let linkLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    let linkTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    // Button
    let confirmBtn = EMTNeumorphicButton(type: .custom)
    let tableshard = TableViewModel.shard
    
    var sectionValue = 0
    var rowValue = 0
    var categoryid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(designLabel)
        view.addSubview(buttonSet)
        view.addSubview(titleLbl)
        view.addSubview(titleTextfield)
        view.addSubview(linkLbl)
        view.addSubview(linkTextfield)
        view.addSubview(confirmBtn)
        
        navigationBar()
        titleUpdate()
        linkUpdate()
        confirmButton()
        view.backgroundColor = UIColor.appColor(.bgColor)
        
        linkTextfield.delegate = self
        titleTextfield.delegate = self
        

        titleTextfield.rx.text.orEmpty
            .bind(to: tableshard.titleValidS)
            .disposed(by: bag)
        tableshard.titleValidS
            .map(tableshard.checkTitle(_:))
            .bind(to: tableshard.titleVBool)
            .disposed(by: bag)

        linkTextfield.rx.text.orEmpty
            .bind(to: tableshard.urlValidS)
            .disposed(by: bag)
        
        tableshard.urlValidS
            .map(tableshard.checkURL(_:))
            .bind(to: tableshard.urlVBool)
            .disposed(by: bag)
    
        Observable.combineLatest(tableshard.titleVBool, tableshard.urlVBool, resultSelector: {$0 && $1})
        .subscribe(onNext: { b in
            if b == false{
                
                self.confirmBtn.isEnabled = false
                self.confirmBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                self.confirmBtn.isEnabled = true
                self.confirmBtn.setTitleColor(UIColor.appColor(.pureBlue), for: .normal)
            }
        })
        .disposed(by: bag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { _ in
                var updateTitle = self.titleTextfield.text!
                var updatelink = self.linkTextfield.text!
                
                defer{
                    self.tableshard.showActivityIndicatory(trueFalse: true, uiView: self.view)
                    _ = self.tableshard.updateCells(categoryid: self.categoryid, section: self.sectionValue, cellrow: self.rowValue, title: updateTitle, link: updatelink)
                    _ = self.tableshard.readSections(categoryId: self.categoryid)
                    
                    let encodings = updatelink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let updateUrl = URL(string: encodings)!
                    
                    LPMetadataProvider().startFetchingMetadata(for: updateUrl) { (linkMetadata, error) in
                        guard let linkMetadata = linkMetadata,
                            let imageProvider = linkMetadata.imageProvider else {
                                return DispatchQueue.main.async {
                                    let images = UIImage(named: "12")
                                    let convert = images?.pngData()
                                    
                                    _ = self.tableshard.updatePng(categoryid: self.categoryid, section: self.sectionValue, cellrow: self.rowValue, png: convert!)
                                    self.navigationController?.popViewController(animated: true)
                                    self.tableshard.showActivityIndicatory(trueFalse: false, uiView: self.view)
                                }
                        }
                        imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                            guard error == nil else {
                                return
                            }
                            if let image = image as? UIImage {
                                // do something with image
                                DispatchQueue.main.async {
                                    let images = image
                                    let convert = images.pngData()
                                    
                                    _ = self.tableshard.updatePng(categoryid: self.categoryid, section: self.sectionValue, cellrow: self.rowValue, png: convert!)
                                    self.navigationController?.popViewController(animated: true)
                                    self.tableshard.showActivityIndicatory(trueFalse: false, uiView: self.view)
                                }
                            } else {
                                print("no image available")
                            }
                        }
                        
                    }
                }
                
                if updatelink.contains("https://") || updatelink.contains("http://"){
                    
                }else if updatelink.isEmpty{
                    updatelink = self.tableshard.sections[self.sectionValue].linked[self.rowValue]
                }else{
                    updatelink = "https://\(updatelink)"
                }
                
                if updateTitle.isEmpty{
                    updateTitle = self.tableshard.sections[self.sectionValue].titled[self.rowValue]
                }
                
            })
        .disposed(by: bag)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뉴모피즘 색
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    func titleUpdate(){
        titleLbl.text = "타이틀"
        titleLbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        titleLbl.textColor = UIColor.appColor(.titleGray)
        
        titleTextfield.backgroundColor = UIColor.white
        titleTextfield.keyboardType = .default
        titleTextfield.contentVerticalAlignment = .center
        titleTextfield.layer.cornerRadius = titleTextfield.frame.size.height / 2
        titleTextfield.placeholder = tableshard.sections[sectionValue].titled[rowValue]
        titleTextfield.setLeftPaddingPoints(10)
        titleTextfield.setRightPaddingPoints(10)
        
        titleLbl.snp.makeConstraints { (snp) in
            snp.height.equalTo(20)
            snp.width.equalTo(100)
            snp.top.equalTo(designLabel).offset(64)
            snp.leading.equalTo(view).offset(32)
            snp.trailing.lessThanOrEqualTo(view)
        }
        
        titleTextfield.snp.makeConstraints { (snp) in
            snp.top.equalTo(titleLbl.snp.bottom).offset(6)
            snp.leading.equalTo(view).offset(20)
            snp.trailing.equalTo(view).offset(-20)
            snp.height.equalTo(54)
        }
    }
    func linkUpdate(){
        linkLbl.text = "링크"
        linkLbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        linkLbl.textColor = UIColor.appColor(.titleGray)
        
        linkTextfield.backgroundColor = UIColor.white
        linkTextfield.keyboardType = .default
        linkTextfield.contentVerticalAlignment = .center
        linkTextfield.layer.cornerRadius = linkTextfield.frame.size.height / 2
        linkTextfield.placeholder = tableshard.sections[sectionValue].linked[rowValue]
        linkTextfield.setLeftPaddingPoints(10)
        linkTextfield.setRightPaddingPoints(10)
        
        linkLbl.snp.makeConstraints { (snp) in
            snp.height.equalTo(20)
            snp.width.equalTo(100)
            snp.top.equalTo(titleTextfield.snp.bottom).offset(28)
            snp.leading.equalTo(view).offset(32)
            snp.trailing.lessThanOrEqualTo(view)
        }
        
        linkTextfield.snp.makeConstraints { (snp) in
            snp.top.equalTo(linkLbl.snp.bottom).offset(6)
            snp.leading.equalTo(view).offset(20)
            snp.trailing.equalTo(view).offset(-20)
            snp.height.equalTo(54)
        }
    }
    func confirmButton(){
        confirmBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height / 2
        confirmBtn.neumorphicLayer?.elementColor = UIColor.appColor(.bgColor).cgColor
        confirmBtn.setTitle("수정 완료", for: .normal)
        confirmBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        
        confirmBtn.snp.makeConstraints { (snp) in
            snp.bottom.equalTo(view).offset(-94)
            snp.leading.equalTo(view).offset(20)
            snp.trailing.equalTo(view).offset(-20)
            snp.height.equalTo(54)
        }
    }
    func navigationBar(){
        designLabel.text = "링크 수정"
        designLabel.textAlignment = .center
        designLabel.textColor = UIColor.appColor(.naviTitle)
        designLabel.font = UIFont(name:"AppleSDGothicNeo-Medium",size:16)
        designLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonSet.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonSet.layer.cornerRadius = 5
        buttonSet.setImage(UIImage(named: "chevronLeft"), for: .normal)
        buttonSet.setImage(UIImage(named: "chevronLeft"), for: .selected)
        buttonSet.contentVerticalAlignment = .fill
        buttonSet.contentHorizontalAlignment = .fill
        buttonSet.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
        
        buttonSet.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonSet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonSet.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            designLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            designLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58)
        ])
    }
    @objc func barbutton(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}
