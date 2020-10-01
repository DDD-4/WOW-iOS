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
}
extension UIColor{
    static func appColor(_ name: neumorphismColor) -> UIColor{
        switch name {
        case .bgColor:
            return UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 1.0)
        case .listHeaderColor:
            return UIColor(red: 241/255, green: 222/255, blue: 207/255, alpha: 1.0)
        }
    }
}
