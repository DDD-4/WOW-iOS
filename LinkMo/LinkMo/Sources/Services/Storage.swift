//
//  Storage.swift
//  WOW
//
//  Created by 김삼복 on 05/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class Storage: StorageType {
	private let context = CategoryManager.share.context
	
    func createTitle(title: Category) -> Observable<Category> {
		let managedCategory = ManagedCategory(context: self.context)
        managedCategory.fromCategory(category: title)
		
        do{
            try self.context.save()
			return .just(managedCategory.toCategory())
        }catch let error as NSError{
            print("category를 생성할 수 없습니다. error: ", error.userInfo)
            return .error(error)
        }
    }
    
    func fetchTitle() -> Observable<[Category]> {
        let fetchRequest = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
        do {
            let managedCategoryList = try self.context.fetch(fetchRequest)
			let categoryList = managedCategoryList.map { $0.toCategory() }
            return .just(categoryList)
        }catch let error as NSError{
            print("category를 읽을 수 없습니다. error: ", error.userInfo)
            return .error(error)
        }
    }

	func deleteTitle(id: Int64) -> Observable<Category> {
		let fetchRequest = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
		do{
			fetchRequest.predicate = NSPredicate(format: "id == %d", id)
			let results = try self.context.fetch(fetchRequest)
			if let managedCategoryList = results.first {
				let categoryList = managedCategoryList.toCategory()
				self.context.delete(managedCategoryList)
				do{
					try self.context.save()
					return .just(categoryList)
				}catch{
					return .error(CategoryStorageError.deleteError("id이 \(id)인 Category를 제거하는데 오류 발생"))
				}
			}else{
				return .error(CategoryStorageError.fetchError("해당 데이터에 대한 Category를 찾을 수 없음"))
			}
		}catch let error{
			return .error(CategoryStorageError.deleteError(error.localizedDescription))
		}
	}
	
	func deleteTitle(category: Category) -> Observable<Category> {
		deleteTitle(id: category.id)
    }
	
//	fun create(LinkModel) {
//		UserManager.update({count: 1}) .save
//		LinkManager.create(LinkModel)
//	}
}

