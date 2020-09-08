
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
    
    //cell count
    var ListSection: [String] = []
    
    var sections: [TableSection] = [
        //TableSection(header: "A", items: ["A"], link: ["A"])
    ]
    
    var subject: BehaviorRelay<[TableSection]> = BehaviorRelay(value: [])
    let fetch = NSFetchRequest<ManagedList>(entityName: "ManagedList")
    
    init() { }
    
    func subjectCount(){
        
    }
    
    func addSection(header: String) -> Observable<[TableSection]>{
        let headerAppend = TableSection(header: header, items: [], link: [])
        
        let managedTable = ManagedList(context: context)
        managedTable.fromTableSection(list: headerAppend)
        
        sections.append(headerAppend)
        
        do{
            try self.context.save()
            return .just(sections)
            
        }catch let error as NSError{
            print("List no create. error: ", error.userInfo)
            return .error(error)
        }
        
    }
    
    func readSections() -> Observable<[TableSection]>{
        
        do{
            let sectionRead = try self.context.fetch(fetch)
            sections = sectionRead.map{$0.toTableSection()}
            
            subject.accept(sections)
            return .just(sections)
            
        }catch let error as NSError{
            print("no read list. error: ", error.userInfo)
            return .error(error)
        }
    }
    
    
    
    func updateSection(updateText: String, index: Int) -> Observable<[TableSection]>{
        
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
    
    func sectionList(){
        do{
            
            let list = try self.context.fetch(fetch)
            for i in 0...list.count - 1{
                
                ListSection.append(list[i].section)
            }
        }catch{
            print("Error", error)
            
        }
    }
    
    func addCell(sectionNumber: Int, linkTitle: String, linkUrl: String) -> Observable<[TableSection]>{
        
        
        sections[sectionNumber].items.append(linkTitle)
        sections[sectionNumber].link.append(linkUrl)
        
        do{
            
            let cell = try self.context.fetch(fetch)
            
            cell[sectionNumber].setValue([linkTitle], forKey: "title")
            cell[sectionNumber].setValue([linkUrl], forKey: "url")
            cell[sectionNumber].fromTableSection(list: sections[sectionNumber])
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("Error",error)
            return .error(error)
        }
        
    }
    
    func updateCell(section: Int, cellrow: Int, title: String, link: String) -> Observable<[TableSection]>{
        
        do{
            let updateCell = try self.context.fetch(fetch)
            updateCell[section].title[cellrow] = title
            updateCell[section].url[cellrow] = link
            
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("updateCell error, ",error)
            return .error(error)
        }
    }
    
    
    func removeCell(section: Int, cellrow: Int) -> Observable<[TableSection]>{
        
        do{
            let celldelte = try self.context.fetch(fetch)
            
            celldelte[section].title.remove(at: cellrow)
            celldelte[section].url.remove(at: cellrow)
            
            print(celldelte[section].title)
            print(celldelte[section].url)
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("Remove Cell Error," ,error)
            return .error(CategoryStorageError.deleteError(error.localizedDescription))
        }
    }
    
    
    //전체 삭제
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
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
