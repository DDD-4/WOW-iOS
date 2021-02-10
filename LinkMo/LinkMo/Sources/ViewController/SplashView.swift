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
    @State var animate: Bool = false
    var body: some View {
        GeometryReader{ proxy in
            
            ZStack{
                if self.isActive{
                    UIhomeVC()
                }else{
                    
                    VStack{
                        Spacer()
                        
                        Rectangle()
                            .fill(Color.pureblue)
                            .frame(width: animate ? 135 : 0, height: 30)
                            .cornerRadius(15)
                            .shadow(color: Color.white.opacity(0.15), radius: 5, x: -3, y: 6)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: -6)
                            
                            .rotationEffect(Angle(degrees: 135))
                            .padding(.bottom, 50)
                        
                        Text("linkmo")
                        .font(.custom("GmarketSansLight", size: 35))
                        .foregroundColor(.fontColor)
                        
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    
                }
                Spacer()
                    .layoutPriority(1)
            }
            .background(Color.pureblue)
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                animateRectSize()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(){
                        self.isActive = true
                    }
                }
            }
        }
    }
    func animateRectSize(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation(Animation.easeInOut(duration: 1)){
                animate.toggle()
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
extension Color{
    static let pureblue = Color(red: 0/255, green: 17/255, blue: 232/255)
    static let fontColor = Color(red: 117/255, green: 181/255, blue: 255/255)
}
