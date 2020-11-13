
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
    private var pullControl = UIRefreshControl()
    let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    //floating btn
    var bools = false
    
    //autolayout
    var cellConstraint: Constraint? = nil
    var sectionConstraint: Constraint? = nil
    var navigationTitle = ""
    
    var tableView = UITableView(frame: .zero, style: .plain)
    
    //  addBtn, label
    let addBtn = UIButton(type: .custom)
    let addSectionBtn = UIButton(type: .custom)
    let addCellBtn = UIButton(type: .custom)
    let sectionLbl = UILabel()
    let cellLbl = UILabel()
	let buttonSet = UIButton(type: .custom)
	let designLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
    let hiddenBackBtn = UIButton(type: .system)
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    
    let tableShardVM = TableViewModel.shard
    
    var dataSource: RxTableViewSectionedReloadDataSource<TableSection>!
    lazy var categoryID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(buttonSet)
        view.addSubview(designLabel)
        view.addSubview(hiddenBackBtn)
        view.addSubview(addSectionBtn)
        view.addSubview(addCellBtn)
        view.addSubview(addBtn)
        view.addSubview(sectionLbl)
        view.addSubview(cellLbl)
        
        view.backgroundColor = .black
        
        //TableView 세팅
        tableView.register(SecondCell.self, forCellReuseIdentifier: "second")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = true
        tableView.separatorStyle = .none
    
        
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
        hiddenBtn()
        navigationBar()
        
        pullControl.attributedTitle = NSAttributedString(string: "새로고침")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
    }
    func navigationBar(){
        designLabel.text = navigationTitle
        designLabel.textAlignment = .center
        designLabel.textColor = UIColor.appColor(.titleGray)
        designLabel.font = UIFont(name:"AppleSDGothicNeo-Medium", size:16)
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
    @objc private func refreshListData(_ sender: Any) {
        self.pullControl.endRefreshing()
        _ = tableShardVM.readSections(categoryId: categoryID)
    }
	@objc func barbutton(_ sender: Any){
	        self.navigationController?.popViewController(animated: true)
		}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뉴모피즘 색
        view.backgroundColor = UIColor.appColor(.bgColor)
        tableView.backgroundColor = UIColor.appColor(.bgColor)
        navigationItem.title = navigationTitle
        navigationController?.isNavigationBarHidden = true
    }
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}
	
    // MARK: - 데이터 isEmpty 상태
    func dataNil(state: Bool){
        emptyLabel.text = "+ 버튼을 눌러 \n 카테고리를 만들어보세요!"
        emptyLabel.font = UIFont.systemFont(ofSize: 26)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .lightGray
        
        emptyLabel.snp.makeConstraints { snp in
            snp.centerX.equalTo(view)
            snp.centerY.equalTo(view).offset(-80)
            snp.height.equalTo(80)
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
    // MARK: - Hidden Button
    func hiddenBtn(){
        hiddenBackBtn.isHidden = true
        hiddenBackBtn.backgroundColor = UIColor.black
        hiddenBackBtn.alpha = 0.4
        hiddenBackBtn.frame = CGRect(x: .zero, y: .zero, width: view.frame.size.width, height: view.frame.size.height)
        hiddenBackBtn.rx.tap
            .subscribe(onNext: { _ in
                self.adds()
            })
        .disposed(by: bag)
        hiddenBackBtn.snp.makeConstraints { snp in
            snp.bottom.equalTo(view)
            snp.trailing.equalTo(view)
            snp.width.equalTo(view)
            snp.height.equalTo(view)
        }
        tableShardVM.subject.accept(tableShardVM.sections)
    }
    // MARK: - FloatingButton
    func floatingBtn(){
        //플로팅버튼
        addBtn.frame = CGRect(x: 0, y: 0, width: 62, height: 62)
        addBtn.setImage(UIImage(named: "ic_plus"), for: .normal)
        addBtn.layer.cornerRadius = addBtn.frame.size.width / 2
        addBtn.backgroundColor = UIColor.appColor(.pureBlue)
        
        addBtn.layer.shadowColor = UIColor(red: 159/255, green: 155/255, blue: 217/255, alpha: 0.75).cgColor
        addBtn.layer.shadowOpacity = 0.75
        addBtn.layer.shadowOffset = CGSize(width: 0, height: 10)
        addBtn.layer.shadowRadius = 5
        addBtn.layer.masksToBounds = false
        
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
                self.hiddenBackBtn.isHidden = false
                self.addCellBtn.snp.updateConstraints { snp in
                    self.cellConstraint = snp.bottom.equalTo(self.addBtn).offset(-80).constraint
                    self.addBtn.transform = CGAffineTransform(rotationAngle: .pi/4)
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
                self.hiddenBackBtn.isHidden = true
                self.addCellBtn.snp.updateConstraints { snp in
                    self.cellConstraint = snp.bottom.equalTo(self.addBtn).offset(-10).constraint
                    self.addBtn.transform = CGAffineTransform(rotationAngle: .pi * 2)
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
        addSectionBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        addSectionBtn.setImage(UIImage(named: "ic_folder"), for: .normal)
        addSectionBtn.layer.cornerRadius = addSectionBtn.frame.size.height / 2
        addSectionBtn.backgroundColor = UIColor.appColor(.pureBlue)
        // bottom -200
        addSectionBtn.snp.makeConstraints {  snp in
            sectionConstraint = snp.bottom.equalTo(addBtn).offset(-10).constraint
            snp.centerX.equalTo(addBtn)
            snp.width.equalTo(44)
            snp.height.equalTo(44)
        }
        addSectionBtn.rx.tap
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "카테고리 입력", message: nil, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "ok", style: .default) { _ in
                    let addText = alert.textFields?[0].text
                    if self.tableShardVM.limitSection.value{
                        let alert = UIAlertController(title: nil, message: "카테고리는 최대 20개까지 가능합니다", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                    }else{
                        _ = self.tableShardVM.addSections(categoryId: self.categoryID, header: addText!)
                        _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                    }

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
        addCellBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        addCellBtn.setImage(UIImage(named: "ic_link"), for: .normal)
        addCellBtn.layer.cornerRadius = addCellBtn.frame.size.height / 2
        addCellBtn.backgroundColor = UIColor.appColor(.pureBlue)
        
        
        // bottom -110
        addCellBtn.snp.makeConstraints {  snp in
            cellConstraint = snp.bottom.equalTo(addBtn).offset(-10).constraint
            snp.centerX.equalTo(addBtn)
            snp.width.equalTo(44)
            snp.height.equalTo(44)
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
        
        sectionLbl.layer.shadowColor = UIColor(red: 49/255, green: 60/255, blue: 86/255, alpha: 0.5).cgColor
        sectionLbl.layer.shadowOpacity = 0.5
        sectionLbl.layer.shadowOffset = CGSize(width: 5, height: 10)
        sectionLbl.layer.shadowRadius = 5
        sectionLbl.layer.masksToBounds = false
        
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
        
        cellLbl.layer.shadowColor = UIColor(red: 49/255, green: 60/255, blue: 86/255, alpha: 0.5).cgColor
        cellLbl.layer.shadowOpacity = 0.5
        cellLbl.layer.shadowOffset = CGSize(width: 5, height: 10)
        cellLbl.layer.shadowRadius = 5
        cellLbl.layer.masksToBounds = false
        
        
        cellLbl.snp.makeConstraints { (snp) in
            snp.trailing.equalTo(addCellBtn.snp.leading).offset(-10)
            snp.centerY.equalTo(addCellBtn)
            snp.width.greaterThanOrEqualTo(75)
            snp.height.equalTo(30)
        }
    }
    // MARK: - 테이블뷰 세팅 관련
    func tableSetting(){
        let configureCells: (TableViewSectionedDataSource<TableSection>, UITableView, IndexPath, String) -> UITableViewCell = { (dataSource, tableView, indexPath, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as? SecondCell else { return UITableViewCell() }
            cell.data = (indexPath.section, indexPath.row)
            
            if dataSource.sectionModels[indexPath.section].expanded == false{
                cell.isHidden = true
            }
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.appColor(.bgColor)
            
            let urlstring = "\(dataSource.sectionModels[indexPath.section].linked[indexPath.row])"
            let encoding = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encoding)!
            
            
            //  PreView, 썸네일이미지
            let titleCount = dataSource.sectionModels[indexPath.section].titled.count
            let imageCount = dataSource.sectionModels[indexPath.section].thumbnail.count
            print("title", titleCount)
            print("image", imageCount)
            
            if titleCount != imageCount{
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
            }else{
                cell.linkImage.image = UIImage(data: dataSource.sectionModels[indexPath.section].thumbnail[indexPath.row])
            }
            cell.linkTitle.text = element
            cell.linkUrl.text = "\(dataSource.sectionModels[indexPath.section].linked[indexPath.row])"
            
            
            
            //MARK: - Cell 수정 삭제
            cell.updateBtn.rx.tap
                .subscribe(onNext: { b in
                    
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                    let update = UIAlertAction(title: "수정", style: .default) { _ in
//                       
                        let vc = LinkTitleUpdateVC()
                        vc.sectionValue = cell.data.0
                        vc.rowValue = cell.data.1
                        vc.categoryid = self.categoryID
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    let remove = UIAlertAction(title: "삭제", style: .default) { _ in
                        _ = self.tableShardVM.removeCells(categoryid: self.categoryID, section: cell.data.0, cellrow: cell.data.1)
                        //                            _ = self.tableShardVM.removeCells(categoryid: self.categoryID, section: indexPath.section, cellrow: indexPath.row)
                        
                        _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                        
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
            
        }
        let dataSource = RxTableViewSectionedReloadDataSource<TableSection>.init(configureCell: configureCells)
        
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
			snp.top.equalTo(view).offset(110)
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
        titleLbl.font = .systemFont(ofSize: 18)
        
        let numberLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        numberLbl.text = "\(dataSource.sectionModels[section].linked.count)개"
        numberLbl.textAlignment = .right
        numberLbl.font = .systemFont(ofSize: 15)
        numberLbl.textColor = UIColor.appColor(.numberColor)
        
        let sectionUpdateBtn = UIButton(type: .custom)
        sectionUpdateBtn.setImage(UIImage(named: "ic_delete copy"), for: .normal)
        sectionUpdateBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        //MARK: - section 선택, expandable
        let expandable = UIButton(frame: CGRect(x: -5, y: -15, width: header.frame.size.width + 5, height: header.frame.size.height))
        expandable.setImage(UIImage(named: "table_back"), for: .normal)
        
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
        header.layer.cornerRadius = 20
        
        //MARK: - Section, 수정 삭제
        sectionUpdateBtn.rx.tap
            .subscribe(onNext: { _ in
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let update = UIAlertAction(title: "수정", style: .default) { _ in
                    let alert = UIAlertController(title: nil, message: "카테고리 수정", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Done", style: .default) { _ in
                        let updateText = alert.textFields?[0].text
                        if updateText != ""{
                            
                            _ = self.tableShardVM.updateSections(updateText: updateText!, index: section, categoryId: self.categoryID)
                            _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                        }

                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in}
                    alert.addTextField { textF in
                        textF.placeholder = self.dataSource.sectionModels[section].header
                    }
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true)
                    
                }
                let remove = UIAlertAction(title: "제거", style: .default) { _ in
                    let alertConfirm = UIAlertController(title: nil, message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        //cell delete
                        _ = self.tableShardVM.deleteSections(section: section, categoryId: self.categoryID)
                        _ = self.tableShardVM.readSections(categoryId: self.categoryID)
                        
                    }
                    alertConfirm.addAction(cancel)
                    alertConfirm.addAction(ok)
                    
                    self.present(alertConfirm, animated: true)
                    
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


class SecondCell: UITableViewCell{
    
    let linkImage = UIImageView()
    let linkTitle = UILabel()
    let linkUrl = UILabel()
    let updateBtn = UIButton(type: .custom)
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
        updateBtn.setImage(UIImage(named: "ic_delete copy"), for: .normal)
        
        updateBtn.snp.makeConstraints { snp in
            snp.top.equalTo(contentView).offset(20)
            snp.trailing.equalTo(contentView).offset(-20)
            snp.bottom.equalTo(contentView).offset(-20)
            snp.width.equalTo(24)
        }
        
    }
//    override func prepareForReuse() {
//        linkTitle.attributedText = nil
//        linkUrl.attributedText = nil
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
