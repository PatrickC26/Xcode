//
//  mainPage.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/23.
//

import SwiftUI
import Firebase
import UserNotifications

struct mainPage: View {
    @AppStorage ("userid") var userid: String = ""
    @AppStorage ("currentPage") var currentPage = 0
    
    @AppStorage ("faceIDlock") var faceIDlock = false
    @AppStorage ("locksituation") var locksituation = 0 // 1 -> new password | 2 -> normal check | 3 -> cancel password
    @AppStorage ("locksituationB") var locksituationB = false
    
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("colorIF") var colorIF = 0
    
    @AppStorage ("doNotify") var doNotify = false
    @AppStorage ("notifyH") var notifyH = 0
    @AppStorage ("notifyM") var notifyM = 0
    
    @AppStorage ("wifiConnection") var wifiConnection = false
    @AppStorage ("dosync") var dosync = true
    @AppStorage ("loading") var loading = false
    @AppStorage ("anonymous") var anonymous = false
    @AppStorage ("renewtimeG") var renewtimeG = ""
    
    @AppStorage ("tasks0S") var tasks0S = ""
    @AppStorage ("tasks1S") var tasks1S = ""
    @AppStorage ("tasks2S") var tasks2S = ""
    @AppStorage ("tasks3S") var tasks3S = ""
    @AppStorage ("tasks4S") var tasks4S = ""
    @AppStorage ("tasks5S") var tasks5S = ""
    @AppStorage ("tasks6S") var tasks6S = ""
    @AppStorage ("tasks7S") var tasks7S = ""
    @AppStorage ("diaryBookAS") var diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
    
    
    let colorC = [Color.red,.pink,.orange,.yellow,.green,.blue,.purple,.gray]
    let versionS = "1.1.1.20220211(a)"
    
    @State var internetConnectionWarning = false
    @State var logoutCheck = false
    @State var notifyTime = Date()
    @State var textbelow = ""
    
