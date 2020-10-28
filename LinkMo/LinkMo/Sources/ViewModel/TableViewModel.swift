
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
import LinkPresentation

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
    
//    func addThumbnails(linkurl: String, sectionNumber: Int) -> Data{
//
//        let urlstring = linkurl
//        let encoding = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////        let url = URL(string: encoding)!
//        let url = URL(string: "https://www.apple.com/ipad")!
//
//
//        print(url)
//
//        //  PreView, 썸네일이미지
//        LPMetadataProvider().startFetchingMetadata(for: url) { (linkMetadata, error) in
//            guard let linkMetadata = linkMetadata,
//                let imageProvider = linkMetadata.imageProvider else {
//                    return DispatchQueue.main.async {
//                        let defaultsImage = UIImage(named: "12")
//                        let convertData = defaultsImage?.pngData()
//                        self.sections[sectionNumber].thumbnail.append(convertData!)
//
//
//                    }
//            }
//            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                guard error == nil else {
//                    return
//                }
//                if let image = image as? UIImage {
//                    // do something with image
//                    DispatchQueue.main.async {
//                        let data = image.pngData()
//                        self.sections[sectionNumber].thumbnail.append(data!)
//                    }
//                } else {
//                    print("no image available")
//                }
//            }
//        }
//        return Data()
//    }
    func checkLimit(categoryid: Int, sectionNumber: Int){
        
        do{
            //category
            let categorys = try self.context.fetch(categoryfetch)
            let ids = categorys[categoryid].id
            
            //table
            let sectionRead = try self.context.fetch(fetch)
            let addValue = sectionRead.filter{$0.categoryid == ids}
            
            if addValue[sectionNumber].title.count >= 1000{
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
    
    //전체 삭제
    func deleteAllRecords() {
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedList")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    // url 주소
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+(|/)"
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
