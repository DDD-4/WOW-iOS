
//  SecondTableVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/14.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import LinkPresentation
import EMTNeumorphicView
/*
 수정할거
 
 */
class SecondTableVC: UIViewController {

    //MARK: - TableView isEmpty didSet
    var state: tableShow = .hide{
        didSet{
            switch state {
            case .hide:
                tableView.isHidden = true
                dataNil(state: false)
                
                
            case .show:
                tableView.isHidden = false
                dataNil(state: true)
                
                
            }
        }
    }
    
    
    let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    //floating btn
    var bools = false
    
    //autolayout
    var cellConstraint: Constraint? = nil
    var sectionConstraint: Constraint? = nil
    
    
    var tableView = UITableView()
    
    //  addBtn, label
    let addBtn = UIButton(type: .system)
    let addSectionBtn = UIButton(type: .system)
    let addCellBtn = UIButton(type: .system)
    let sectionLbl = UILabel()
    let cellLbl = UILabel()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    
    let tableShardVM = TableViewModel.shard
    
    var dataSource: RxTableViewSectionedReloadDataSource<TableSection>!
    lazy var categoryID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(addSectionBtn)
        view.addSubview(addCellBtn)
        view.addSubview(addBtn)
        view.addSubview(sectionLbl)
        view.addSubview(cellLbl)
        view.backgroundColor = .black
        
        tableShardVM.subject.accept(tableShardVM.sections)

        
        //TableView 세팅
        tableView.register(SecondCell.self, forCellReuseIdentifier: "second")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceHorizontal = false
        
        tableState()
        tableSetting()
        tableView.rx.setDelegate(self)
        .disposed(by: bag)
        
        // AddBtn
        floatingBtn()
        AddSectionPush()
        AddCellPush()
        sectionLabel()
        cellLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뉴모피즘 색
        view.backgroundColor = UIColor.appColor(.bgColor)
        tableView.backgroundColor = UIColor.appColor(.bgColor)
        
