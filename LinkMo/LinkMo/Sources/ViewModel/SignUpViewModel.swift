//
//  SignUpViewModel.swift
//  LinkMo
//
//  Created by taeuk on 2020/09/02.
//  Copyright © 2020 김보민. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/*
 - nameText 빈값 true 수정
 
 */
class SignUpViewModel {
    static let shard = SignUpViewModel()
    
    
    let nameValidS: BehaviorSubject<String> = BehaviorSubject(value: "")
    let nameVBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let emailSignup: BehaviorSubject<String> = BehaviorSubject(value: "")
    let emailBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let passwordSignup: BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let pwConfirmSignup: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwConfirmBool: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    lazy var passwordConfirmType = false
    lazy var nameType = false
    
    init() {
        
    }
    
    func checkString(_ newText:String) -> Bool {
        if newText != ""{
            let regex = try! NSRegularExpression(pattern: "[가-힣ㄱ-ㅎㅏ-ㅣ\\s]", options: [])
            let list = regex.matches(in:newText, options: [], range:NSRange.init(location: 0, length:newText.count))
            
            if(list.count != newText.count){
                return false
            }
            nameType = true
        }
        print("name type: ", nameType)
        return nameType
    }

    
    func testT(_ repassword: String) -> Bool{
        
        do{
            let passwordValue =  try passwordSignup.value()
             passwordConfirmType = try pwConfirmBool.value()
            
            if repassword != ""{
                if repassword == passwordValue{
                    
                    passwordConfirmType = true
                    
                }else{
                    passwordConfirmType = false
                    
                }
            }
        }catch{
            print("Errors: ", error)
            return false
        }
        
        return passwordConfirmType
    }
    
}
