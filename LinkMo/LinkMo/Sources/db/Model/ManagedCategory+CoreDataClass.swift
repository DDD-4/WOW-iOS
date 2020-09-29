//
//  ManagedCategory+CoreDataClass.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCategory)
public class ManagedCategory: NSManagedObject {
	func toCategory() -> Category {
		return .init(id: id, title: title, icon: icon)
	}
	
	func fromCategory(category: Category) {
		self.id = category.id
		self.title = category.title
		self.icon = category.icon
	}
}
