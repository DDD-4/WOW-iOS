
//  AddCellList.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/22.
//  Copyright © 2020 김보민. All rights reserved.
//


/*
 수정할거
 
 - 섹션선택 안되면 버튼 비활성화
 
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        firstField.inputView = pickerView
        
        toolbar()
        tableShardVM.ListSection.removeAll()
        tableShardVM.sectionList()
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
        
        firstField.inputView = pickerView
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
        
        secondField.placeholder = "제목"
        secondField.rx.text
            .orEmpty
            .bind(to: secondFd)
            .disposed(by: bag)
        
        thirdField.placeholder = "링크"
        
        thirdField.textContentType = .URL
        thirdField.rx.text
            .orEmpty
            .bind(to: thirdFd)
            .disposed(by: bag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] b in
                
                //                var sectionCount = self?.tableShardVM.sections[self!.didselectNumber]
                //
                //                sectionCount?.items.append(self!.secondFd.value)
                //                sectionCount?.link.append(self!.thirdFd.value)
                
                _ = self?.tableShardVM.addCell(sectionNumber: self!.didselectNumber, linkTitle: self!.secondFd.value, linkUrl: self!.thirdFd.value)
                
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
