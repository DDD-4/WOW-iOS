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
	let disposeBag = DisposeBag()
	
	@IBOutlet weak var collectionView: UICollectionView!
	
    let AddBtn = UIButton(type: .system)
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
        //  navigationBar
        navigationController?.navigationBar.topItem?.title = "link"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.bgColor)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .lightGray
        button.layer.masksToBounds = false
        button.layer.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 100).cgColor
        let cornerRadius: CGFloat = 15
        let shadowRadius: CGFloat = 4

        let darkShadow = CALayer()
        darkShadow.frame = button.bounds
        darkShadow.backgroundColor = view.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        button.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = button.bounds
        lightShadow.backgroundColor = view.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        button.layer.insertSublayer(lightShadow, at: 0)
    
        
        var imageLosgo = UIImage(named: "ic_my_")
        imageLosgo = imageLosgo?.withRenderingMode(.alwaysOriginal)
        button.setImage(imageLosgo, for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton

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

	@objc private func refreshListData(_ sender: Any) {
        self.pullControl.endRefreshing()
		collectionView.reloadData()
    }

	
	@objc func tapped(_ button: EMTNeumorphicButton) {
		// isSelected property changes neumorphicLayer?.depthType automatically
		button.isSelected = !button.isSelected
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.inputs.readTitle()
        flottingBtn()
        
        view.backgroundColor = UIColor.appColor(.bgColor)
        collectionView.backgroundColor = UIColor.appColor(.bgColor)
        
	}

    //Autolayout
    func flottingBtn(){
        view.addSubview(AddBtn)
        AddBtn.frame = CGRect(x: 0, y: 0, width: 62, height: 62)
		AddBtn.setTitle("+", for: .normal)
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

		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "대표 아이콘"
		})
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "카테고리 이름"
		})
		alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { (action) -> Void in
		}))
		alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { (action) -> Void in
			let icon = alert.textFields![0] as UITextField
			let title = alert.textFields![1] as UITextField
			self.viewModel.addTitle(title: title.text ?? " ", icon: icon.text ?? " ")
		}))

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
	
}


extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
		cell.editBtn.addTarget(self, action: #selector(selectBtn), for: .touchUpInside)
		cell.editBtn.tag = indexPath.row
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let tableVC = storyBoard.instantiateViewController(withIdentifier: "SecondTableVC") as! SecondTableVC
        tableVC.categoryID = indexPath.row
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
		cell.titleLabel.text = collectionList[indexPath.row].title
		cell.iconLabel.text = collectionList[indexPath.row].icon
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

