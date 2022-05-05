//
//  ContentView.swift
//  Shared
//
//  Created by 陳彥儒 on 2022/1/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage ("userid") var userid: String = ""
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("lastcurrentPage") var lastcurrentPage = 0
    @AppStorage ("lock") var lock = false
    @AppStorage ("locksituation") var locksituation = 0
    @AppStorage ("loading") var loading = false
    @AppStorage ("leftApp") var leftApp = false
    @AppStorage ("anonymous") var anonymous = false
    // 0 -> loginPage
    // 1 -> mainPage
    // 2 -> passwordPage
    // 4 -> theme
    // 5 -> diaryCategory
    // 6 -> addDiary
    var body: some View {
        ZStack{
            if (currentPage == 0){
                loginPage()
                    .onAppear{
                        lastcurrentPage = 0
                    }
            }
            else if (currentPage == 1 && anonymous){
                if (locksituation != 2 || !lock){
                    mainPage()
                        .onAppear{
                            lastcurrentPage = 1
                        }
                }
                else{
                    passwordPage()
                        .onAppear{
                            lastcurrentPage = 1
                        }
                }
            }
            else if (currentPage == 1){
                if (Auth.auth().currentUser?.uid == userid){
                    if (locksituation != 2 || !lock){
                        ZStack{
                            
                            mainPage()
                                .onAppear{
                                    lastcurrentPage = 1
                                }
                            if loading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .scaleEffect(2)
                            }
                        }
                    }
                    else{
                        passwordPage()
                            .onAppear{
                                lastcurrentPage = 1
                            }
                    }
                }
                else{
                    loginPage()
                        .onAppear{
                            lastcurrentPage = 0
                        }
                }
            }
            else if (currentPage == 3){
                passwordPage()
                    .onAppear{
                        lastcurrentPage = 3
                    }
            }
            else if (currentPage == 4){
                Theme()
                    .onAppear{
                        lastcurrentPage = 4
                    }
            }
            else if (currentPage == 5){
                diaryCategory()
                    .onAppear{
                        lastcurrentPage = 5
                    }
            }
            else if (currentPage == 6){
                addDiary()
                    .onAppear{
                        lastcurrentPage = 6
                    }
            }
            else {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Image("diary_man").resizable().frame(width: 300, height: 300)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("Diary App")
                            .font(.title.bold())
                        Spacer()
                    }
                    Text(" ")
                    HStack{
                        Spacer()
                        Text("PROTECTED")
                            .font(.title3.bold())
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            if loading {
                Rectangle()
                    .size(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .fill(Color.gray)
                    .opacity(0.2)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
