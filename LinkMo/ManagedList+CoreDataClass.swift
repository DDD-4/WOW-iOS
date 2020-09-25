//
//  ManagedList+CoreDataClass.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/28.
//  Copyright © 2020 김보민. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedList)
public class ManagedList: NSManagedObject {

    func toTableSection() -> TableSection{
        return .init(categoryid: categoryid, header: section, items: title, link: url)
    }
    
    func fromTableSection(list: TableSection){
        self.categoryid = list.categoryid
        self.section = list.header
        self.title = list.itemed
        self.url = list.linked
    }
    
    
    
}
