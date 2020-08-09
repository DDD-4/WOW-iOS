//
//  CategoryStorageType.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

enum CategoryStorageError: Error{
	case createError(String)
    case fetchError(String)
    case updateError(String)
    case deleteError(String)
}

protocol CategoryStorageType{
	@discardableResult
	func createTitle(title: Category) -> Observable<Category>
	
	@discardableResult
	func fetchTitle() -> Observable<[Category]>
	
	@discardableResult
	func deleteTitle(id: String) -> Observable<Category>
}
