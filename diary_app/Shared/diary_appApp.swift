//
//  diary_appApp.swift
//  Shared
//
//  Created by 陳彥儒 on 2022/1/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import Network

@main
struct diary_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)  var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage ("lock") var lock = true
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("locksituation") var situation = 0 // 1 -> new password | 2 -> normal check // 3 -> cancel password
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("lastcurrentPage") var lastcurrentPage = 0
    @AppStorage ("lefttime") var lefttime = 0
    @AppStorage ("wifiConnection") var wifiConnection = false
    @AppStorage ("anonymous") var anonymous = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        if (situation == 3){
            situation = 2
        }
        else if (situation == 1){
            situation = 0
        }
        
        if (currentPage > 1){
            currentPage = 1
        }
        
        FirebaseApp.configure()
        
        lock = true
        pagesituation = 1
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(renewTimer1), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(renewTimer60), userInfo: nil, repeats: true)
        
        renewTimer60()
        
        return true
    }
    
    private func application(_ application: UIApplication, open url: URL, options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return GIDSignIn.sharedInstance.handle(url);
    }
    
    @objc func renewTimer60(){
//        print ("renew60")
        if !anonymous && Auth.auth().currentUser?.uid != nil {
            let ada = DiaryDataFirebase()
            ada.renew()
        }
    }
    
    @objc func renewTimer1(){
//        print("in1")
        wifiCheckConnection()
    }
    
    
    @objc func wifiCheckConnection(){
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
//                print("Connected")
                wifiConnection = true
            }
            else {
//                print("Not Connected")
                wifiConnection = false
            }
        }
    }
    
    
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
//        print(Int(CACurrentMediaTime()))
        if abs (lefttime - Int(CACurrentMediaTime())) > 5{
            if situation == 2{
                print("but lock")
                lock = true
                currentPage = lastcurrentPage
            }
            else {
                print("not lock due to no lock")
                currentPage = lastcurrentPage
            }
        }
        else {
            print("not lock due to time")
            currentPage = lastcurrentPage
        }
        
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background! screen locked")
        lefttime = Int(CACurrentMediaTime())
        print("lastcurrentPage",lastcurrentPage)
        currentPage = 7
    }
}


