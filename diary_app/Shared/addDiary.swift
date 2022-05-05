//
//  addDiary.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/30.
//

import SwiftUI
import UIKit

struct addDiary: View {
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("colorIF") var colorIF = 0
    @AppStorage ("diaryBookAS") var diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
    @AppStorage ("newDiary") var newDiary = ""
    @AppStorage ("addDateS") var addDateS = ""
    
    @AppStorage ("editModeB") var editModeB = false
    @AppStorage ("editModeBook") var editModeBook = 0
    @AppStorage ("editModeTitle") var editModeTitle = ""
    @AppStorage ("deleteFuncB") var deleteFuncB = false

    let colorC = [Color.red,.pink,.orange,.yellow,.green,.blue,.purple,.gray,.black]

    @State var diaryBookA = ["Blank","Blank","Blank","Blank","Blank","Blank","Blank","Blank"]
    @State var selectDate = Date()
    @State var typeDiary = ""
    @State var diaryBookSelection = 0
    
    @State var diaryTextWarningNT = false
    @State var diaryTextWarningNL = false
    @State var diaryTextWarningWords = false
    @State var deleteWarning = false
    
    let wordinDiary = 60
    
    var body: some View {
        VStack {
            Text(" ")
            HStack {
                Button{
                    currentPage = 1
                    pagesituation = 1
                }label:{
                    HStack {
                        Text(" ")
                        Image(systemName: "chevron.left")
                        Text(" Back")
                    }
                }.font(.title2)
                Spacer()
                if editModeB{
                    Button("Delete"){
                        //1. Create the alert controller.
                        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this diary?", preferredStyle: .alert)


                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
                        }))
                        let okbutton = UIAlertAction(title: "OK", style: .default, handler: {_ in
                            deleteFuncB = true
                            let formatter = DateFormatter()
                            formatter.dateFormat = "YYYY-MM-dd"
                            let date = formatter.string(from: selectDate)
                            newDiary = date + "^" + String(diaryBookSelection) + "^" + typeDiary
                            print(newDiary)
                            currentPage = 1
                        })
                        okbutton.setValue(UIColor.red, forKey: "titleTextColor")
                        alert.addAction(okbutton)

                        // 4. Present the alert.
                        UIApplication.shared.connectedScenes.filter{
                            $0.activationState == .foregroundActive}
                        .compactMap{
                            $0 as? UIWindowScene
                        }
                        .first?.windows.filter{
                            $0.isKeyWindow
                        }.first?.rootViewController?.present(alert, animated: true, completion: {
                            
                        })
                    }
                    .foregroundColor(Color.red)
                }
                Text(" ")
                Button("Save "){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY-MM-dd"
                    let date = formatter.string(from: selectDate)
                    if (typeDiary == ""){
                        diaryTextWarningNT = true
                    }
                    else if (typeDiary.lengthOfBytes(using: .ascii) > wordinDiary){
                        diaryTextWarningWords = true
                    }
                    else if (typeDiary.contains("\n")){
                        diaryTextWarningNL = true
                    }
                    else{
                        newDiary = date + "^" + String(diaryBookSelection) + "^" + typeDiary
                        print(newDiary)
                        currentPage = 1
                    }
                }
                .onAppear{
                    diaryBookA = diaryBookAS.components(separatedBy: " ")
                    if editModeB {
                        diaryBookSelection = editModeBook
                        typeDiary = editModeTitle
                    }
                    else {
                        for i in 0...7 {
                            if diaryBookA[i] != "Blank"{
                                diaryBookSelection = i
                            }
                        }
                    }
                    
                    if (!addDateS.isEmpty){
                        let formatter = DateFormatter()
                        formatter.dateFormat = "YYYY-MM-dd"
                        selectDate = formatter.date(from: addDateS) ?? Date()
                    }
                }
                Text(" ")
            }
            
            
            VStack{
                VStack{
                    Text("").font(.caption2)
                    Text("Add Diary")
                        .font(.title2)
                    Text(" ").font(.caption2)
                    Divider()
                    HStack{
                        DatePicker(" Date : ", selection: $selectDate,displayedComponents: .date)
                            .datePickerStyle(.automatic)
                        Text(" ")
                    }
                    .font(.title2)
                    .padding(.vertical,5)
                    .disabled(editModeB)
                }
                Divider()
                Text(" ")
                HStack{
                    Text(" Dairy Category : ")
                    Spacer()
                    Circle()
                        .fill(colorC[diaryBookSelection])
                        .frame(width: 12, height: 12)
                    
                    Picker(diaryBookA[diaryBookSelection], selection: $diaryBookSelection) {
                        Text("Please Select a Diary Book")
                        ForEach (0...7,id:\.self){i in
//                            Text(" ")
                            if (diaryBookA[i] != "Blank"){
                                Text(diaryBookA[i]).tag(i)
                                    .onAppear{
                                        diaryBookSelection = i
                                    }
                            }
                        }
                    }
                    .font(.system(size: 30))
                    .foregroundColor(.primary)
                    .disabled(editModeB)
                    
                    Text(" ")
                }.font(.title2)
                Text(" ")
                Divider()
                Text(" ").font(.caption2)
                HStack{
                    Text(" Diary : ")
                        .font(.title2)
                    Spacer()
                }
                    
                HStack{
                    Text(" ")
                        .alert(isPresented: $diaryTextWarningWords) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("Sorry.. Dairy Text cannot has more than \(wordinDiary) character")
                            )
                        }
                    ZStack {
                        TextEditor(text: $typeDiary)
                            .frame(height: 100)
                            .buttonBorderShape(.roundedRectangle(radius: 4))
                            .border(.gray, width: 1)
                            .keyboardType(.asciiCapable)
                            .onChange(of: typeDiary, perform: {value in
                                typeDiary = value.replacingOccurrences(of: "\n", with: " ")
                                if(typeDiary.lengthOfBytes(using: .ascii) > wordinDiary){
                                    typeDiary = typeDiary.substring(to: typeDiary.index(typeDiary.startIndex, offsetBy: wordinDiary))
                                }
                                    
                            })
                            .alert(isPresented: $diaryTextWarningNL) {
                                Alert(
                                    title: Text("Warning"),
                                    message: Text("Dairy Text cannot has nextline")
                                )
                            }
                            
                            
                        
                        if typeDiary == "" {
                            VStack {
                                HStack {
                                    Text("  Less than \(wordinDiary) character")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                Text(" ")
                                Text(" ")
                                Text(" ")
                                    .alert(isPresented: $diaryTextWarningNT) {
                                        Alert(
                                            title: Text("Warning"),
                                            message: Text("Dairy Text must has something")
                                        )
                                    }
//                                Spacer()
                            }
                        }
                    }
                        
                    Text(" ")
                }
            }
            
            
            Spacer()
        }
    }
}

struct addDiary_Previews: PreviewProvider {
    static var previews: some View {
        addDiary()
    }
}
