//
//  CoreDataStack.swift
//  LinkMo
//
//  Created by 김삼복 on 2020/09/25.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class CoreDataStack {
	static let store = CoreDataStack()
	
	var fetchedSections = [ManagedCategory]()
	
	
	var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
	
	
	func fetchSections() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedCategory")
        let dateSort = NSSortDescriptor(key:"id", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
//		self.fetchedSections = try! context.fetch(fetchRequest) as? [ManagedCategory]
		print("🍏 :", fetchedSections)
    }
	
	func fetchedTitle(){
        do {
			let contact = try context.fetch(ManagedCategory.fetchRequest()) as! [Category]
			print("🍏🍏 : ", contact)
			contact.forEach { print("🍏🍏 : ", $0.title) } }
		catch { print(error.localizedDescription) }

    }
	
//	lazy var persistentContainer: CustomPersistantContainer = {
//		let container = CustomPersistantContainer(name: "com.LinkMo.share")
//		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//			if let error = error as NSError? {
//				fatalError("Unresolved error \(error), \(error.userInfo)")
//			}
//		})
//		return container
//	}()

	
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
