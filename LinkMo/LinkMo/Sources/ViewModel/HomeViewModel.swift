//
//  HomeViewModel.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
	func addTitle(title: String)
	func readTitle()
	func deleteTitle(indexPath: IndexPath, category: Category)
}

protocol HomeViewModelOutput {
	var categories: BehaviorSubject<[Category]>{ get set }
	var newText: BehaviorRelay<String>{ get set }
}

protocol HomeViewModelType {
  var inputs: HomeViewModelInput { get }
  var outputs: HomeViewModelOutput { get }
}

class HomeViewModel: CommonViewModel, HomeViewModelInput, HomeViewModelOutput, HomeViewModelType {
	//init() { }
	
	var inputs: HomeViewModelInput { return self }
	var outputs: HomeViewModelOutput { return self }
	
	var categories = BehaviorSubject<[Category]>(value: [])
	var newCategory = BehaviorRelay<Category?>(value: nil)
	var newText = BehaviorRelay<String>(value: "")
	
	func addTitle(title: String) {
		let category = Category(id: Int64(Date().timeIntervalSince1970), title: title)
		storage.createTitle(title: category)
			.bind { _ in
			self.readTitle()
			} .disposed(by: disposeBag)
	}
	
	func readTitle() {
		storage.fetchTitle()
			.bind { (categoryList) in
			self.categories.onNext(categoryList)
			} .disposed(by: disposeBag)
	}
	
	func deleteTitle(indexPath: IndexPath, category: Category) {
		storage.deleteTitle(category: category)
			.subscribe(onNext: { [weak self] categories in
				if var list = try? self?.categories.value() {
					list.remove(at: indexPath.row)
					self?.categories.onNext(list)
				}
			})
			.disposed(by: disposeBag)
    }

}
