//
//  diaryCategory.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/27.
//

import SwiftUI
import Firebase

struct diaryCategory: View {
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("diaryBookAS") var diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
    
    @AppStorage ("tasks0S") var tasks0S = ""
    @AppStorage ("tasks1S") var tasks1S = ""
    @AppStorage ("tasks2S") var tasks2S = ""
    @AppStorage ("tasks3S") var tasks3S = ""
    @AppStorage ("tasks4S") var tasks4S = ""
    @AppStorage ("tasks5S") var tasks5S = ""
    @AppStorage ("tasks6S") var tasks6S = ""
    @AppStorage ("tasks7S") var tasks7S = ""
    
    @AppStorage ("dosync") var dosync = true
    
    @State var deleteAlert = false
    @State var diaryBookA = ["Blank","Blank","Blank","Blank","Blank","Blank","Blank","Blank"]
    @State var deleteAI = 0
    @State var newArriveWarning = false
    func saveAToS(){
        diaryBookAS = ""
        for i in 0...7 {
            diaryBookAS += diaryBookA[i]
            diaryBookAS += " "
        }
        print(diaryBookAS)
        if dosync {
            putData(folder: "Diary/category", data: diaryBookAS)
        }
    }
    var body: some View {
        VStack {
            Text(" ")
            HStack {
                Button{
                    currentPage = 1
                    pagesituation = 2
                }label:{
                    HStack {
                        Text(" ")
                        Image(systemName: "chevron.left")
                        Text(" Back")
                    }
                }.font(.title2)
                .alert(isPresented: $newArriveWarning) {
                    Alert(
                        title: Text("To add a diary book"),
                        message: Text("Press on any row to add a Diary Book")
                    )
                }
                .onAppear{
                    if diaryBookAS == "Blank Blank Blank Blank Blank Blank Blank Blank"{
                        newArriveWarning = true
                    }
                }
                Spacer()
            }
            let colorI = [0,1,2,3,4,5,6,7]
            let colorC = [Color.red,.pink,.orange,.yellow,.green,.blue,.purple,.gray]
            
            VStack{
                Text("")
                Text("")
                Text("Diary Book")
                    .font(.title2)
                ForEach (colorI , id: \.self) { i in
                    HStack{
                        Button{
                            //1. Create the alert controller.
                            let alert = UIAlertController(title: "Rename Diary Book", message: "Enter a name\nLeave blank if delete this Diary Book", preferredStyle: .alert)

                            //2. Add the text field. You can configure it however you need.
                            alert.addTextField { (textField) in
                                textField.placeholder = "Ex : Work, Study ... etc"
                            }

                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
                            }))
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                                print("Text field: \(String(describing: textField?.text))")
                                if (textField?.text == ""){
                                    deleteAI = i
                                    deleteAlert = true
                                }
                                else{
                                    diaryBookA[i] = textField?.text ?? "Blank"
                                    diaryBookA[i] = diaryBookA[i].replacingOccurrences(of: " ", with: "")
                                    saveAToS()
                                }
                            }))

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
                        }label: {
                            Text(" ")
                            Circle()
                                .fill(colorC[i])
                                .frame(width: 10, height: 10)
                            Text(" ")
                            Text(diaryBookA[i])
                            Spacer()
                        }.font(.title3)
                        .alert(isPresented: $deleteAlert) {
                            Alert(
                                title: Text("DELETE"),
                                message: Text("Are you sure you want to delete\nAll Diary in this book(\(diaryBookA[deleteAI])) will be delete"),
                                primaryButton: .default(
                                    Text("Cancal"),
                                    action: {
                                        
                                    }
                                ),
                                secondaryButton: .destructive(
                                    Text("YES"),
                                    action: {
                                        diaryBookA[deleteAI] = "Blank"
                                        saveAToS()
                                        switch (deleteAI){
                                        case 0 :
                                            tasks0S = ""
                                            break
                                        case 1 :
                                            tasks1S = ""
                                            break
                                        case 2 :
                                            tasks2S = ""
                                            break
                                        case 3 :
                                            tasks3S = ""
                                            break
                                        case 4 :
                                            tasks4S = ""
                                            break
                                        case 5 :
                                            tasks5S = ""
                                            break
                                        case 6 :
                                            tasks6S = ""
                                            break
                                        case 7 :
                                            tasks7S = ""
                                            break
                                        default:
                                            break
                                        }
                                        Database.database().reference().child(Auth.auth().currentUser?.uid ?? " ").child("Diary").child(String(deleteAI)).removeValue()
                                    }
                                )
                            )
                        }
//                        Spacer()
                    }
                    .foregroundColor(colorC[i])
                    Divider()
                }
            }
            .onAppear{
                diaryBookA = diaryBookAS.components(separatedBy: " ")
            }
            
            Spacer()
        }
    }
}

struct diaryCategory_Previews: PreviewProvider {
    static var previews: some View {
        diaryCategory()
    }
}
