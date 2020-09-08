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

class HomeViewController: UIViewController {
//	var viewModel: HomeViewModel!
	let viewModel = HomeViewModel()
	let disposeBag = DisposeBag()
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var AddBtn: UIButton!
	
	var collectionList: [Category] = [] {
		didSet{
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
		navigationController?.isNavigationBarHidden = true
		let defaults = UserDefaults(suiteName: "group.com.LinkMo.share")
		defaults?.set(collectionList.first, forKey: "ShareLink")
        defaults?.synchronize()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		viewModel.inputs.readTitle()
	}

	
	func bindViewModel() {
		
		collectionView.rx.setDelegate(self).disposed(by: disposeBag)

		viewModel.outputs.categories
			.subscribe(onNext: {[weak self] categories in
				self?.collectionList = categories })
			.disposed(by: disposeBag)
		
		AddBtn.rx.tap
			.subscribe({ _ in
			self.showAlert(title: "카테고리 추가하기")})
			.disposed(by: disposeBag)
		
	}
	
	func showAlert(title: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "카테고리 이름을 입력해주세요."
		})
		alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { (action) -> Void in
		}))
		alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			self.viewModel.addTitle(title: textField.text!)
		}))

		self.present(alert, animated: true, completion: nil)
	}
	
	func showActionsheet(indexPath: IndexPath, category: Category){
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(cancelAction)
		let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
			self.viewModel.inputs.deleteTitle(indexPath: indexPath, category: category)
		}
		alert.addAction(destroyAction)
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
	
}


extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
		cell.editBtn.addTarget(self, action: #selector(selectBtn), for: .touchUpInside)
		cell.editBtn.tag = indexPath.row
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
		cell.contentView.layer.cornerRadius = 2.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.clear.cgColor
		cell.contentView.layer.masksToBounds = true

		cell.layer.backgroundColor = UIColor.white.cgColor
		cell.layer.shadowColor = UIColor.gray.cgColor
		cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
		cell.layer.shadowRadius = 2.0
		cell.layer.shadowOpacity = 1.0
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
		return cell
	}
    
	
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 158, height: 158)
    }
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 19.0
	}

	func collectionView(_ collectionView: UICollectionView, layout
		collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 19.0
	}
    
}

