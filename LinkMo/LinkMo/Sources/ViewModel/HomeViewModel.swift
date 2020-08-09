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
	func addTitle(category: Category)
	func readTitle()
}

protocol HomeViewModelOutput {
	var categories: BehaviorSubject<[Category]>{ get set }
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
	
	func addTitle(category: Category) {
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

}
