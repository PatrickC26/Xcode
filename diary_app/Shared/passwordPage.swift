//
//  passwordPage.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/24.
//

import SwiftUI
import LocalAuthentication


struct passwordPage: View {
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("faceIDlock") var faceIDlock = false
    @AppStorage ("password") var password = 0
    @AppStorage ("locksituation") var situation = 0 // 1 -> new password | 2 -> normal check // 3 -> cancel password
    @AppStorage ("lock") var lock = false
    @AppStorage ("closeFIDtemp") var closeFIDtemp = false
    @AppStorage ("lastcurrentPage") var lastcurrentPage = 0
    @State var passwordS = 0
    @State var passwordT = 0
    @State var info = "info"
    
    @StateObject var passwordmodel_ = passwordmodel()
    
    var body: some View {
        VStack{
            
            Text(info)
            Text("")
            VStack{
                //dots for password
                HStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    if (passwordS == 0){
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                    }
                    else if (passwordS == 1){
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                    }
                    else if (passwordS == 2){
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                    }
                    else if (passwordS == 3){
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge")
                            .foregroundColor(Color.gray)
                    }
                    else {
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Image(systemName:"circlebadge.fill")
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                Text(" ")
                //first row of password x]button
                HStack{
                    Spacer()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 1
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"1.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 2
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"2.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                            
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 3
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"3.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Spacer()
                }
                //second row of password x]button
                HStack{
                    Spacer()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 4
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"4.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 5
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"5.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                            
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 6
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"6.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Spacer()
                }
                //third row of password x]button
                HStack{
                    Spacer()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 7
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"7.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 8
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"8.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                            
                    }
                    .padding()
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 9
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"9.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                    }
                    .padding()
                    Spacer()
                }
                //fourth row of password x]button
                HStack{
                    Spacer()
                    if(situation != 2){
                        Button{
                            if (situation == 1){
                                situation = 0
                            }
                            else if (situation == 3){
                                situation = 2
                            }
                            currentPage = 1
                        }label:{
                            Text("Cancel   ")
    //                            .font(.system(size: 60))
                        }
                    }
                    else{
                        Text("                ")
                    }
                    Button{
                        passwordS = passwordS + 1
                        passwordT = passwordT*10 + 0
                        passwordmodel_.passwordCheck(passwordS: passwordS,passwordT: passwordT)
                    }label:{
                        Image(systemName:"0.circle.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 60))
                            
                    }
                    .padding()
                    
                    Button{
                        passwordS = passwordS - 1
                        passwordT = passwordT/10
                        if (passwordS == 4){
                            if (password == passwordS){
                                if (situation == 1){
                                    password = passwordT
                                }
                                else if (situation == 2){
                                    currentPage = 1
                                    lock = false
                                }
                            }
                        }
                    }label:{
                        Image(systemName:"delete.backward.fill")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 30))
                    }
                    .padding()
                    Spacer()
                }
                
            }
            
            Button("FACE ID"){
                Task{
                    if (faceIDlock && passwordmodel_.getBioMetricStatus()){
                        do {
                            let _ =  try await passwordmodel_.authenticateser()
                            
                            
                        }
                        catch{
                            print("ERROR")
                        }
                    }
                }
            }.hidden()
        }.onAppear{
            Task {
                if(situation == 2){
                    if (faceIDlock && !closeFIDtemp){
                        do{
                            let resultoffaceid =  try await passwordmodel_.authenticateser()
                            if resultoffaceid {
                                currentPage = lastcurrentPage
                                lock = false
                            }
                            else {
                                print("false")
                                closeFIDtemp = true
                                currentPage = 3
                            }
                        }
                        catch{
                            print ("error in faceid in password site")
                            closeFIDtemp = true
                        }
                    }
                }
            }
            switch(situation){
                case 0:
                    info = "ERROR"
                    break
                case 1:
                    info = "Please enter a new password"
                    break
                case 2:
                    info = "Please enter your password"
                case 3:
                    info = "Please enter your password to cancel"
                default:
                    break
            }
        }
    }
}

@MainActor class passwordmodel: ObservableObject{
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("lastcurrentPage") var lastcurrentPage = 0
    @AppStorage ("faceIDlock") var faceIDlock = false
    @AppStorage ("lock") var lock = false
    @AppStorage ("password") var password = 0
    @AppStorage ("locksituation") var situation = 0 // 1 -> new password | 2 -> normal check // 3 -> cancel password
    @AppStorage ("locksituationB") var locksituationB = false
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("closeFIDtemp") var closeFIDtemp = false
    
    @StateObject var passwordmodel_ = passwordmodel()
    func passwordCheck(passwordS:Int,passwordT:Int) -> Void{
//        print("password")
        if (passwordS == 4){
            if (situation == 1){
                password = passwordT
                situation = 2
                currentPage = 1
                lock = false
                pagesituation = 2
                locksituationB = true
            }
            else if (situation == 2){
                if (password == passwordT){
                    print("equal")
                    currentPage = lastcurrentPage
                    lock = false
                    pagesituation = 1
                    locksituationB = true
                    closeFIDtemp = false
                }
            }
            else if (situation == 3){
                if (password == passwordT){
                    password = 0
                    situation = 0
                    pagesituation = 2
                    locksituationB = false
                    faceIDlock = false
                    currentPage = 1
                }
            }
        }
    }
    func getBioMetricStatus() -> Bool{
        let scanner = LAContext()
        return scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:.none)
    }
    
    func authenticateser()async throws -> Bool{
        let status =  try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login in to app")
        if (status){
            print("faceid OK")
            return true
        }
        else {
            currentPage = 3
            return false
        }
    }
}

struct passwordPage_Previews: PreviewProvider {
    static var previews: some View {
        passwordPage()
    }
}
