
//  TableSection.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/14.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum tableShow{
    case hide
    case show
}

struct TableSection {
    var categoryid: Int64
    var header: String
    var items: [Item]
    var link: [Link]
    var thumbnail: [Data]
    var expand: Bool
    
}

extension TableSection: SectionModelType {
    
    
    typealias Item = String
    typealias Link = String
    
    init(original: TableSection, link: [String]) {
        self = original
        self.link = link
    }
    init(original: TableSection, items: [String]) {
        self = original
        self.items = items
    }
    
    var headers: String {
        return header
    }
    var titled: [String]{
        return items
    }
    var linked: [String]{
        return link
    }
    var categoryId: Int64{
        return categoryid
    }
    var expanded: Bool{
        return expand
    }
    var thumbnails: [Data]{
        return thumbnail
    }
}
