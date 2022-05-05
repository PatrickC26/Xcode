//
//  calendar.swift
//  diary_app
//
//  Created by 陳彥儒 on 2022/1/26.
//

import SwiftUI
import AVFoundation

struct calendar: View {
    @AppStorage ("colorIF") var colorIF = 0
    @AppStorage ("currentPage") var currentPage = 0
    @AppStorage ("newDiary") var newDiary = ""
    
    @AppStorage ("editModeB") var editModeB = false
    @AppStorage ("editModeBook") var editModeBook = 0
    @AppStorage ("editModeTitle") var editModeTitle = ""
    @AppStorage ("deleteFuncB") var deleteFuncB = false
    
    @AppStorage ("tasks0S") var tasks0S = ""
    @AppStorage ("tasks1S") var tasks1S = ""
    @AppStorage ("tasks2S") var tasks2S = ""
    @AppStorage ("tasks3S") var tasks3S = ""
    @AppStorage ("tasks4S") var tasks4S = ""
    @AppStorage ("tasks5S") var tasks5S = ""
    @AppStorage ("tasks6S") var tasks6S = ""
    @AppStorage ("tasks7S") var tasks7S = ""
    
    @AppStorage ("addDateS") var addDateS = ""
    @AppStorage ("diaryBookAS") var diaryBookAS = "Blank Blank Blank Blank Blank Blank Blank Blank "
    
    @AppStorage ("dosync") var dosync = true
    @AppStorage ("wifiConnection") var wifiConnection = false
    @AppStorage ("loading") var loading = false
    @AppStorage ("anonymous") var anonymous = false
    @AppStorage ("renewtimeG") var renewtimeG = ""
    
    
    let colorC = [Color.red,.pink,.orange,.yellow,.green,.blue,.purple,.gray]
    
    @State var internetConnectionWarning = false
    @State var newDiaryWarningDate = false
    @State var newDiaryWarningReadd = false
    @State var newDiaryWarningNoTheme = false
    @State var currentDate = Date()
    @State var currentMonth = 0
    @State var year = ""
    @State var color = Color.white
    @State var diaryvector = [8,8,8,8]
    @State var diaryLengthArray = [0,0,0,0,0,0,0,0]
    @State var tasks: [[TaskI]] = [[],[],[],[],[],[],[],[]]
    
    var body: some View {
        ZStack {
            VStack{
                // Title bar
                HStack(alignment: .center){
                    VStack(alignment: .leading, spacing: 10){
                        Text(extraDate()[0])
                            .font(.title2)
                        Text(extraDate()[1])
                            .font(.title)
                    }
                    .onAppear{
                        addDateS = ""
                        readData2task()
                        if (newDiary != ""){
                            let date = newDiary.components(separatedBy: "^")[0]
                            let book = newDiary.components(separatedBy: "^")[1]
                            let inside = newDiary.components(separatedBy: "^")[2]
                            print(date)
                            print(book)
                            print(inside)
                            newDiary = ""
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "YYYY-MM-dd"
                            let dateofdiary = formatter.date(from: date) ?? formatter.date(from: "0000-00-00")
                            let date00 = formatter.date(from: "0000-00-00")
                            if date00 == dateofdiary {
                                return
                            }
                            let newDiaryT = TaskI(title: inside, length: 2, taskDate: dateofdiary ?? Date())
//                            print(newDiary)
                            
                            if (Int(book) ?? -1 >= 0 && Int(book) ?? -1 < 8){
                                formatter.dateFormat = "YYYY-MM-dd-HH-mm"
                                renewtimeG = formatter.string(from: Date())
                                print(renewtimeG)
                                
                                if deleteFuncB {
                                    print("delete")
                                    tasks[Int(book)!] = deleteTask(inTA: tasks[Int(book)!], inT: newDiaryT)
                                }
                                else {
                                    print("add")
                                    tasks[Int(book)!] = addTask(inTA: tasks[Int(book)!], inT: newDiaryT)
                                }
//                                print(tasksbook)
                                tasks[Int(book)!] = rearrange(inT: tasks[Int(book)!])
    //                                print(tasksbook)
                                writeTask2Data()
    //                                print(tasksbookS)
                                if dosync {
                                    putData(folder: "Diary/\(book)/data", data: task2data(inT: tasks[Int(book)!]))
                                    putData(folder: "Diary/reT", data: renewtimeG)
                                }
                            }
                            else {
                                newDiaryWarningReadd = true
                            }
                        }
                        deleteFuncB = false
                        editModeB = false
                        editModeBook = 0
                        editModeTitle = ""
                    }
                    .alert(isPresented: $newDiaryWarningReadd) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Please add the diary again due to some error")
                        )
                    }
                        
                    Spacer()
                        .alert(isPresented: $newDiaryWarningDate) {
                            Alert(
                                title: Text("Error"),
                                message: Text("Please add the diary again due to add at same day")
                            )
                        }
                    
                    VStack {
                        HStack{
                            if dosync {
                                Button{
                                    let ada = DiaryDataFirebase()
                                    ada.getEveryDiaryData()
                                }label: {
                                    Image(systemName: "clock.arrow.2.circlepath")
                                        .font(.title2)
                                }
                            }
                            Text(" ")
                            Button{
                                withAnimation{
                                    currentMonth -= 1
                                }
                            }label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                            }
                            
                            Button("Today"){
                                currentDate = Date()
                                currentMonth = 0
                            }
                            
                            Button{
                                withAnimation{
                                    currentMonth += 1
                                }
                            }label: {
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundColor(Color.blue)
                            }
                        }
                    }
                }.padding()
                
