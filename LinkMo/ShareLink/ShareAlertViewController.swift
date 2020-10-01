//
//  ShareAlertViewController.swift
//  ShareLink
//
//  Created by 김삼복 on 2020/09/29.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social

class ShareAlertViewController: SLComposeServiceViewController {
	var categoryid = 0
	var sectionid = 0
	
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
					print("URL!!! :   ", shareURL)
					print("textview :   ", self.textView.text)
					print("categoryID :    ", self.categoryid)
					print("sectionID :   ", self.sectionid)
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
