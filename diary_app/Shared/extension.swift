//
//  extension.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/28.
//

import Foundation
import Firebase
import SwiftUI

struct DiaryDataFirebase {
    @AppStorage ("tasks0S") var diary0 = ""
    @AppStorage ("tasks1S") var diary1 = ""
    @AppStorage ("tasks2S") var diary2 = ""
    @AppStorage ("tasks3S") var diary3 = ""
    @AppStorage ("tasks4S") var diary4 = ""
    @AppStorage ("tasks5S") var diary5 = ""
    @AppStorage ("tasks6S") var diary6 = ""
    @AppStorage ("tasks7S") var diary7 = ""
    
    @AppStorage ("loading") var loading = true
    @AppStorage ("diaryBookAS") var diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
    
    @AppStorage ("dosync") var dosync = true
    @AppStorage ("wifiConnection") var wifiConnection = false
    @AppStorage ("renewtimeG") var renewtimeG = ""
    
    @State var ymIA = [[String]]()
    @State var firstyear = 0
    @State var testS = ""
    
    enum funcType: Int {
        case add = 1
        case overwrite = 2
    }
    
    func editAppStoragediaryS(target: Int, editItem: String, funcTypeI: Int){
        if (funcTypeI == 1){
            switch target {
                case 0:
                diary0 += editItem
                break
                case 1:
                diary1 += editItem
                break
                case 2:
                diary2 += editItem
                break
                case 3:
                diary3 += editItem
                break
                case 4:
                diary4 += editItem
                break
                case 5:
                diary5 += editItem
                break
                case 6:
                diary6 += editItem
                break
                case 7:
                diary7 += editItem
                break
                default:
                break
            }
        }
        else if (funcTypeI == 2){
            switch target {
                case 0:
                diary0 = editItem
                break
                case 1:
                diary1 = editItem
                break
                case 2:
                diary2 = editItem
                break
                case 3:
                diary3 = editItem
                break
                case 4:
                diary4 = editItem
                break
                case 5:
                diary5 = editItem
                break
                case 6:
                diary6 = editItem
                break
                case 7:
                diary7 = editItem
                break
                default:
                break
            }
        }
    }
    
    func getDiaryRenewTime(){
        Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child("Diary").child("reT").observeSingleEvent(of: .value, with: {snapshot in
            let getS = snapshot.value as? String ?? ""
            print(getS)
            if renewtimeG != getS {
                getEveryDiaryData()
                renewtimeG = getS
            }
            else {
                loading = false
            }
        })
    }
    
    func getEveryDiaryData(){
        loading = true
        getDiaryCategory()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            let diaryA = diaryBookAS.components(separatedBy: " ")
            for i in 0...7 {
                if diaryA[i] != "Blank"{
                    print("i",i)
                    getDiaryData(folder: String(i))
                }
                else {
                    editAppStoragediaryS(target: i, editItem: "", funcTypeI: funcType.overwrite.rawValue)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                loading = false
            }
        }
    }
    
    func getDiaryCategory(){
        Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child("Diary").child("category").observeSingleEvent(of: .value, with: {snapshot in
            let getS = snapshot.value as? String ?? ""
            print(getS)
            diaryBookAS = getS
        })
    }
    
    func getDiaryData(folder: String){
        Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child("Diary").child(folder).child("dataAmount").observeSingleEvent(of: .value, with: {snapshot in
            let getamount = Int(snapshot.value as? String ?? "0") ?? 0
            print(getamount)
            if getamount != 0 {
                editAppStoragediaryS(target: Int(folder) ?? -1, editItem: "", funcTypeI: funcType.overwrite.rawValue)
            }
            else{
                return
            }
            for i in 1...getamount{
                Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child("Diary").child("\(folder)/data").child(String(i)).observeSingleEvent(of: .value, with: {snapshot in
                    let getS = snapshot.value as? String ?? ""
                    print(getS)
                    editAppStoragediaryS(target: Int(folder) ?? -1, editItem: getS, funcTypeI: funcType.add.rawValue)
                })
            }
        })
    }
    
    func renew(){
        if dosync && wifiConnection {
            loading = true
            getDiaryRenewTime()
//            print("IN")
//            getEveryDiaryData()
//            print("OUT")
            
        }
    }
    
    
    
}

