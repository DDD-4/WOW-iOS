//
//  LoginViewModel.swift
//  LinkMo
//
//  Created by taeuk on 2020/09/02.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    static let shard = LoginViewModel()
    
    let emailValidS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let emailVBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let passwordValidS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordVBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    init() {
        
    }
    //        emailVBool.subscribe(onNext: { b in
    //            self.confirmBtn.isHidden = !b
    //            print(b)
    //        })
    //            .disposed(by: bag)
    //
    //        passwordVBool.subscribe(onNext: { b in
    //            self.confirmBtn.isHidden = !b
    //            print(!b)
    //        })
    //        .disposed(by: bag)
    
    func emailValidation(_ email: String) -> Bool{
        let emailReg = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }
    
    func passwordValidation(_ password: String) -> Bool{
        
        
        let pwReg = "^(?=.*[a-zA-Z])(?=.*[0-9]).{8,12}$|^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{8,12}$|^(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,12}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", pwReg)
        return predicate.evaluate(with: password)
    }
    
}
