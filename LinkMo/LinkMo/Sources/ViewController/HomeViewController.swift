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

class HomeViewController: BaseViewController, ViewModelBindableType {
	var viewModel: HomeViewModel!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBAction func addBtn(_ sender: Any) {
		print("addd@!!!")
	}
	
	var collectionList = [Category]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		collectionList.append(Category(id: 1, title: "11번"))
		collectionList.append(Category(id: 2, title: "22번"))
		
		//self.viewModel.inputs.readTitle()
	}
	
	
	func bindViewModel() {

		viewModel.outputs.categories
			.subscribe(onNext: {[weak self] categories in
				self?.collectionList = categories
			})
		.disposed(by: disposeBag)
		
//		viewModel.outputs.categories
//			.bind(to: collectionView.rx.items(cellIdentifier: "CategoryCollectionCell")){  row, element, cell in
//			guard let CategoryCollectionCell : CategoryCollectionCell = cell as! CategoryCollectionCell else{ return }
//			CategoryCollectionCell.titleLabel.text = element.title
//			print("element.title : ", element.title)
//		}.disposed(by: disposeBag)
	}
}

class CategoryCollectionCell: UICollectionViewCell {
	@IBOutlet weak var titleLabel: UILabel!
}

class AddCell: UICollectionViewCell {
	@IBOutlet weak var titleText: UITextField!
}

extension HomeViewController: UICollectionViewDelegate {
	
}

extension HomeViewController: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
		cell.titleLabel?.text = collectionList[indexPath.row].title
		cell.backgroundColor = UIColor.lightGray
		return cell
	}
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 100, height: 100)
    }
}


