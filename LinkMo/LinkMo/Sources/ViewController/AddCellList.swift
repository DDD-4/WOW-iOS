
//  AddCellList.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/22.
//  Copyright © 2020 김보민. All rights reserved.
//


/*
 수정할거
 
 keyboard 가리는 현상
 */
import UIKit
import RxSwift
import RxCocoa

class AddCellList: UIViewController {
    
    //@IBOutlet weak var pickerView: UIPickerView!
    let pickerView = UIPickerView()
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryUrl: UITextField!
    @IBOutlet weak var categoryTitle: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var scrollonView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let tableShardVM = TableViewModel.shard
    
    let titleFd = BehaviorRelay<String>(value: "")
    let urlFd = BehaviorRelay<String>(value: "")
    
    lazy var didselectNumber = 0
    lazy var selectSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appColor(.bgColor)
        scrollonView.backgroundColor = UIColor.appColor(.bgColor)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryName.delegate = self
        categoryUrl.delegate = self
        categoryTitle.delegate = self
        
        categoryName.inputView = pickerView
        
        tableShardVM.sectionsList(sectionid: selectSection)
        rxButton()
        toolbar()
        
        categoryName.rx.text.orEmpty
            .subscribe(onNext: { b in
                if b == ""{
                    self.confirmBtn.isEnabled = false
                    self.confirmBtn.setTitleColor(UIColor.appColor(.bgColor), for: .normal)
                }else{
                    self.confirmBtn.isEnabled = true
                    self.confirmBtn.setTitleColor(.blue, for: .normal)
                }
            })
            .disposed(by: bag)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func endEditing(){
        categoryUrl.resignFirstResponder()
        categoryTitle.resignFirstResponder()
        categoryName.resignFirstResponder()
        
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
        
        
        categoryName.inputAccessoryView = toolbar
    }
    
    @objc func dones(){
        categoryName.resignFirstResponder()
        print("Done")
        
    }
    
    @objc func cancel(){
        categoryName.resignFirstResponder()
        
    }
    func rxButton(){
        
        categoryUrl.keyboardType = .URL
        categoryUrl.placeholder = "링크입력"
        categoryUrl.rx.text
            .orEmpty
            .bind(to: urlFd)
            .disposed(by: bag)
        
        categoryTitle.placeholder = "제목"
        categoryTitle.rx.text
            .orEmpty
            .bind(to: titleFd)
            .disposed(by: bag)
        
        confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height / 2
        confirmBtn.setTitleColor(.blue, for: .normal)
        confirmBtn.backgroundColor = .lightGray
        confirmBtn.rx.tap
            .subscribe(onNext: { b in
                var urlHttps = self.urlFd.value
                
                defer{
                    _ = self.tableShardVM.addCells(categoryid: self.selectSection, sectionNumber: self.didselectNumber, linkTitle: self.titleFd.value, linkUrl: urlHttps)
                    self.tableShardVM.subject.accept(self.tableShardVM.sections)
                    
                    self.navigationController?.popViewController(animated: true)
                }
                if self.urlFd.value.contains("https://"){
                    return
                }else{
                    urlHttps = "https://\(urlHttps)"
                }
                
            })
            .disposed(by: bag)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("first", view.frame.origin.y)
            
            if self.view.frame.origin.y == 64 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillhide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 64
            print("third",view.frame.origin.y)
        }

    }
}

extension AddCellList: UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        categoryName.text = tableShardVM.ListSection[row]
        
        didselectNumber = row
    }
}
