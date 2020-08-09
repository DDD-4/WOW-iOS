//
//  CategoryManager.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class CategoryManager {
	static let share = CategoryManager()
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "LinkMo")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	lazy var context = persistentContainer.viewContext
}
