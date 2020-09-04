//
//  ManagedList+CoreDataProperties.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/28.
//  Copyright © 2020 김보민. All rights reserved.
//
//

import Foundation
import CoreData
/*
 managedlist -> managedsection
 section, id
 
 managedurl entity
 url, image, id, urltitle
 
 */

extension ManagedList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedList> {
        return NSFetchRequest<ManagedList>(entityName: "ManagedList")
    }

    @NSManaged public var title: [String]
    @NSManaged public var section: String
    @NSManaged public var url: [String]

}
