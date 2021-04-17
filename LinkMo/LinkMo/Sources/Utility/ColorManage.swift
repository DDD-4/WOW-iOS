//
//  ColorManage.swift
//  LinkMo
//
//  Created by taeuk on 2020/10/01.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import UIKit

enum neumorphismColor{
    case bgColor
    case listHeaderColor
    case pureBlue
    case numberColor
    case titleGray
    case title136
	case blackLabel
	case lightGray
}
extension UIColor{
	static func appColor(_ name: neumorphismColor) -> UIColor{
		switch name {
			
			case .bgColor:
				return UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 1.0)
			
			case .listHeaderColor:
				return UIColor(red: 241/255, green: 222/255, blue: 207/255, alpha: 1.0)
			
			case .pureBlue:
				return UIColor(red: 0/255, green: 17/255, blue: 232/255, alpha: 1.0)
			
			case .numberColor:
				return UIColor(red: 148/255, green: 146/255, blue: 161/255, alpha: 1.0)
			
			case .titleGray:
				return UIColor(red: 89/255, green: 86/255, blue: 109/255, alpha: 1.0)
            
            case .title136:
            return UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
			
			case .blackLabel:
				return UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
			
			case .lightGray:
				return UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
		}
		
    }
}
