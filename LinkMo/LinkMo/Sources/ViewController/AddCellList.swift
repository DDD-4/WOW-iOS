
//  AddCellList.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/22.
//  Copyright © 2020 김보민. All rights reserved.
//


/*
 수정할거
 confirm버튼 뉴모피즘
 */
import UIKit
import RxSwift
import RxCocoa
import LinkPresentation
import EMTNeumorphicView

class AddCellList: UIViewController {
    
    //@IBOutlet weak var pickerView: UIPickerView!
    let pickerView = UIPickerView()
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryUrl: UITextField!
    @IBOutlet weak var categoryTitle: UITextField!
    @IBOutlet weak var confirmBtn: EMTNeumorphicButton!
    @IBOutlet weak var scrollonView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var copyUrlLbl: UILabel!
    
    let tableShardVM = TableViewModel.shard
    
    let titleFd = BehaviorRelay<String>(value: "")
    let urlFd = BehaviorRelay<String>(value: "")
    
    let buttonBack = UIButton(type: .custom)
    
    lazy var didselectNumber = 0
    lazy var selectSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(buttonBack)
        navigationBar()
        
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
        copyURLText()
        
        
        categoryName.rx.text.orEmpty
            .bind(to: tableShardVM.listlocateS)
            .disposed(by: bag)
        
        tableShardVM.listlocateS
            .map(tableShardVM.checklocate(_:))
            .bind(to: tableShardVM.listlocateBool)
            .disposed(by: bag)
        
        categoryUrl.rx.text.orEmpty
            .bind(to: tableShardVM.urlValidS)
            .disposed(by: bag)
        
        tableShardVM.urlValidS
            .map(tableShardVM.checkURL(_:))
            .bind(to: tableShardVM.urlVBool)
            .disposed(by: bag)
        
        categoryTitle.rx.text.orEmpty
            .bind(to: tableShardVM.titleValidS)
            .disposed(by: bag)
        
        tableShardVM.titleValidS
            .map(tableShardVM.checkTitle(_:))
            .bind(to: tableShardVM.titleVBool)
            .disposed(by: bag)
        
        Observable.combineLatest(tableShardVM.listlocateBool, tableShardVM.urlVBool, tableShardVM.titleVBool, resultSelector: {$0 && $1 && $2})
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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func barbutton(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    func copyURLText(){
        copyUrlLbl.translatesAutoresizingMaskIntoConstraints = false
        copyUrlLbl.text = "링크를 보관할 카테고리를 선택 후\n복사한 URL을 붙여넣어주세요."
        copyUrlLbl.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        copyUrlLbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }
    func navigationBar(){
        
        buttonBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonBack.layer.cornerRadius = 5
        buttonBack.setImage(UIImage(named: "chevronLeft"), for: .normal)
        buttonBack.setImage(UIImage(named: "chevronLeft"), for: .selected)
        buttonBack.contentVerticalAlignment = .fill
        buttonBack.contentHorizontalAlignment = .fill
        buttonBack.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        ])
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
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 60, right: 0)
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
        spaceText.text = "카테고리를 선택하세요."
        let labelButton = UIBarButtonItem(customView: spaceText)
        toolbar.setItems([cancel, spaceButton, labelButton, spaceButton, done], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        
        categoryName.inputAccessoryView = toolbar
    }
    
    @objc func dones(){
        categoryName.resignFirstResponder()
    }
    
    @objc func cancel(){
        categoryName.resignFirstResponder()
        
    }
    func rxButton(){
        categoryName.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        categoryName.textColor = UIColor.appColor(.title136)
        
        categoryUrl.keyboardType = .URL
        categoryUrl.placeholder = "링크 주소를 붙여넣기"
//        categoryUrl.attributedPlaceholder = NSAttributedString(string: "링크 주소를 붙여넣기", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appColor(.titleGray)])
        categoryUrl.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        categoryUrl.textColor = UIColor.appColor(.title136)
        categoryUrl.rx.text
            .orEmpty
            .bind(to: urlFd)
            .disposed(by: bag)
        
        categoryTitle.placeholder = "링크 제목"
        categoryTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        categoryTitle.textColor = UIColor.appColor(.title136)
        categoryTitle.rx.text
            .orEmpty
            .bind(to: titleFd)
            .disposed(by: bag)
        

        confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height / 2
        confirmBtn.neumorphicLayer?.elementBackgroundColor = UIColor.appColor(.bgColor).cgColor
        confirmBtn.setTitle("저장하기", for: .normal)
        confirmBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { b in
                
                var urlHttps = self.urlFd.value
                
                self.tableShardVM.checkLimit(categoryid: self.selectSection, sectionNumber: self.didselectNumber)
                
                if self.tableShardVM.limitCell.value{
                    let alert = UIAlertController(title: nil, message: "한 카테고리의 링크는 최대 500개입니다", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }else{
                    defer{
                        _ = self.tableShardVM.addCells(categoryid: self.selectSection, sectionNumber: self.didselectNumber, linkTitle: self.titleFd.value, linkUrl: urlHttps)
                        let urlstring = urlHttps
                        let encoding = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        let url = URL(string: encoding)!
                        
                        LPMetadataProvider().startFetchingMetadata(for: url) { (linkMetadata, error) in
                            guard let linkMetadata = linkMetadata,
                                let imageProvider = linkMetadata.imageProvider else {
                                    return DispatchQueue.main.async {
                                        let images = UIImage(named: "12")
                                        let convert = images?.pngData()
                                        
                                        _ = self.tableShardVM.addPng(categoryid: self.selectSection, sectionNumber: self.didselectNumber, png: convert!)
                                        self.navigationController?.popViewController(animated: true)
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
                                        
                                        _ = self.tableShardVM.addPng(categoryid: self.selectSection, sectionNumber: self.didselectNumber, png: convert!)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                } else {
                                    print("no image available")
                                }
                            }
                        }
                        
                        self.tableShardVM.subject.accept(self.tableShardVM.sections)
                        
                        
                    }
                    if self.urlFd.value.contains("https://") || self.urlFd.value.contains("http://"){
                        return
                    }else{
                        urlHttps = "https://\(urlHttps)/"
                    }
                }
                
            })
            .disposed(by: bag)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 64 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillhide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 64
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
