//
//  ShareAlertViewController.swift
//  ShareLink
//
//  Created by 김삼복 on 2020/09/29.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social
import CoreData
import RxSwift
import RxDataSources

class ShareAlertViewController: SLComposeServiceViewController {
	let viewModel = TableViewModel()
	let share = CategoryManager.share
	var categoryAll: Category? = nil
	var tablesectionAll: TableSection? = nil
	var categoryid: Int64 = 0
	var categoryIndex = 0
	var sectionIndex = 0 
    let tableshard = TableViewModel.shard
    override func isContentValid() -> Bool {
        return true
    }
    override func didSelectPost() {
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
		if let item = extensionContext?.inputItems.first as? NSExtensionItem,
			let itemProvider = item.attachments?.first,
			itemProvider.hasItemConformingToTypeIdentifier("public.url") {
			itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
				if let shareURL = url as? URL {
					self.share.createCells(category: self.categoryAll!, tablesection: self.tablesectionAll!, categoryNumber: self.categoryIndex, sectionNumber: self.sectionIndex, linkTitle: self.textView.text, linkUrl: "\(shareURL)")
                    
                    
				}
				self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
			}
		}
    }
	override func didSelectCancel() {
		self.navigationController?.popViewController(animated: true)
	}
    override func configurationItems() -> [Any]! {
        return []
    }
	
}
