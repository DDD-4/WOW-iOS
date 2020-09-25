
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
    let categoryfetch = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
    var sectionDic: Dictionary = [Int64:[TableSection]]()
    init() { }
    
    func addSections(categoryId: Int, header: String) -> Observable<[TableSection]>{
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            //table
            let headerAppend = TableSection(categoryid: ids, header: header, items: [], link: [])
            
            let managedTable = ManagedList(context: context)
            managedTable.fromTableSection(list: headerAppend)
            
            sections.append(headerAppend)
            sectionDic.updateValue(sections, forKey: ids)
            
            try self.context.save()
            return .just(sections)
        }catch{
            print(error)
            return .error(error)
        }
    }
    
    func readSections(categoryId: Int) -> Observable<[TableSection]>{
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            //table
            let sectionRead = try self.context.fetch(fetch)
            let sectionMap  = sectionRead.map{$0.toTableSection()}
            sectionDic[ids] = sectionMap.filter{$0.categoryid == ids}
            
            sections = sectionDic[ids]!
            subject.accept(sections)
            return .just(sections)
        }catch{
            print(error)
            return .error(error)
        }
    }
    
    
    
    func updateSections(updateText: String, index: Int, categoryId: Int) -> Observable<[TableSection]>{
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let updateValue = sectionRead.filter{$0.categoryid == ids}
            updateValue[index].setValue(updateText, forKey: "section")
            try self.context.save()
            
            return .just(sections)
        }catch{
            print("Error", error)
            return .error(error)
        }
    }
    
    func deleteSections(section: Int, categoryId: Int) -> Observable<[TableSection]>{
        
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let deleteValue = sectionRead.filter{$0.categoryid == ids}
            
            self.context.delete(deleteValue[section])
            try self.context.save()
            
            return .just(sections)
        }catch{
            print("Error", error)
            return .error(error)
        }
        
    }
    
    func sectionsList(sectionid: Int){
        ListSection.removeAll()
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[sectionid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let list = sectionRead.filter{$0.categoryid == ids}
            
            for i in 0...list.count - 1{
                ListSection.append(list[i].section)
            }
        }catch{
            print("Error", error)
        }
    }
    
    func addCells(categoryid: Int, sectionNumber: Int, linkTitle: String, linkUrl: String) -> Observable<[TableSection]>{
        
        sections[sectionNumber].items.append(linkTitle)
        sections[sectionNumber].link.append(linkUrl)
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let deleteValue = sectionRead.filter{$0.categoryid == ids}
            
            deleteValue[sectionNumber].setValue([linkTitle], forKey: "title")
            deleteValue[sectionNumber].setValue([linkUrl], forKey: "url")
            deleteValue[sectionNumber].fromTableSection(list: sections[sectionNumber])
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("Error",error)
            return .error(error)
        }
    }
    
    func updateCells(categoryid: Int, section: Int, cellrow: Int, title: String, link: String) -> Observable<[TableSection]>{
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let deleteValue = sectionRead.filter{$0.categoryid == ids}
            
            deleteValue[section].title[cellrow] = title
            deleteValue[section].url[cellrow] = link
            
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("updateCell error, ",error)
            return .error(error)
        }
    }
    
    func removeCells(categoryid: Int, section: Int, cellrow: Int) -> Observable<[TableSection]>{
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let deleteValue = sectionRead.filter{$0.categoryid == ids}
            
            deleteValue[section].title.remove(at: cellrow)
            deleteValue[section].url.remove(at: cellrow)
            
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