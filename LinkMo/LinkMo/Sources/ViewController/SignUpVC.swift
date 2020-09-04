//
//  SignUpVC.swift
//  LinkMo
//
//  Created by taeuk on 2020/09/02.
//  Copyright © 2020 김보민. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
 - 이름 비었을때 수정
 - 밑쪽 텍스트필드 높이 수정
 */

class SignUpVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    @IBOutlet weak var combinationLbl: UILabel!
    @IBOutlet weak var idConfirmLbl: UILabel!
    @IBOutlet weak var pwConfirmLbl: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    let loginShard = LoginViewModel.shard
    let signShard = SignUpViewModel.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()


        combinationLbl.text = "✕ 영문/숫자/특수문자 2가지 이상 조합(8~12)자"
        combinationLbl.textColor = .red
        idConfirmLbl.text = "✕ 아이디(이메일)제외"
        idConfirmLbl.textColor = .red
        pwConfirmLbl.textColor = .red
        
        
        
        signUpStep()
        signUpbtn()
    }
    
    func signUpStep(){
        //name
        nameText.rx.text
        .orEmpty
            .bind(to: signShard.nameValidS)
        .disposed(by: bag)
        
        signShard.nameValidS
            .map(signShard.checkString)
            .bind(to: signShard.nameVBool)
            .disposed(by: bag)
        
        signShard.nameVBool.subscribe(onNext: { b in
            print(b)
        })
        .disposed(by: bag)
        
        //email
        emailText.rx.text.orEmpty
        .bind(to: signShard.emailSignup)
        .disposed(by: bag)
        
        signShard.emailSignup
            .map(loginShard.emailValidation)
            .bind(to: signShard.emailBool)
            .disposed(by: bag)
        
        signShard.emailBool.subscribe(onNext: { b in
            if b {
                self.idConfirmLbl.text = "✓ 아이디(이메일)제외"
                self.idConfirmLbl.textColor = .blue
            }else{
                self.idConfirmLbl.text = "✕ 아이디(이메일)제외"
                self.idConfirmLbl.textColor = .red
            }
        })
        .disposed(by: bag)
        
        
        //password
        passwordText.rx.text.orEmpty
        .bind(to: signShard.passwordSignup)
        .disposed(by: bag)
        

        signShard.passwordSignup.subscribe(onNext: { b in
            print(b)
            })
            .disposed(by: bag)
        
        signShard.passwordSignup
            .map(loginShard.passwordValidation)
            .bind(to: signShard.passwordBool)
            .disposed(by: bag)
        
        signShard.passwordBool.subscribe(onNext: { b in
            if b {
                self.combinationLbl.text = "✓ 영문/숫자/특수문자 2가지 이상 조합(8~12)자"
                self.combinationLbl.textColor = .blue
            }else{
                self.combinationLbl.text = "✕ 영문/숫자/특수문자 2가지 이상 조합(8~12)자"
                self.combinationLbl.textColor = .red
            }
        })
        .disposed(by: bag)
        
        passwordConfirm.rx.text.orEmpty
        .bind(to: signShard.pwConfirmSignup)
        .disposed(by: bag)
        
        signShard.pwConfirmSignup
            .map(signShard.testT)
            .bind(to: signShard.pwConfirmBool)
        .disposed(by: bag)
        
        signShard.pwConfirmBool.subscribe(onNext: { _ in
            self.pwConfirmLbl.isHidden = self.signShard.passwordConfirmType
        })
        .disposed(by: bag)
        
        
        Observable.combineLatest(signShard.nameVBool, signShard.emailBool, signShard.passwordBool, signShard.pwConfirmBool, resultSelector: { $0 && $1 && $2 && $3})
            .subscribe(onNext: { b in
                
                self.signUpButton.isEnabled = b
            })
            .disposed(by: bag)
        
    }
    
    func signUpbtn(){
        signUpButton.rx.tap
        .subscribe(onNext: { b in
            let alert = UIAlertController(title: "success", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(ok)
            self.present(alert, animated: true)
        })
        .disposed(by: bag)
    }
    
    
}
