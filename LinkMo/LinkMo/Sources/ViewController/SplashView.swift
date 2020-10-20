//
//  SplashView.swift
//  LinkMo
//
//  Created by taeuk on 2020/10/20.
//  Copyright © 2020 김보민. All rights reserved.
//

import SwiftUI
import UIKit

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        VStack{
            if self.isActive{
                UIhomeVC()
                
            }else{
                Text("Awesome Splash Screen")
                    .font(Font.largeTitle)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation{
                    self.isActive = true
                }
            }
        }
    }
}
struct UIhomeVC: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UIStoryboard(name: "Home", bundle: nil)
        .instantiateViewController(identifier: "MainId")
        
        
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
