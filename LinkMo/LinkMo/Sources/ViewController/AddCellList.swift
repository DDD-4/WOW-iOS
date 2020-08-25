
//  AddCellList.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/22.
//  Copyright © 2020 김보민. All rights reserved.
//


/*
 수정할거
 - pickerview 랑 textfield 중복문제
 - pickerview toolbar
 - 섹션선택 안되면 버튼 비활성화
 
 */
import UIKit
import RxSwift
import RxCocoa

class AddCellList: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
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
        //toolBar()
        rxButton()
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
                self?.tableShardVM.subject.accept(self!.tableShardVM.sections)
                
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    func toolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let button = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(selectToolbar))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        firstField.inputAccessoryView = toolbar
    }
    @objc func selectToolbar(){
        
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
