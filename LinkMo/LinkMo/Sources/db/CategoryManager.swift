//
//  CategoryManager.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
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
	
	
	//MARK: - shareLink
	var fetchedTableSection = [NSManagedObject]()

	func fetchTableSection() {
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedList")
		let dateSort = NSSortDescriptor(key:"categoryid", ascending:false)
		fetchRequest.sortDescriptors = [dateSort]
		self.fetchedTableSection = try! context.fetch(fetchRequest)
	}
	
	func createCells(category: Category, tablesection: TableSection, categoryNumber: Int, sectionNumber: Int, linkTitle: String, linkUrl: String){
        
		let fetchRequestCa = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
		let fetchRequestLi = NSFetchRequest<ManagedList>(entityName: "ManagedList")
		
		let categorys = try! context.fetch(fetchRequestCa)
		let ids = categorys[categoryNumber].id
		
		let sectionRead = try! context.fetch(fetchRequestLi)
		let deleteValue = sectionRead.filter{$0.categoryid == ids}
		
		deleteValue[sectionNumber].title.append(linkTitle)
		deleteValue[sectionNumber].url.append(linkUrl)
		try! context.save()
		fetchTableSection()
        
	}
}

class CustomPersistantContainer : NSPersistentContainer {
	override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.LinkMo.share")
        storeURL = storeURL?.appendingPathComponent("com.LinkMo.share.sqlite")
        print(storeURL!)
        return storeURL!
    }
}
