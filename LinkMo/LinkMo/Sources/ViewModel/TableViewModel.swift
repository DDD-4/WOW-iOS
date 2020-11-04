
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
    
//    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//    lazy var context = appDelegate!.persistentContainer.viewContext
	lazy var context = CategoryManager.share.context
    
    //cell count
    var ListSection: [String] = []
    
    var sections: [TableSection] = [
//        TableSection(categoryid: 323, header: "a", items: [], link: [], expand: true)
    ]
    
    var subject: BehaviorRelay<[TableSection]> = BehaviorRelay(value: [])
    let fetch = NSFetchRequest<ManagedList>(entityName: "ManagedList")
    let categoryfetch = NSFetchRequest<ManagedCategory>(entityName: "ManagedCategory")
    var sectionDic: Dictionary = [Int64:[TableSection]]()
    
    var limitSection: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var limitCell: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //addCellList
    let listlocateS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let listlocateBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let urlValidS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let urlVBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let titleValidS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let titleVBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    init() { }
    
    
    func expandableCell(categoryId: Int, section: Int, bools: Bool) -> Observable<[TableSection]>{
        do{//category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let expande = sectionRead.filter{$0.categoryid == ids}
            
            expande[section].setValue(bools, forKey: "expand")
            try self.context.save()
            
            
            return .just(sections)
            
        }catch{
            print("Error", error)
            return .error(error)
        }
    }
    func addSections(categoryId: Int, header: String) -> Observable<[TableSection]>{
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            //table
            let headerAppend = TableSection(categoryid: ids, header: header, items: [], link: [], thumbnail: [], expand: true)
            
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
            
            if sectionDic[ids]!.count >= 20{
                limitSection.accept(true)
                
            }else{
                limitSection.accept(false)
            }
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
            let addValue = sectionRead.filter{$0.categoryid == ids}
            
            addValue[sectionNumber].setValue([linkTitle], forKey: "title")
            addValue[sectionNumber].setValue([linkUrl], forKey: "url")
            addValue[sectionNumber].fromTableSection(list: sections[sectionNumber])
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("Error",error)
            return .error(error)
        }
    }
    func addPng(categoryid: Int, sectionNumber: Int, png: Data) -> Observable<[TableSection]>{
        
        sections[sectionNumber].thumbnail.append(png)
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let addValue = sectionRead.filter{$0.categoryid == ids}
            
            addValue[sectionNumber].setValue([png], forKey: "thumbnail")
            addValue[sectionNumber].fromTableSection(list: sections[sectionNumber])
            
            try self.context.save()
            return .just(sections)
        }catch{
            return .error(error)
        }
    }
    func updatePng(categoryid: Int, section: Int, cellrow: Int, png: Data) -> Observable<[TableSection]>{
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let updatePNG = sectionRead.filter{$0.categoryid == ids}
            
            updatePNG[section].thumbnail[cellrow] = png
            
            try self.context.save()
            return .just(sections)
        }catch{
            return .error(error)
        }
    }
    func checkLimit(categoryid: Int, sectionNumber: Int){
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let addValue = sectionRead.filter{$0.categoryid == ids}
            
            if addValue[sectionNumber].title.count >= 500{
                limitCell.accept(true)
            }else{
                limitCell.accept(false)
            }
        }catch{
            print("ERrror", error)
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
            deleteValue[section].thumbnail.remove(at: cellrow)
            
            try self.context.save()
            return .just(sections)
        }catch{
            print("Remove Cell Error," ,error)
            return .error(CategoryStorageError.deleteError(error.localizedDescription))
        }
    }
    
    
    func removeCategory(categoryId: Int) -> Observable<[TableSection]>{
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryId].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let deleteValue = sectionRead.filter{$0.categoryid == ids}
            let SectionCount = deleteValue.count - 1
            if SectionCount < 0{
                return .just(sections)
            }else{
                for i in 0...SectionCount{
                    self.context.delete(deleteValue[i])
                }
            }
            

            try self.context.save()
            return .just(sections)
        }catch{
            print("remove All sections error", error)
            return .error(CategoryStorageError.deleteError(error.localizedDescription))
        }
    }
    
    // url 주소
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)()(([.]|[/])((\\w|-)+))+(|/)"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    //AddCellList
    func checklocate(_ locate: String) -> Bool{

        return locate.isEmpty ? false : true
    }
    func checkURL(_ urlString: String) -> Bool{

        return urlString.isEmpty ? false : true
    }
    
    func checkTitle(_ titleText: String) -> Bool{

        return titleText.isEmpty ? false : true
    }
    
    func showActivityIndicatory(trueFalse: Bool, uiView: UIView) {
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let container: UIView = UIView()
        let loadingView: UIView = UIView()
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style = .large
        if trueFalse{
            actInd.startAnimating()
        }
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        container.isHidden = !trueFalse
        loadingView.isHidden = !trueFalse
        
    }
    
}