    @StateObject var passwordmodel_ = passwordmodel()
    var body: some View {
        
        TabView(selection: $pagesituation) {
            calendar()
                .tabItem { Label(
                    title:{ Text("Diary") },
                    icon:{ Image(systemName:"calendar") }
                    )
                }
                .tag(1)
            
            
            Form {
//                Section(header: Text("engineer")){
//                    
//                    HStack{
//                        Image(systemName:"command")
//                        Button("|  Tasks"){
//                            print("<<<<<<<<<<<<<<< \"Tasks\" Button Pressed >>>>>>>")
//                            print("diaryBookAS : ", diaryBookAS)
//                            print("task0 : ", tasks0S)
//                            print("task1 : ", tasks1S)
//                            print("task2 : ", tasks2S)
//                            print("task3 : ", tasks3S)
//                            print("task4 : ", tasks4S)
//                            print("task5 : ", tasks5S)
//                            print("task6 : ", tasks6S)
//                            print("task7 : ", tasks7S)
//                        }
//                        .foregroundColor(.primary)
//                        Spacer()
//                        Text("> ")
//                    }
//                    
//                    HStack{
//                        Image(systemName:"command")
//                        Button("|  UPload"){
//                            print("<<<<<<<<<<<<<<< \"Upload\" Button Pressed >>>>>>>")
//                            putData(folder: "test2/category", data: "test")
//                        }
//                        .foregroundColor(.primary)
//                        Spacer()
//                        Text("> ")
//                    }
//                    
//                    HStack{
//                        Image(systemName:"command")
//                        Button("|  Download"){
//                            print("<<<<<<<<<<<<<<< \"Download\" Button Pressed >>>>>>>")
//                            let ada = DiaryDataFirebase()
//                            ada.renew()
//                        }
//                        .foregroundColor(.primary)
//                        Spacer()
//                        Text("> ")
//                    }
//                    
//                }
                
                
                
                Section(header:Text("ACCOUNT")){
                    HStack{
                        Image(systemName:"person")
                        Text("|  " + (Auth.auth().currentUser?.displayName ?? "Anonymous"))
                    }

                    HStack{
                       Image(systemName:"arrow.triangle.2.circlepath")
                       Text("|  Device Sync")
                       Spacer()
                       Toggle(isOn: $dosync ){
                       }
                       .onAppear{
                           if ((Auth.auth().currentUser?.uid ?? "" ).isEmpty) {
                               dosync = false
                           }
                       }
                       .disabled((Auth.auth().currentUser?.displayName ?? "N/A") == "N/A")
                   }
                    
                    HStack {
                        Button("Logout"){
                            logoutCheck = true
                        }
                        .foregroundColor(.red)
                    }
                }

                if logoutCheck {
                    Button("Click Again to Logout"){
                        print("<<<<< \"Click Again to Logout\" Button Pressed >>>>>>>>>>")
                        do{
                            try Auth.auth().signOut()
                            userid = ""
                            currentPage = 0
                        }
                        catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                        tasks0S = ""
                        tasks1S = ""
                        tasks2S = ""
                        tasks3S = ""
                        tasks4S = ""
                        tasks5S = ""
                        tasks6S = ""
                        tasks7S = ""
                        doNotify = false
                        notifyH = 0
                        notifyM = 0
                        locksituation = 0
                        faceIDlock = false
                        colorIF = 0
                        diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
                        pagesituation = 1
                        anonymous = false
                        dosync = true
                        renewtimeG = ""
                    }
                    .foregroundColor(.red)
                }

                
                Section(header:Text("NOTIFICATION"),footer: Text(textbelow)){
                    HStack {
                        Image(systemName:"megaphone")
                        Toggle("|  Notifications", isOn:$doNotify)
                            .onChange(of: doNotify, perform: {value in
                                if doNotify {
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                        if success {
                                            print("All set!")
                                        } else if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    textbelow = "Please select a time to notice you everyday to keep your diary"
                                }
                                else{
                                    UIApplication.shared.cancelAllLocalNotifications()
                                    textbelow = "Turn on to notice you to keep your diary"
                                }
                                
                            })
                    }
                    .onAppear{
                        if doNotify {
                            textbelow = "Please select a time to notice you everyday to keep your diary"
                        }
                        else{
                            textbelow = "Turn on to notice you to keep your diary"
                        }
                    }
                    
                    if (doNotify){
                        HStack{
                            Image(systemName:"clock.arrow.2.circlepath")
                            DatePicker("| Time : ", selection: $notifyTime ,displayedComponents: .hourAndMinute)
                                .datePickerStyle(.automatic)
                                .onChange(of: notifyTime, perform: { value in
                                    UIApplication.shared.cancelAllLocalNotifications()
                                    
                                    let formatter = DateFormatter()
                                    var timecom = DateComponents()
                                    formatter.dateFormat = "HH"
                                    timecom.hour = Int(formatter.string(from: notifyTime))
                                    formatter.dateFormat = "mm"
                                    timecom.minute = Int(formatter.string(from: notifyTime))
                                    
                                    
                                    let content = UNMutableNotificationContent()
                                    content.title = "Diary App"
                                    content.subtitle = "Tap to enter and keep today's diary"
                                    content.sound = UNNotificationSound.default
                                    content.categoryIdentifier = "diary.reminder.everyday"
                                    
                                    print("Notification set on ",timecom.hour ?? 0," : ",timecom.minute ?? 0)
                                    notifyH = timecom.hour ?? 0
                                    notifyM = timecom.minute ?? 0
                                    
                                    timecom.second = 0
                                    
                                    // show this notification five seconds from now
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: timecom, repeats: true)

                                    // choose a random identifier
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                    // add our notification request
                                    UNUserNotificationCenter.current().add(request)
                                    
                                })
                                .onAppear{
                                    if (notifyH != 0 && notifyM != 0){
                                        doNotify = true
                                        let timeString = String(notifyH) + "-" + String(notifyM)
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "HH-mm"
                                        notifyTime = formatter.date(from: timeString) ?? Date()
                                    }
                                }
                        }
                    }
                }
                // TODO Set faceid enable
                Section(header:Text("Security")){
                    HStack{
                       Image(systemName:"lock.fill")
                       Text("|  Password")
                       Spacer()
                       Toggle(isOn: $locksituationB ){
                       }
                       .onChange(of: locksituationB, perform: {newValue in
                           if (locksituationB == true){
                               locksituation = 1
                           }
                           else{
                               locksituation = 3
                           }
                           currentPage = 3
                       })
                    }
                    
                    if (locksituation == 2){
                       HStack{
                           Image(systemName:"faceid")
                           Text("|  FaceID")
                           Spacer()
                           Toggle(isOn: $faceIDlock ){
                           }
                           .onChange(of: faceIDlock, perform: {value in
                               Task{
                                   do{
                                       if faceIDlock {
                                           faceIDlock =  try await passwordmodel_.authenticateser()
                                      }
                                      else {
                                          faceIDlock = false
                                      }
                                   }
                                   catch{
                                       print ("error in faceid in password site")
                                       if faceIDlock {
                                           faceIDlock = false
                                       }
                                       else {
                                           faceIDlock = true
                                       }
                                   }
                               }
                           })
                           .disabled(!passwordmodel_.getBioMetricStatus())
                       }
                    }
                }
                
                Section(header:Text("Customize")){
                    HStack{
                        Image(systemName:"paintpalette")
                        Button("|  Theme"){
                            currentPage = 4
                        }.foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    HStack{
                        Image(systemName:"text.book.closed")
                        Button("|  Diary Book"){
                            if dosync {
                                if wifiConnection  {
                                    currentPage = 5
                                }
                                else {
                                    internetConnectionWarning = true
                                }
                            }
                            else{
                                currentPage = 5
                            }
                        }.foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .alert(isPresented: $internetConnectionWarning) {
                        Alert(
                            title: Text("No Internet Connection"),
                            message: Text("Please connect to internet due to sync is on")
                        )
                    }
                }
                
                Section(header:Text("UPDATE")){
                    HStack{
                        Image(systemName:"v.circle")
                        Text("|  Version")
                        Spacer()
                        Text(versionS)
                    }

                    HStack{
                        Image(systemName:"person")
                        Text("|  Author")
                        Spacer()
                        Text("Sloth workspace")
                    }

                    HStack{
                        Image(systemName:"c.circle")
                        Text("|  copyright")
                        Spacer()
                        Text("©2021 Sloth workspace")
                    }

                }
            }
            .tabItem { Label(
                title:{ Text("Setting") },
                icon:{ Image(systemName:"gearshape")}
            )}.tag(2)
        }
    }
}

extension UNUserNotificationCenter{
    func cleanRepeatingNotifications(){
        //cleans notification with a userinfo key endDate
        //which have expired.
        var cleanStatus = "Cleaning...."
        getPendingNotificationRequests {
            (requests) in
            for request in requests{
                if let endDate = request.content.userInfo["endDate"]{
                    if Date() >= (endDate as! Date){
                        cleanStatus += "Cleaned request"
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(
                             withIdentifiers: [request.identifier])
                    } else {
                        cleanStatus += "No Cleaning"
                    }
                    print(cleanStatus)
                }
            }
        }
    }
}


struct mainPage_Previews: PreviewProvider {
    static var previews: some View {
        mainPage()
    }
}
