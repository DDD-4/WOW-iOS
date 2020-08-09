//
//  ManagedCategory+CoreDataProperties.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCategory> {
        return NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String

}