        // 버튼으로 만들기
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapandhide(_:)))
//        tableView.addGestureRecognizer(tapGesture)
//        tableView.isUserInteractionEnabled = true
        
        
        
    }
    // MARK: - 데이터 isEmpty 상태
    func dataNil(state: Bool){
        emptyLabel.text = "데이터 추가바람"
        emptyLabel.font = UIFont.systemFont(ofSize: 20)
        emptyLabel.textAlignment = .center
        emptyLabel.backgroundColor = .orange
        
        emptyLabel.snp.makeConstraints { snp in
            snp.topMargin.equalTo(view).offset(20)
            snp.leading.equalTo(view).offset(20)
            snp.trailing.equalTo(view).offset(-20)
            snp.height.equalTo(30)
        }
        
        emptyLabel.isHidden = state
        addCellBtn.isEnabled = state
    }

    func tableState(){
        tableShardVM.readSections(categoryId: categoryID).subscribe(onNext: { b in
            if b.count == 0{
                self.state = .hide
            }else{
                self.state = .show
            }
        })
        .disposed(by: bag)
    }
    // MARK: - FloatingButton
    func floatingBtn(){
        //플로팅버튼
        addBtn.frame = CGRect(x: 0, y: 0, width: 62, height: 62)
        addBtn.setTitle("Add", for: .normal)
        addBtn.layer.cornerRadius = addBtn.frame.size.width / 2
        addBtn.backgroundColor = .blue
        
        addBtn.snp.makeConstraints { snp in
            snp.bottom.equalTo(view).offset(-40)
            snp.trailing.equalTo(view).offset(-30)
            snp.width.equalTo(62)
            snp.height.equalTo(62)
        }
        addBtn.addTarget(self, action: #selector(adds), for: .touchUpInside)
    }
    
    // MARK: - Floating buttons 애니메이션
    @objc func adds(){
        
        let firstDuration = 0.3
        let secondDuration = 0.35
        bools = !bools
        
        if bools == true{
            
            view.layoutIfNeeded()
            UIView.animate(withDuration: firstDuration) {
                self.addCellBtn.snp.updateConstraints { snp in
                    self.cellConstraint = snp.bottom.equalTo(self.addBtn).offset(-80).constraint
                }
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: secondDuration) {
                self.addSectionBtn.snp.updateConstraints { snp in
                    self.sectionConstraint = snp.bottom.equalTo(self.addBtn).offset(-150).constraint
                }
                self.view.layoutIfNeeded()
                self.sectionLbl.self.isHidden = false
                self.cellLbl.self.isHidden = false
            }
        }else{
            view.layoutIfNeeded()
            UIView.animate(withDuration: firstDuration) {
                self.addCellBtn.snp.updateConstraints { snp in
                    self.cellConstraint = snp.bottom.equalTo(self.addBtn).offset(-10).constraint
                }
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: secondDuration) {
                self.addSectionBtn.snp.updateConstraints { snp in
                    self.sectionConstraint = snp.bottom.equalTo(self.addBtn).offset(-10).constraint
                }
                self.view.layoutIfNeeded()
                self.sectionLbl.self.isHidden = true
                self.cellLbl.self.isHidden = true
            }
        }
    }
    // tap으로 플로팅 버튼비활성화
    @objc func tapandhide(_ sender: UITapGestureRecognizer){
        if bools{
            bools = false
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.addCellBtn.snp.updateConstraints { snp in
                    self.cellConstraint = snp.bottom.equalTo(self.addBtn).offset(-10).constraint
                }
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.35) {
                self.addSectionBtn.snp.updateConstraints { snp in
                    self.sectionConstraint = snp.bottom.equalTo(self.addBtn).offset(-10).constraint
                }
                self.view.layoutIfNeeded()
                self.sectionLbl.self.isHidden = true
                self.cellLbl.self.isHidden = true
            }
        }
    }
    //MARK: - AddSection
    func AddSectionPush(){
        addSectionBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSectionBtn.setTitle("Section", for: .normal)
        addSectionBtn.layer.cornerRadius = addSectionBtn.frame.size.height / 2
        addSectionBtn.backgroundColor = .orange
        // bottom -200
        addSectionBtn.snp.makeConstraints {  snp in
            sectionConstraint = snp.bottom.equalTo(addBtn).offset(-10).constraint
            snp.centerX.equalTo(addBtn)
            snp.width.equalTo(50)
            snp.height.equalTo(50)
        }
        addSectionBtn.rx.tap
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "카테고리 입력", message: nil, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "ok", style: .default) { _ in
                    let addText = alert.textFields?[0].text
                    
                    _ = self.tableShardVM.addSections(categoryId: self.categoryID, header: addText!)
                    _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                    self.tableState()
                }
                let cancel = UIAlertAction(title: "cancel", style: .destructive) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addTextField { textfield in
                    textfield.placeholder = "예시) UI/UX"
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                
                self.present(alert, animated: true)
            })
            .disposed(by: bag)
    }
    
    //MARK: - AddCell
    func AddCellPush(){
        addCellBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addCellBtn.setTitle("Cell", for: .normal)
        addCellBtn.layer.cornerRadius = addCellBtn.frame.size.height / 2
        addCellBtn.backgroundColor = .orange
        
        
        // bottom -110
        addCellBtn.snp.makeConstraints {  snp in
            cellConstraint = snp.bottom.equalTo(addBtn).offset(-10).constraint
            snp.centerX.equalTo(addBtn)
            snp.width.equalTo(50)
            snp.height.equalTo(50)
        }
        
        addCellBtn.rx.tap
            .subscribe(onNext: { _ in

                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                let addcellvc = storyBoard.instantiateViewController(withIdentifier: "AddCellList") as! AddCellList
                addcellvc.selectSection = self.categoryID
                self.navigationController?.pushViewController(addcellvc, animated: true)
                
            })
            .disposed(by: bag)
    }
    
    func sectionLabel(){
        
        sectionLbl.isHidden = true
        sectionLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        sectionLbl.font = .systemFont(ofSize: 15)
        sectionLbl.backgroundColor = .darkGray
        sectionLbl.textColor = .white
        sectionLbl.text = "카테고리 추가"
        sectionLbl.textAlignment = .center
        sectionLbl.layer.cornerRadius = 15
        
        sectionLbl.snp.makeConstraints { (snp) in
            snp.trailing.equalTo(addSectionBtn.snp.leading).offset(-10)
            snp.centerY.equalTo(addSectionBtn)
            snp.width.greaterThanOrEqualTo(100)
            snp.height.equalTo(30)
        }
    }
    
    func cellLabel(){
        
        cellLbl.isHidden = true
        cellLbl.frame = CGRect(x: 0, y: 0, width: 75, height: 30)
        cellLbl.font = .systemFont(ofSize: 15)
        cellLbl.backgroundColor = .darkGray
        cellLbl.textColor = .white
        cellLbl.text = "링크 추가"
        cellLbl.textAlignment = .center
        cellLbl.layer.cornerRadius = 15
        
        cellLbl.snp.makeConstraints { (snp) in
            snp.trailing.equalTo(addCellBtn.snp.leading).offset(-10)
            snp.centerY.equalTo(addCellBtn)
            snp.width.greaterThanOrEqualTo(75)
            snp.height.equalTo(30)
        }
    }
    // MARK: - 테이블뷰 세팅 관련
    func tableSetting(){
        
        let dataSource = RxTableViewSectionedReloadDataSource<TableSection>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                print("section: ",indexPath.section)
                print("row: ",indexPath.row)
                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as! SecondCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as! SecondCell
                var type: EMTNeumorphicLayerCornerType = .all
                
                if dataSource.sectionModels[indexPath.section].expanded == false{
                    cell.isHidden = true
                }
                
                // url값이 저장되잇다는 전제하에
                if dataSource.sectionModels[indexPath.section].linked.count > 1{
                    
                    if indexPath.row == 0{
                        type = .topRow
                    }else if indexPath.row == dataSource.sectionModels[indexPath.section].linked.count - 1{
                        type = .bottomRow
                    }else{
                        type = .middleRow
                    }
                }
                cell.neumorphicLayer?.cornerType = type
                cell.neumorphicLayer?.cornerRadius = 12
                cell.data = (indexPath.section, indexPath.row)
                cell.selectionStyle = .none
                cell.linkTitle.text = item
                cell.linkUrl.text = "\(dataSource.sectionModels[indexPath.section].linked[indexPath.row])"
                
                let urlstring = "\(dataSource.sectionModels[indexPath.section].linked[indexPath.row])"
                let encoding = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: encoding)!
                
                
