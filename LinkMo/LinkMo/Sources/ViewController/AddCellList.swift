
//  AddCellList.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/22.
//  Copyright © 2020 김보민. All rights reserved.
//


/*
 수정할거
 
 - url 한글 안들어가게
 - 피커뷰 선택시 마지막섹션선택되는 버그
 */
import UIKit
import RxSwift
import RxCocoa

class AddCellList: UIViewController {
    
    //@IBOutlet weak var pickerView: UIPickerView!
    let pickerView = UIPickerView()
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    let tableShardVM = TableViewModel.shard
    
    
    let secondFd = BehaviorRelay<String>(value: "")
    let thirdFd = BehaviorRelay<String>(value: "")
    
    lazy var didselectNumber = 0
    lazy var selectSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        firstField.inputView = pickerView
        
        toolbar()
        
        tableShardVM.sectionsList(sectionid: selectSection)
        rxButton()
        
        firstField.rx.text.orEmpty
            .subscribe(onNext: { b in
                if b == ""{
                    self.confirmBtn.isHidden = true
                }else{
                    self.confirmBtn.isHidden = false
                }
            })
            .disposed(by: bag)
    }
    
    func toolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 50))
        toolbar.barStyle = .black
        toolbar.isTranslucent = true
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dones))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let spaceText = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width / 4, height: 50))
        spaceText.font = .systemFont(ofSize: 14)
        spaceText.text = "섹션 선택하세영"
        let labelButton = UIBarButtonItem(customView: spaceText)
        toolbar.setItems([cancel, spaceButton, labelButton, spaceButton, done], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        
        firstField.inputAccessoryView = toolbar
    }
    
    @objc func dones(){
        firstField.resignFirstResponder()
        print("Done")
        
    }
    
    @objc func cancel(){
        firstField.resignFirstResponder()
        
    }
    func rxButton(){
        
        secondField.placeholder = "링크입력"
        secondField.rx.text
            .orEmpty
            .bind(to: secondFd)
            .disposed(by: bag)
        
        thirdField.placeholder = "제목"
        
        thirdField.keyboardType = .URL
        thirdField.rx.text
            .orEmpty
            .bind(to: thirdFd)
            .disposed(by: bag)
        confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height / 2
        confirmBtn.setTitleColor(.blue, for: .normal)
        confirmBtn.backgroundColor = .lightGray
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] b in
                
//                _ = self?.tableShardVM.addCell(sectionNumber: self!.didselectNumber, linkTitle: self!.secondFd.value, linkUrl: self!.thirdFd.value)
                _ = self?.tableShardVM.addCells(categoryid: self!.selectSection, sectionNumber: self!.didselectNumber, linkTitle: self!.secondFd.value, linkUrl: self!.thirdFd.value)
                self!.tableShardVM.subject.accept(self!.tableShardVM.sections)
                //self?.tableShardVM.readSections()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
}

extension AddCellList: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tableShardVM.ListSection.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tableShardVM.ListSection[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        firstField.text = tableShardVM.ListSection[row]
        
        didselectNumber = row
    }
}
