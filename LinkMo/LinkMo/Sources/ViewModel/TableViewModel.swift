
//  TableViewModel.swift
//  LinkMo
//
//  Created by taeuk on 2020/08/18.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData


class TableViewModel{
    
    static let shard = TableViewModel()
    
    
    //private let context = CategoryManager.share.context
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate!.persistentContainer.viewContext
    
    var ListSection: [String] = []
    
    var sections: [TableSection] = [
        //TableSection(header: "A", items: ["A"], link: ["A"])
    ]
    
    var subject: BehaviorRelay<[TableSection]> = BehaviorRelay(value: [])
    
    init() { }
    
    func subjectCount(){
            
    }
    
    func addSection(header: String) -> [TableSection]{
        let headerAppend = TableSection(header: header, items: [], link: [])
        
        let managedTable = ManagedList(context: context)
        managedTable.fromTableSection(list: headerAppend)
        
        do{
            try self.context.save()
            
        }catch let error as NSError{
            print("List no create. error: ", error.userInfo)
        }
        
        sections.append(headerAppend)
        return sections
    }
    
    func readSections() -> Observable<[TableSection]>{
        let fetchR = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        
        do{
            let sectionRead = try self.context.fetch(fetchR)
            sections = sectionRead.map{$0.toTableSection()}
            
            subject.accept(sections)
            return .just(sections)
            
        }catch let error as NSError{
            print("no read list. error: ", error.userInfo)
            return .error(error)
        }
    }
    
    func updateSection(updateText: String, index: Int) -> Observable<[TableSection]>{
        let fetch = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        do{
            let update = try self.context.fetch(fetch)
            update[index].setValue(updateText, forKey: "section")
            try self.context.save()
            
            return .just(sections)
        }catch{
            print("Error", error)
            return .error(error)
        }
    }
    
    func deleteSection(section: Int) -> Observable<[TableSection]>{
        let fetch = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        
        do{
            let delete = try self.context.fetch(fetch)
            self.context.delete(delete[section])
            try self.context.save()
            
            return .just(sections)
        }catch{
            print("Error", error)
            return .error(error)
        }
        
    }
    
    
    func addCell(sectionNumber: Int, linkTitle: String, linkUrl: String) -> [TableSection]{
        
        sections[sectionNumber].items.append(linkTitle)
        sections[sectionNumber].link.append(linkUrl)
        
        return sections
    }
    
    //전체 삭제
    
//    func deleteAllRecords() {
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
//
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedList")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//        } catch {
//            print ("There was an error")
//        }
//    }
    
    
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