                // Which day
                let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
                HStack{
                    ForEach(days,id: \.self){day in
                        Text(day)
                            .font(.callout.bold())
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Day of the week
                let colums = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: colums, spacing: 5){
                    ForEach(extractDate()){value in
                        DateView(value: value)
                            .background(
                                VStack(){
                                    Circle()
                                        .fill(colorC[colorIF])
                                        .padding(.horizontal,3)
                                        .frame(width: 45, height: 45, alignment: .top)
                                        .opacity(isSameDay(d1: value.date, d2: currentDate) ? 1 : 0)
                                    Spacer()
                                }
                            )
                            .onTapGesture {
                                currentDate = value.date
                                let formatter = DateFormatter()
                                formatter.dateFormat = "YYYY-MM-dd"
                                addDateS = formatter.string(from: currentDate)
                                
                            }
                    }
                }
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading){
                        ForEach (0...tasks.count-1, id: \.self){ i in
//                            if tasks.count != 0 {
                                if let task = tasks[i].first(where: { task in
                                    return isSameDay(d1: task.taskDate, d2: currentDate)
                                }){
                                    HStack {
                                        Text (" ")
                                        Circle()
                                            .fill(colorC[i])
                                            .frame(width: 15, height: 15, alignment: .leading)
                                        Text(" ")
                                        VStack{
                                            Text(task.title)
                                        }
                                        Spacer()
                                    }
                                    .onTapGesture {
                                        // TODO set edit method
                                        print(task.title)
                                        editModeB = true
                                        editModeBook = i
                                        editModeTitle = task.title
                                        currentPage = 6
                                    }
                                }
//                            }
                        }
                    }
                }
                Spacer()
                if (loading){
                    Text("")
                        .onAppear{
                            readData2task()
//                            print("loading")
                        }
                        .onDisappear{
                            readData2task()
//                            print("loading")
                        }
                }
            }
            .onChange(of: currentMonth){ newValue in
                //update month
                currentDate = getCurrentMonth()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button{
                        if dosync {
                            if wifiConnection {
                                if diaryBookAS == "Blank Blank Blank Blank Blank Blank Blank Blank "{
                                    newDiaryWarningNoTheme = true
                                }
                                else{
                                    currentPage = 6
                                }
                            }
                            else {
                                internetConnectionWarning = true
                            }
                        }
                        else {
                            if diaryBookAS == "Blank Blank Blank Blank Blank Blank Blank Blank "{
                                newDiaryWarningNoTheme = true
                            }
                            else{
                                currentPage = 6
                            }
                        }
                    }label: {
                        Image(systemName: "plus")
                            .frame(width: 10.0, height: 10.0)
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .background{
                                Circle()
                                    .fill(colorC[colorIF])
                                    .frame(width: 50, height: 50)
                            }
                    }
                    .alert(isPresented: $newDiaryWarningNoTheme) {
                        Alert(
                            title: Text("No Diary Book"),
                            message: Text("Please first add a diary book\ngo to setting -> Diary Book")
                        )
                    }
                    Text("      .")
                        .font(.footnote)
                        .alert(isPresented: $internetConnectionWarning) {
                            Alert(
                                title: Text("No Internet Connection"),
                                message: Text("Please connect to internet due to sync is on")
                            )
                        }
                }
                Text(" ")
            }
        }
    }
    
    @ViewBuilder
    func DateView(value: DateValue) -> some View{
        ZStack {
            VStack{
                if(value.day != -1){
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(d1: value.date, d2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }.padding(.vertical,10)
                .frame(height: 65, alignment: .top)
            VStack{
                if(value.day != -1){
                    Spacer()
                    HStack{
                        ForEach (0...tasks.count-1, id: \.self){ i in
                            if let _ = tasks[i].first(where: { task in
                                return isSameDay(d1: task.taskDate, d2: value.date)
                            }){
                                    Circle()
                                    .fill(colorC[i])
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
//                        if let _ = tasks0.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                                Circle()
//                                .fill(colorC[0])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks1.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[1])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks2.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[2])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks3.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[3])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks4.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[4])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks5.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[5])
//                                .frame(width: 8, height: 8)
//                        }
//                        if let _ = tasks6.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[6])
//                                .frame(width: 8, height: 8)
//                        }
//
//                        if let _ = tasks7.first(where: { task in
//                            return isSameDay(d1: task.taskDate, d2: value.date)
//                        }){
//                            Circle()
//                                .fill(colorC[7])
//                                .frame(width: 8, height: 8)
//                        }
                    }
                    .frame(width: 32)
                           
                }
            }.padding(.vertical,2)
        }
    }
    
    func readData2task(){
        tasks[0] = data2task(inS: tasks0S)
        tasks[1] = data2task(inS: tasks1S)
        tasks[2] = data2task(inS: tasks2S)
        tasks[3] = data2task(inS: tasks3S)
        tasks[4] = data2task(inS: tasks4S)
        tasks[5] = data2task(inS: tasks5S)
        tasks[6] = data2task(inS: tasks6S)
        tasks[7] = data2task(inS: tasks7S)
    }
    
    func writeTask2Data(){
        tasks0S = task2data(inT: tasks[0])
        tasks1S = task2data(inT: tasks[1])
        tasks2S = task2data(inT: tasks[2])
        tasks3S = task2data(inT: tasks[3])
        tasks4S = task2data(inT: tasks[4])
        tasks5S = task2data(inT: tasks[5])
        tasks6S = task2data(inT: tasks[6])
        tasks7S = task2data(inT: tasks[7])
    }
    
    func addTask(inTA: [TaskI], inT: TaskI) -> [TaskI]{
        var out = inTA
        if inTA.count != 0{
            for i in 0...inTA.count-1 {
                if inTA[i].taskDate == inT.taskDate {
                    if !editModeB {
                        newDiaryWarningDate = true
                        return out
                    }
                    else {
                        out[i].title = inT.title
                        return out
                    }
                }
            }
        }
        out.append(inT)
        return out
    }
    
    func deleteTask(inTA: [TaskI], inT: TaskI) -> [TaskI]{
        var out = inTA
        if inTA.count != 0{
            for i in 0...inTA.count-1 {
                if inTA[i].taskDate == inT.taskDate {
                    out.remove(at: i)
                    return out
                }
            }
        }
        return out
    }
    
    func isSameDay(d1 : Date, d2 : Date) -> Bool{
        return Calendar.current.isDate(d1, inSameDayAs: d2)
    }
    
    func getCurrentMonth() -> Date{
        guard let currentMonth = Calendar.current.date(byAdding:.month, value: self.currentMonth, to: Date())else{
                return Date()
            }
        return currentMonth
        
    }
    
    func extraDate() -> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
        
    func extractDate() -> [DateValue]{
        // Get Current month and date
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap{date -> DateValue in
            let day = Calendar.current.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = Calendar.current.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

extension Date{
    func getAllDates() -> [Date]{
        let calendar = Calendar.current
        let startdate = calendar.date(from : calendar.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startdate)!
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value : day-1, to: startdate)!
        }
    }
}

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day : Int
    var date : Date
}

struct TaskI: Identifiable{
    var id = UUID().uuidString
    var title: String
    var length: Int
    var taskDate: Date
}
struct TaskMetaData: Identifiable{
    var id = UUID().uuidString
    var task: [TaskI]
}
func getSampleDate(offset: Int) -> Date{
    let calender = Calendar.current
    let date = calender.date (byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}
    
struct calendar_Previews: PreviewProvider {
    static var previews: some View {
        calendar()
    }
}
