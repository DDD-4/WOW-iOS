//
//  LoginVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/09/02.
//  Copyright © 2020 김보민. All rights reserved.
//
import RxSwift
import RxCocoa
import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var loginState: UIButton!
    
    
    
    //스택뷰
    @IBOutlet weak var findId: UIButton!
    @IBOutlet weak var findPW: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let loginShard = LoginViewModel.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindto()
        
        Observable.combineLatest(loginShard.emailVBool, loginShard.passwordVBool, resultSelector: {$0 && $1})
            .subscribe(onNext: { b in
                self.confirmBtn.isHidden = !b
            })
            .disposed(by: bag)
        
    }

    func bindto(){
        
        emailField.rx.text
            .orEmpty
            .bind(to: loginShard.emailValidS)
            .disposed(by: bag)
        
        loginShard.emailValidS
            .map(loginShard.emailValidation)
            .bind(to: loginShard.emailVBool)
        .disposed(by: bag)
        
        passwordField.rx.text
            .orEmpty
            .bind(to: loginShard.passwordValidS)
            .disposed(by: bag)
        
        loginShard.passwordValidS
            .map(loginShard.passwordValidation)
            .bind(to: loginShard.passwordVBool)
            .disposed(by: bag)
    }
   
}
