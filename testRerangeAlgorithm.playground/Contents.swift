import Cocoa
//import SwiftUI

var inS: String = ["2020-10-11", "2020-11-11","2020-11-12","2020-11-10"]
print(inS.count)

if inS.count != 0{
    for i in 0...inS.count-1{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let idate = formatter.date(from: inS[i])
        
        for j in 0...inS.count-1{
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "YYYY-MM-dd"
            let jdate = formatter1.date(from: inS[j])
            
            
            if (idate! < jdate! && (i>j)){
                let temp = inS[i]
                inS[i] = inS[j]
                inS[j] = temp
            }
            
        }
    }
}

print(inS)
