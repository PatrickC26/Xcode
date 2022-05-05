//
//  Theme.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/27.
//

import SwiftUI

struct Theme: View {
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("pagesituation") var pagesituation = 1 // 1 -> 1 | 2 -> 2
    @AppStorage ("colorIF") var colorIF = 0
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
                Spacer()
            }
            
            let colorS = ["Red","Pink","Orange","Yellow","Green","Blue","Purple","Gray"]
            let colorI = [0,1,2,3,4,5,6,7]
            let colorC = [Color.red,.pink,.orange,.yellow,.green,.blue,.purple,.gray]
            
            VStack{
                Text("")
                Text("")
                Text("Theme")
                    .font(.title2)
                ForEach (colorI , id: \.self) { i in
                    HStack{
                        Button{
                            colorIF = colorI[i]
                        }label: {
                            Text(" ")
                            Circle()
                                .fill(colorC[i])
                                .frame(width: 10, height: 10)
                            Text(" ")
                            Text(colorS[i])
//                            Text("                     .")
                            Spacer()
                        }.font(.title3)
//                        Spacer()
                    }
                    .foregroundColor(colorC[i])
                    Divider()
                }
            }
            
            Spacer()
        }
    }
}

struct Theme_Previews: PreviewProvider {
    static var previews: some View {
        Theme()
    }
}