//                //  PreView, 썸네일이미지
//                LPMetadataProvider().startFetchingMetadata(for: url) { (linkMetadata, error) in
//                    guard let linkMetadata = linkMetadata,
//                        let imageProvider = linkMetadata.imageProvider else {
//                        return DispatchQueue.main.async {
//                                cell.linkImage.image = UIImage(named: "12")
//                            }
//                    }
//                    imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                        guard error == nil else {
//                            return
//                        }
//                        if let image = image as? UIImage {
//                            // do something with image
//                            DispatchQueue.main.async {
//                                cell.linkImage.image = image
//                            }
//                        } else {
//                            print("no image available")
//                        }
//                    }
//                }
                
                
                //MARK: - Cell 수정 삭제
                cell.updateBtn.rx.tap
                    .subscribe(onNext: { b in
                        
                        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        let update = UIAlertAction(title: "수정", style: .default) { _ in
                            let alert = UIAlertController(title: nil, message: "링크 수정", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                                let updateTitle = alert.textFields![0].text
                                var updatelink = alert.textFields![1].text
                                
                                defer{
                                    _ = self.tableShardVM.updateCells(categoryid: self.categoryID, section: indexPath.section, cellrow: indexPath.row, title: updateTitle!, link: updatelink!)
                                    _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                                }
                                if updatelink!.contains("https://") || updatelink!.contains("http://"){
                                    return
                                }else{
                                    updatelink = "https://\(updatelink!)"
                                }
                                
                            }
                            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                            
                            alert.addTextField { textField in
                                textField.placeholder = dataSource.sectionModels[cell.data.0].titled[cell.data.1]
                            }
                            alert.addTextField { textField in
                                textField.placeholder = dataSource.sectionModels[cell.data.0].linked[cell.data.1]
                            }
                            alert.addAction(cancel)
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                            
                        }
                        let remove = UIAlertAction(title: "삭제", style: .default) { _ in
                            
                            let alertConfirm = UIAlertController(title: nil, message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                                //cell delete
                                
                                print("section = ", indexPath.section)
                                print("row =", indexPath.row)
                                print("update Tag =", indexPath.row)
                                
                                _ = self.tableShardVM.removeCells(categoryid: self.categoryID, section: cell.data.0, cellrow: cell.data.1)
                                
                                _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                            }
                            alertConfirm.addAction(cancel)
                            alertConfirm.addAction(ok)
                            
                            self.present(alertConfirm, animated: true)
                        }
                        
                        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.pruneNegativeWidthConstraints()
                        alert.addAction(update)
                        alert.addAction(remove)
                        alert.addAction(cancel)
                        self.present(alert, animated: false)
                    })
                    .disposed(by: bag)
                
                return cell
        })
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        self.dataSource = dataSource
        
        tableShardVM.subject
        .asDriver(onErrorJustReturn: tableShardVM.sections)
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { index in
            print(self.tableShardVM.sections[index.section].link[index.row])
            let urls = self.tableShardVM.sections[index.section].link[index.row]
            let urltranform = urls.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            guard let url = URL(string: urltranform),
                self.tableShardVM.canOpenURL(urltranform) else {
                    let alert = UIAlertController(title: "오류", message: "URL을 다시확인해주세여", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        .disposed(by: bag)
        
        tableView.snp.makeConstraints { snp in
            snp.top.equalTo(view)
            snp.bottom.equalTo(view)
            snp.trailing.equalTo(view)
            snp.leading.equalTo(view)
        }
    }
}

//MARK: - Table Delegate
extension SecondTableVC: UITableViewDelegate{
    
    //MARK: - height row and header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource.sectionModels[indexPath.section].expanded == false{
            return 0
        }
        return 80
    }
    
    //MARK: - viewforHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLbl.text = dataSource.sectionModels[section].headers
        titleLbl.font = .systemFont(ofSize: 22)
        
        let numberLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        numberLbl.text = "\(dataSource.sectionModels[section].linked.count)개"
        numberLbl.textAlignment = .right
        
        numberLbl.font = .systemFont(ofSize: 15)
        
        let sectionUpdateBtn = UIButton(type: .system)
        sectionUpdateBtn.setImage(UIImage(named: "36"), for: .normal)
        sectionUpdateBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        //MARK: - section 선택, expandable
        let expandable = UIButton(frame: CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.size.height))
        expandable.rx.tap
            .subscribe(onNext: { _ in
                var expandable = self.dataSource.sectionModels[section].expanded
                expandable = !expandable
                
                _ = self.tableShardVM.expandableCell(categoryId: self.categoryID,
                                                     section: section,
                                                     bools: expandable)
                _ = self.tableShardVM.readSections(categoryId: self.categoryID)
            })
            .disposed(by: bag)
        
        header.addSubview(expandable)
        header.addSubview(titleLbl)
        header.addSubview(numberLbl)
        header.addSubview(sectionUpdateBtn)
        header.backgroundColor = UIColor.appColor(.listHeaderColor)
        header.layer.cornerRadius = 20
        
