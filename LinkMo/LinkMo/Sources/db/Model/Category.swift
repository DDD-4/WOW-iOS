//
//  Category.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import CoreData

struct Category: Equatable {
	var title: String
	var id: Int64

	init(id: Int64, title: String) {
		self.id = id
        self.title = title
    }
}
