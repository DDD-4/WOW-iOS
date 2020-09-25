
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

/*
 수정할거
 
 - coredata 삭제 후 빈데이터 상태일 때 섹션 추가하면 안바뀜
 
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
        
        
//        tableShardVM.deleteAllRecords()
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(addSectionBtn)
        view.addSubview(addCellBtn)
        view.addSubview(addBtn)
        view.addSubview(sectionLbl)
        view.addSubview(cellLbl)
        
        tableShardVM.subject.accept(tableShardVM.sections)
        tableState()

        
        //TableView 세팅
        tableView.register(SecondCell.self, forCellReuseIdentifier: "second")
        tableView.separatorStyle = .none
        tableSetting()
        tableView.rx.setDelegate(self)
        .disposed(by: bag)
        
        
        // AddBtn
        floatingBtn()
        AddSectionPush()
        AddCellPush()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - Floating buttons animation
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
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as! SecondCell
                
                cell.selectionStyle = .none
                cell.linkTitle.text = item
                cell.linkUrl.text = "\(dataSource.sectionModels[indexPath.section].link[indexPath.row])"
                
                let urlstring = "\(dataSource.sectionModels[indexPath.section].link[indexPath.row])"
                let encoding = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: encoding)!
                
                LPMetadataProvider().startFetchingMetadata(for: url) { (linkMetadata, error) in
                    guard let linkMetadata = linkMetadata,
                        let imageProvider = linkMetadata.imageProvider else {
                        return DispatchQueue.main.async {
                                cell.linkImage.image = UIImage(named: "12")
                            }
                    }

                    imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        guard error == nil else {
                            
                            return
                        }

                        if let image = image as? UIImage {
                            // do something with image
                            DispatchQueue.main.async {
                                cell.linkImage.image = image
                            }
                        } else {
                            print("no image available")
                        }
                    }
                }
                
                //MARK: - Cell 수정 삭제
                cell.updateBtn.rx.tap
                    .subscribe(onNext: { b in
                        
                        let alert = UIAlertController(title: nil, message: "수정 삭제", preferredStyle: .actionSheet)
                        
                        let update = UIAlertAction(title: "수정", style: .default) { _ in
                            let alert = UIAlertController(title: nil, message: "셀 수정", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                                let updateTitle = alert.textFields![0].text
                                let updatelink = alert.textFields![1].text
                                
                                _ = self.tableShardVM.updateCells(categoryid: self.categoryID, section: indexPath.section, cellrow: indexPath.row, title: updateTitle!, link: updatelink!)
                                _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                            }
                            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                            
                            alert.addTextField { textField in
                                textField.placeholder = "타이틀"
                            }
                            alert.addTextField { textField in
                                textField.placeholder = "링크"
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
                                _ = self.tableShardVM.removeCells(categoryid: self.categoryID, section: indexPath.section, cellrow: indexPath.row)
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
        
        tableShardVM.subject.accept(tableShardVM.sections)
        
        tableView.rx.itemSelected.subscribe(onNext: { index in
            print(self.tableShardVM.sections[index.section].items[index.row])
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(sections[indexPath.section].items[indexPath.row])
//
//        guard let url = URL(string: "http://www.naver.com"),
//            UIApplication.shared.canOpenURL(url) else { return }
//         UIApplication.shared.open(url, options: [:], completionHandler: nil)
//
//    }
    //MARK: - height row and header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - viewforHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLbl.text = dataSource.sectionModels[section].headers
        
        let sectionUpdateBtn = UIButton(type: .system)
        sectionUpdateBtn.setImage(UIImage(named: "36"), for: .normal)
        sectionUpdateBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        //MARK: - sectionShow
        let expandable = UIButton(frame: CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.size.height))
        expandable.rx.tap
            .subscribe(onNext: { _ in
                print(section)
            })
            .disposed(by: bag)
        
        header.addSubview(expandable)
        header.addSubview(titleLbl)
        header.addSubview(sectionUpdateBtn)
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
        
        titleLbl.snp.makeConstraints { snp in
            snp.centerY.equalTo(header)
            snp.leading.equalTo(header).offset(20)
        }
        sectionUpdateBtn.snp.makeConstraints { snp in
            snp.trailing.equalTo(header).offset(-20)
            snp.centerY.equalTo(header)
        }
        header.backgroundColor = .lightGray
        return header
    }
    
}


class SecondCell: UITableViewCell{
    
    let linkImage = UIImageView()
    let linkTitle = UILabel()
    let linkUrl = UILabel()
    let updateBtn = UIButton(type: .system)
    
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