//        //neumorphism code 티안남
//        header.layer.masksToBounds = false
//
//        let cornerRadius: CGFloat = 15
//        let shadowRadius: CGFloat = 4
//
//        let darkShadow = CALayer()
//        darkShadow.frame = header.bounds
//        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
//        darkShadow.cornerRadius = cornerRadius
//        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
//        darkShadow.shadowOpacity = 1
//        darkShadow.shadowRadius = shadowRadius
//        header.layer.insertSublayer(darkShadow, at: 0)
//
//        let lightShadow = CALayer()
//        lightShadow.frame = header.bounds
//        lightShadow.shadowColor = UIColor.white.cgColor
//        lightShadow.cornerRadius = cornerRadius
//        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
//        lightShadow.shadowOpacity = 1
//        lightShadow.shadowRadius = shadowRadius
//        header.layer.insertSublayer(lightShadow, at: 0)
        
        //MARK: - Section, 수정 삭제
        sectionUpdateBtn.rx.tap
            .subscribe(onNext: { _ in
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let update = UIAlertAction(title: "수정", style: .default) { _ in
                    let alert = UIAlertController(title: nil, message: "수정할 글 입력", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Done", style: .default) { _ in
                        let updateText = alert.textFields?[0].text
                        
                        _ = self.tableShardVM.updateSections(updateText: updateText!, index: section, categoryId: self.categoryID)
                        _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in}
                    alert.addTextField { textF in
                        textF.placeholder = "수정사항 입력"
                    }
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true)
                    
                }
                let remove = UIAlertAction(title: "제거", style: .default) { _ in
                    
                    _ = self.tableShardVM.deleteSections(section: section, categoryId: self.categoryID)
                    _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                    self.tableState()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(update)
                alert.addAction(remove)
                alert.addAction(cancel)
                alert.pruneNegativeWidthConstraints()
                self.present(alert, animated: true)
            })
            .disposed(by: bag)
