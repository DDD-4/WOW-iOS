//
//  ViewController.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import EMTNeumorphicView

class HomeViewController: UIViewController {
    
    var state: CategoryShow = .hide{
        didSet{
            switch state {
            case .hide:
                collectionView.isHidden = true
                dataNil(state: false)
            
            case .show:
                collectionView.isHidden = false
                dataNil(state: true)
            }
        }
    }
    
	let viewModel = HomeViewModel()
	let tableViewModel = TableViewModel()
	let disposeBag = DisposeBag()
	let tableshared = TableViewModel.shard
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkname: UILabel!
    let AddBtn = UIButton(type: .custom)
	let numberRow = 2
	var collectionList: [Category] = [] {
		didSet{
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	private var pullControl = UIRefreshControl()
	let buttonSet = UIButton()
	let linkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 89, height: 25))
	let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    let nocategory = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    func dataNil(state: Bool){
        nocategory.text = "카테고리 없음"
        nocategory.textAlignment = .center
        nocategory.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        nocategory.textColor = UIColor.appColor(.title136)
        
        
        emptyLabel.text = "(+) 버튼을 눌러 링크를 보관할\n나만의 카테고리를 만들어보세요."
        emptyLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = UIColor.appColor(.title136)
        
        
        emptyLabel.snp.makeConstraints { snp in
            snp.centerX.equalTo(view)
            snp.centerY.equalTo(view)
            snp.height.equalTo(80)
        }
        
        nocategory.snp.makeConstraints { (snp) in
            snp.bottom.equalTo(emptyLabel.snp.top).offset(11)
            snp.centerX.equalTo(view)
            snp.width.greaterThanOrEqualTo(120)
            snp.height.equalTo(30)
        }
        
        
        
        emptyLabel.isHidden = state
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.addSubview(emptyLabel)
        view.addSubview(nocategory)
		bindViewModel()
        collectionView.showsVerticalScrollIndicator = false
		view.addSubview(linkLabel)
        view.addSubview(buttonSet)
        viewModel.inputs.readTitle()
        flottingBtn()
		refresh()
		
		linkLabel.text = "linkmo"
		linkLabel.linkLabel()
		linkLabel.translatesAutoresizingMaskIntoConstraints = false

        
		view.backgroundColor = UIColor.appColor(.bgColor)
		collectionView.backgroundColor = UIColor.appColor(.bgColor)
		
		buttonSet.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		buttonSet.setImage(UIImage(named: "icMysetting"), for: .normal)
		buttonSet.setImage(UIImage(named: "icMysetting"), for: .selected)
		buttonSet.contentVerticalAlignment = .fill
		buttonSet.contentHorizontalAlignment = .fill
		buttonSet.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
		buttonSet.backgroundColor = view.backgroundColor
		buttonSet.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			linkLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor),
			linkLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
			buttonSet.centerYAnchor.constraint(equalTo: linkLabel.centerYAnchor),
			buttonSet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14)
		])
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.inputs.readTitle()
        view.backgroundColor = UIColor.appColor(.bgColor)
        collectionView.backgroundColor = UIColor.appColor(.bgColor)
		navigationController?.isNavigationBarHidden = true
		collectionView.reloadData()
		
        let names = UserDefaults.standard.object(forKey: "linkname")
        linkname.text = "\(names ?? "link")님의 링크"
        
	}
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}

    @objc func barbutton(_ sender: Any){
		let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
		let settingVC = storyBoard.instantiateViewController(withIdentifier: "HomeSettingVC") as! HomeSettingVC
		self.navigationController?.pushViewController(settingVC, animated: true)
    }
	
	
	func refresh(){
		pullControl.attributedTitle = NSAttributedString(string: "새로고침")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = pullControl
        } else {
            collectionView.addSubview(pullControl)
        }
	}
	
	@objc private func refreshListData(_ sender: Any) {
        self.pullControl.endRefreshing()
		self.collectionView.reloadData()
    }
	
	@objc func tapped(_ button: EMTNeumorphicButton) {
		// isSelected property changes neumorphicLayer?.depthType automatically
		button.isSelected = !button.isSelected
	}
	
    //Autolayout
    func flottingBtn(){
        view.addSubview(AddBtn)
        AddBtn.frame = CGRect(x: 0, y: 0, width: 62, height: 62)
        AddBtn.setImage(UIImage(named: "ic_plus"), for: .normal)
		AddBtn.setTitleColor(.white, for: .normal)
		AddBtn.titleLabel?.font = .systemFont(ofSize: 26)
		AddBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
		AddBtn.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        AddBtn.layer.cornerRadius = AddBtn.frame.size.width / 2
		AddBtn.backgroundColor = UIColor.appColor(.pureBlue)
        
        AddBtn.snp.makeConstraints { snp in
            snp.bottom.equalTo(view).offset(-40)
            snp.trailing.equalTo(view).offset(-30)
            snp.width.equalTo(62)
            snp.height.equalTo(62)
        }
		
		AddBtn.rx.tap
			.subscribe({ _ in
				self.showAlert(title: "카테고리 추가하기")})
			.disposed(by: disposeBag)
	}
    
	func bindViewModel() {
		collectionView.rx.setDelegate(self).disposed(by: disposeBag)
		collectionView.rx.setDataSource(self).disposed(by: disposeBag)
		viewModel.outputs.categories
			.subscribe(onNext: {[weak self] categories in
                self?.collectionList = categories
                if categories.count == 0{
                    self?.state = .hide
                }else{
                    self?.state = .show
                }
            })
			.disposed(by: disposeBag)
	}
	
	func showAlert(title: String) {
		let showAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		
		showAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
		let saveAction = UIAlertAction(title:"추가", style: .default, handler: { (action) -> Void in
			let icon = showAlert.textFields![0] as UITextField
			let title = showAlert.textFields![1] as UITextField
			if self.collectionList.count < 20 {
				self.viewModel.addTitle(title: title.text!, icon: icon.text ?? " ")
			}else {
				let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
				toastLabel.backgroundColor = UIColor.appColor(.pureBlue)
				toastLabel.textColor = UIColor.white
				toastLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
				toastLabel.textAlignment = .center
				toastLabel.text = "카테고리는 20개 까지만 추가됩니다."
				toastLabel.alpha = 1.0
				self.view.addSubview(toastLabel)
				toastLabel.layer.cornerRadius = 18
				toastLabel.clipsToBounds = true
//				toastLabel.layer.shadowColor = UIColor(red: 159/255, green: 155/255, blue: 217/255, alpha: 1.0).cgColor
//				toastLabel.layer.shadowRadius = 13.0
//				toastLabel.layer.shadowOpacity = 0.75
//				toastLabel.layer.shadowOffset = CGSize(width: 0, height: 10)
//				toastLabel.layer.shouldRasterize = true
//				toastLabel.layer.masksToBounds = false
				
				
				UIView.animate(withDuration: 4.0, delay: 10.0, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
			}
			
		})
		saveAction.isEnabled = false
		showAlert.addAction(saveAction)
		showAlert.preferredAction = saveAction
		showAlert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "대표 아이콘"
		})
		showAlert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "카테고리 이름"
			NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
				saveAction.isEnabled = textField.text?.count ?? 0 > 0
			}
		})
		
		self.present(showAlert, animated: true, completion: nil)
	}
	
	func showActionsheet(indexPath: IndexPath, category: Category){
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.view.tintColor = .black
		let cancelAction = UIAlertAction(title: "취소", style: .cancel) {(action) in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(cancelAction)
		let EditAction = UIAlertAction(title: "타이틀 수정", style: .default) { (action) in
//			self.editAlert(category: category)
//			self.collectionView.reloadData()
			let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
			let editVC = storyBoard.instantiateViewController(withIdentifier: "EditTitleViewController") as! EditTitleViewController
			editVC.originCategory = category
			self.navigationController?.pushViewController(editVC, animated: true)
		}
		alert.addAction(EditAction)
		let destroyAction = UIAlertAction(title: "카테고리 삭제하기", style: .destructive) { (action) in
			self.deleteAlert(indexPath: indexPath, category: category)
			self.collectionView.reloadData()
		}
        alert.pruneNegativeWidthConstraints()
		alert.addAction(destroyAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func deleteAlert(indexPath: IndexPath, category: Category) {
		let alert = UIAlertController(title: "카테고리 삭제하기", message: nil, preferredStyle: .alert)
		alert.message = "해당 카테고리에 포함된 모든 링크도 \n 함께 삭제합니다."
		alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (action) -> Void in
			_ = self.tableshared.removeCategory(categoryId: indexPath.row)
			self.viewModel.inputs.deleteTitle(indexPath: indexPath, category: category)
		}))
		alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) -> Void in
			
		}))
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
		self.present(alert, animated: true, completion: nil)
		
	}
	
	func btnCloseTapped(cell: CategoryCollectionCell) {
		let indexPath = self.collectionView.indexPath(for: cell)
        print(indexPath!.row)
    }
}


