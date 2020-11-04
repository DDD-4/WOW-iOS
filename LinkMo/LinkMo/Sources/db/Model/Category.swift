//
//  Category.swift
//  LinkMo
//
//  Created by 김삼복 on 08/08/2020.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import CoreData

enum CategoryShow{
    case show
    case hide
}
struct Category: Equatable {
	var title: String
	var id: Int64
	var icon: String

	init(id: Int64, title: String, icon: String) {
		self.id = id
        self.title = title
		self.icon = icon
    }
}

