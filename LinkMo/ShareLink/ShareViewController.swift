//
//  ShareViewController.swift
//  ShareLink
//
//  Created by 김삼복 on 2020/09/08.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
	private let tableView: UITableView = {
		let tableview = UITableView()
		return tableview
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ShareTableViewCell.self, forCellReuseIdentifier: "ShareTableViewCell")
		setConstraint()
		// autoHeight
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
	}
	
	private func setConstraint() {
		self.view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
}

class ShareTableViewCell: UITableViewCell{
	private let label: UILabel = {
		let label = UILabel()
		label.text = "UI/UX"
		label.textColor = UIColor.gray
		return label
	}()
	
	private func setConstraint() {
		contentView.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16)
		])
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setConstraint()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
	
extension ShareViewController: UITableViewDelegate{
	
}

extension ShareViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as? ShareTableViewCell else { return UITableViewCell() }
		
		return cell
	}
}



//기본 디폴트 값
//class ShareViewController: SLComposeServiceViewController {
//    override func isContentValid() -> Bool {
//        return true
//    }
//    override func didSelectPost() {
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//    override func configurationItems() -> [Any]! {
//        return []
//    }
//}
