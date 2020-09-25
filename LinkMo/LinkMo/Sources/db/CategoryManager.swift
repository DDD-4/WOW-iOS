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
		let container = CustomPersistantContainer(name: "LinkMo")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	lazy var context = persistentContainer.viewContext
	
	
	//shareLink
	var fetchedCategory = [NSManagedObject]()
	func fetchCategory() {
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedCategory")
		let dateSort = NSSortDescriptor(key:"id", ascending:false)
		fetchRequest.sortDescriptors = [dateSort]
		self.fetchedCategory = try! context.fetch(fetchRequest)
	}
	
	
	
}


class CustomPersistantContainer : NSPersistentContainer {
//	static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.LinkMo.share")!
//	let storeDescription = NSPersistentStoreDescription(url: url)
//	override class func defaultDirectoryURL() -> URL {
//		return url
//	}
	override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.LinkMo.share")
        storeURL = storeURL?.appendingPathComponent("com.LinkMo.share.sqlite")
        return storeURL!
    }
}