//        titleLbl.backgroundColor = .orange
//        numberLbl.backgroundColor = .blue
        titleLbl.snp.makeConstraints { snp in
            snp.centerY.equalTo(header)
            snp.leading.equalTo(header).offset(20)
            snp.width.greaterThanOrEqualTo(30)
        }
        numberLbl.snp.makeConstraints { snp in
            snp.leading.equalTo(titleLbl.snp.trailing)
            snp.centerY.equalTo(header)
            snp.width.equalTo(50)
        }
        sectionUpdateBtn.snp.makeConstraints { snp in
            snp.trailing.equalTo(header).offset(-20)
            snp.centerY.equalTo(header)
        }
        
        return header
    }
    
}


class SecondCell: EMTNeumorphicTableCell{
    
    let linkImage = UIImageView()
    let linkTitle = UILabel()
    let linkUrl = UILabel()
    let updateBtn = UIButton(type: .system)
    var data: (Int, Int) = (0, 0)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(linkImage)
        contentView.addSubview(linkTitle)
        contentView.addSubview(linkUrl)
        contentView.addSubview(updateBtn)
        
        linkImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        linkImage.sizeToFit()
        linkImage.contentMode = .scaleAspectFill
        
        linkImage.snp.makeConstraints { snp in
            
            snp.top.equalTo(contentView).offset(10)
            snp.leading.equalTo(contentView).offset(20)
            snp.bottom.equalTo(contentView).offset(-10)
            snp.width.equalTo(55)
        }
        
        linkTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        linkTitle.font = UIFont.systemFont(ofSize: 17)
        
        linkTitle.snp.makeConstraints { snp in
            snp.leading.equalTo(linkImage.snp.trailing).offset(20)
            snp.top.equalTo(linkImage.snp.top).offset(10)
            snp.trailing.equalTo(updateBtn).offset(-30)
        }
        
        linkUrl.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        linkUrl.textColor = UIColor.darkGray
        linkUrl.font = UIFont.systemFont(ofSize: 14)
        
        linkUrl.snp.makeConstraints { snp in
            
            snp.bottom.equalTo(linkImage.snp.bottom).offset(-10)
            snp.leading.equalTo(linkImage.snp.trailing).offset(20)
            snp.trailing.equalTo(updateBtn).offset(-30)
        }
        
        
        updateBtn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        updateBtn.setImage(UIImage(named: "24"), for: .normal)
        
        updateBtn.snp.makeConstraints { snp in
            snp.top.equalTo(contentView).offset(20)
            snp.trailing.equalTo(contentView).offset(-10)
            snp.bottom.equalTo(contentView).offset(-20)
            snp.width.equalTo(24)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
