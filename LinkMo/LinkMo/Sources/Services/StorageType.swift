//
//  StorageType.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

enum StorageError: Error{
    case create(String)
    case read(String)
    case update(String)
    case delete(String)
}

protocol StorageType: CategoryStorageType {
	
}
