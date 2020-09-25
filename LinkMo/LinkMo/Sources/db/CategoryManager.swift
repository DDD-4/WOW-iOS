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
	
	
	//shareLink
	//MARK: - shareLink - Category
	var fetchedCategory = [NSManagedObject]()
	func fetchCategory() {
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedCategory")
		let dateSort = NSSortDescriptor(key:"id", ascending:false)
		fetchRequest.sortDescriptors = [dateSort]
		self.fetchedCategory = try! context.fetch(fetchRequest)
	}
	
	//MARK: - shareLink - TableSection
	var fetchedSection = [NSManagedObject]()
	func fetchSection() {
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedList")
//		let dateSort = NSSortDescriptor(key:"categoryid", ascending:false)
//		fetchRequest.sortDescriptors = [dateSort]
		self.fetchedSection = try! context.fetch(fetchRequest)
	}
	
	let categoryfetch = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
	let fetch = NSFetchRequest<ManagedList>(entityName: "ManagedList")
	var sectionDic: Dictionary = [Int64:[TableSection]]()
	var sections: [TableSection] = []
	var subject: BehaviorRelay<[TableSection]> = BehaviorRelay(value: [])
	func readSections(categoryId: Int) -> Observable<[TableSection]>{
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            //table
            let sectionRead = try self.context.fetch(fetch)
            let sectionMap  = sectionRead.map{$0.toTableSection()}
            sectionDic[ids] = sectionMap.filter{$0.categoryid == ids}
            
            sections = sectionDic[ids]!
            subject.accept(sections)
            return .just(sections)
        }catch{
            print(error)
            return .error(error)
        }
    }
	func readSection() -> Observable<[TableSection]>{
        do{
            let sectionRead = try self.context.fetch(fetch)
            sections = sectionRead.map{$0.toTableSection()}
            subject.accept(sections)
            return .just(sections)
        }catch let error as NSError{
            print("no read list. error: ", error.userInfo)
            return .error(error)
        }
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
