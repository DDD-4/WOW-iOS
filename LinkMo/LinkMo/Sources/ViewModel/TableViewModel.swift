
//  TableViewModel.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/18.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class TableViewModel{
    
    static let shard = TableViewModel()
    
    
    
    var ListSection: [String] = []
    
    var sections: [TableSection] = [
        //TableSection(header: "A", items: ["A"], link: ["A"])
    ]
    
    var subject: BehaviorRelay<[TableSection]> = BehaviorRelay(value: [])
    
    init() {
        
    }
    
    func addSection(header: String) -> [TableSection]{
        let headerAppend = TableSection(header: header, items: [], link: [])
        sections.append(headerAppend)
        return sections
    }
    
    
    func addCell(sectionNumber: Int, linkTitle: String, linkUrl: String) -> [TableSection]{
        
        sections[sectionNumber].items.append(linkTitle)
        sections[sectionNumber].link.append(linkUrl)
        
        return sections
    }
    
    func deleteSection(){
        
    }
    
    func deleteCell(){
        
    }
}

//MARK: - alert actionSheet 경고창
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
