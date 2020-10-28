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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
		navigationController?.isNavigationBarHidden = false
        collectionView.showsVerticalScrollIndicator = false
        
        viewModel.inputs.readTitle()
        flottingBtn()
        navsettingVC()
        
        
		view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		collectionView.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100)
		
		pullControl.attributedTitle = NSAttributedString(string: "새로고침")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = pullControl
        } else {
            collectionView.addSubview(pullControl)
        }
	}

    @objc func barbutton(_ sender: Any){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let addcellvc = storyBoard.instantiateViewController(withIdentifier: "SettingNav")
        addcellvc.modalPresentationStyle = .fullScreen
        self.present(addcellvc, animated: true)
        
//        self.navigationController?.pushViewController(addcellvc, animated: true)
        
    }
	@objc private func refreshListData(_ sender: Any) {
        self.pullControl.endRefreshing()
		self.collectionView.reloadData()
    }

	
	@objc func tapped(_ button: EMTNeumorphicButton) {
		// isSelected property changes neumorphicLayer?.depthType automatically
		button.isSelected = !button.isSelected
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
        
        view.backgroundColor = UIColor.appColor(.bgColor)
        collectionView.backgroundColor = UIColor.appColor(.bgColor)

        let names = UserDefaults.standard.object(forKey: "linkname")
        linkname.text = "\(names ?? "link")님의 링크"
        
	}

    func navsettingVC(){
        //  navigationBar
        navigationItem.title = "link"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.bgColor)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .lightGray
        button.layer.masksToBounds = false
        button.layer.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100).cgColor
        
        
        var imageLosgo = UIImage(named: "ic_my_")
        imageLosgo = imageLosgo?.withRenderingMode(.alwaysOriginal)
        button.setImage(imageLosgo, for: .normal)
        button.addTarget(self, action: #selector(barbutton(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
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
		AddBtn.backgroundColor = UIColor(red: 0/255, green: 17/255, blue: 232/255, alpha: 100)
        
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
				self?.collectionList = categories })
			.disposed(by: disposeBag)
	}
	
	func showAlert(title: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		let saveAction = UIAlertAction(title:"Save", style: .default, handler: { (action) -> Void in
			let icon = alert.textFields![0] as UITextField
			let title = alert.textFields![1] as UITextField
			if self.collectionList.count < 20 {
				self.viewModel.addTitle(title: title.text!, icon: icon.text ?? " ")
			}else {
				let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
				toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
				toastLabel.textColor = UIColor.white
				toastLabel.textAlignment = .center
				toastLabel.text = "카테고리는 20개 까지만 추가됩니다."
				toastLabel.alpha = 1.0
				toastLabel.layer.cornerRadius = 10
				toastLabel.clipsToBounds = true
				self.view.addSubview(toastLabel)
				UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
			}
			
		})
		saveAction.isEnabled = false
		alert.addAction(saveAction)
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "대표 아이콘"
		})
		alert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "카테고리 이름"
			NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
				saveAction.isEnabled = textField.text?.count ?? 0 > 0
			}
		})
		self.present(alert, animated: true, completion: nil)
	}
	
	func showActionsheet(indexPath: IndexPath, category: Category){
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(cancelAction)
		let EditAction = UIAlertAction(title: "Edit", style: .default) { (action) in
			self.editAlert(category: category)
			self.collectionView.reloadData()
		}
		alert.addAction(EditAction)
		let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            _ = self.tableshared.removeCategory(categoryId: indexPath.row)
			self.viewModel.inputs.deleteTitle(indexPath: indexPath, category: category)
            
		}
		alert.addAction(destroyAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func editAlert(category: Category) {
		let alert = UIAlertController(title: "카테고리 수정하기", message: nil, preferredStyle: .alert)
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "\(category.icon)"
		})
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "\(category.title)"
		})
		alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { (action) -> Void in
		}))
		alert.addAction(UIAlertAction(title: "수정", style: .default, handler: { (action) -> Void in
			let icon = alert.textFields![0] as UITextField
			let title = alert.textFields![1] as UITextField
			if title.text!.isEmpty {
				title.text = "\(category.title)"
			}
			if icon.text!.isEmpty {
				icon.text = "\(category.icon)"
			}
			self.viewModel.inputs.updateTitle(category: category, title: title.text ?? "\(category.title)", icon: icon.text ?? "\(category.icon)")
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}))
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
		self.present(alert, animated: true, completion: nil)
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
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