class CategoryCollectionCell: UICollectionViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var editBtn: UIButton!
	@IBOutlet weak var iconLabel: UILabel!
	@IBOutlet weak var sectionCnt: UILabel!
	
}


extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
		cell.editBtn.addTarget(self, action: #selector(selectBtn), for: .touchUpInside)
		cell.editBtn.tag = indexPath.row
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let tableVC = storyBoard.instantiateViewController(withIdentifier: "SecondTableVC") as! SecondTableVC
        tableVC.categoryID = indexPath.row
        tableVC.navigationTitle = collectionList[indexPath.row].title
        self.navigationController?.pushViewController(tableVC, animated: true)
        
        
	}
	@IBAction func selectBtn(_ sender: UIButton) {
		let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
		let indexPath = self.collectionView.indexPathForItem(at: buttonPosition)
		let eachCategory = collectionList[indexPath!.row]
		showActionsheet(indexPath: indexPath!, category: eachCategory)
	}
}

extension HomeViewController: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
		var sectionCount = 0
		cell.titleLabel.text = collectionList[indexPath.row].title
		cell.iconLabel.text = collectionList[indexPath.row].icon
		self.tableViewModel.readSections(categoryId: indexPath.row).subscribe(onNext: {[weak self] categories in
			sectionCount = categories.count })
		.disposed(by: disposeBag)
		cell.sectionCnt.text = "\(sectionCount)개"
		
        cell.layer.masksToBounds = false
		cell.layer.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100).cgColor
        let cornerRadius: CGFloat = 15
        let shadowRadius: CGFloat = 4

        let darkShadow = CALayer()
        darkShadow.frame = cell.bounds
        darkShadow.backgroundColor = view.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        cell.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = cell.bounds
        lightShadow.backgroundColor = view.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        cell.layer.insertSublayer(lightShadow, at: 0)
		
		return cell
	}
    
	
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    //  cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / CGFloat(numberRow) - (lay.minimumInteritemSpacing + lay.minimumLineSpacing + 10)
        
        return CGSize(width:widthPerItem, height:widthPerItem)
    }
    // 셀 가로간격
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
    //셀 세로간격
	func collectionView(_ collectionView: UICollectionView, layout
		collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 19
	}
    //컬렉션뷰 인라인
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 19, left: 20, bottom: 0, right: 20)
    }
}

class EmojiTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UILabel {
	func linkLabel() {
		textAlignment = .center
		textColor = UIColor.appColor(.titleGray)
		font = UIFont(name:"GmarketSansLight",size:18)
	}
}