func putData(folder: String, data: String){
    print("Enter put data")
    if folder.contains("data"){
        if data.count > 40000{
            var sendS = data
            var dataAmount = 0
            print("enter while")
            while !sendS.isEmpty {
                print(dataAmount)
                dataAmount += 1
                var sendSnow = ""
                if sendS.count < 40000{
                    sendSnow = sendS.substring(to: sendS.index(sendS.startIndex,offsetBy: sendS.count))
                    sendS = ""
                }
                else{
                    sendSnow = sendS.substring(to: sendS.index(sendS.startIndex, offsetBy: 40000))
                    sendS = sendS.substring(from: sendS.index(sendS.startIndex, offsetBy: 40000))
                }
                Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child(folder).child(String(dataAmount)).setValue(sendSnow)
            }
            Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child(folder).parent?.child("dataAmount").setValue(String(dataAmount))
        }
        else{
            Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child(folder).child("1").setValue(data)
            Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child(folder).parent?.child("dataAmount").setValue("1")
        }
    }
    else{
        print("Normal Put")
        Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child(folder).setValue(data)
    }
    
}

func data2task(inS: String) -> [TaskI]{
    // year<month>date^diary>date^diary<month>date;
    // 2020<12>01^happy>02^sad;2021<01>01^OK>02^fine<04>01^good
    var finalTask: [TaskI] = []
//    print(inS)
    
    if (inS == "" ){
        return []
    }
    
    let yearArray = inS.components(separatedBy: ";")
    for i in yearArray {
        if (i == "" ){
            return []
        }
        let currenetyear = i.substring(to: i.index(i.startIndex,offsetBy: 4))
//        print()
        
        let monthArray = i.substring(from: i.index(i.startIndex,offsetBy: 5)).components(separatedBy: "<")
//        print(monthArray)
        for j in monthArray {
            if (j == "" ){
                return []
            }
            let currenetmonth = j.substring(to: j.index(j.startIndex,offsetBy: 2))
//            print()
            let dayArray = j.substring(from: j.index(j.startIndex,offsetBy: 3)).components(separatedBy: ">")
//            print(dayArray)
            for k in dayArray {
                if (k == "" ){
                    return []
                }
                let currenetday = k.substring(to: k.index(k.startIndex,offsetBy: 2))
                if (Int(currenetmonth) ?? 0 > 12 || Int(currenetmonth) ?? 0 < 1 || Int(currenetday) ?? 0 > 31 || Int(currenetday) ?? 0 < 1){
                    return []
                }
                let dateS = currenetyear + "-" + currenetmonth + "-" + currenetday
//                print(dateS)
                let note = k.substring(from: k.index(k.startIndex,offsetBy: 3)).components(separatedBy: "^")
//                print(note)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd"
                
                let dateTemp = formatter.date(from: dateS)!
//                print(dateTemp)
                
                let temp = TaskI(title: note[0], length: 2, taskDate: dateTemp)
                
                finalTask.append(temp)
            }
        }
    }
//    print(finalTask)
    
    return finalTask
}

func task2data(inT: [TaskI]) -> String{
    // year<month>date^diary>date^diary<month>date;
    // 2020<12>01^happy>02^sad;2021<01>01^OK>02^fine<04>01^good
    var out = ""
    var currentYear = "0"
    var currentMonth = "0"
    for i in inT {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let iyear = formatter.string(from: i.taskDate)
        
        formatter.dateFormat = "MM"
        let imonth = formatter.string(from: i.taskDate)
        
        formatter.dateFormat = "dd"
        let idate = formatter.string(from: i.taskDate)
        
        if currentYear == "0" {
            currentYear = iyear
            out += iyear
        }
        else if currentYear != iyear {
            currentYear = iyear
            out += ";"
            currentMonth = "0"
            out += iyear
        }
        
        if currentMonth != imonth {
            out += "<"
            currentMonth = imonth
            out += imonth
        }
        
        out += ">"
        out += idate
        out += "^"
        out += i.title
    }
    
    return out
}




func rearrange(inT: [TaskI]) -> [TaskI]{
    var tempT = inT
    if inT.count != 0 {
        for i in 0...inT.count-1{
            for j in 0...inT.count-1{
                if (tempT[i].taskDate < tempT[j].taskDate && (i>j)){
                    let temp = tempT[i]
                    tempT[i] = tempT[j]
                    tempT[j] = temp
                }
            }
        }
    }
    return tempT
}


