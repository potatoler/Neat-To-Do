//
//  UserData.swift
//  Neat To Do
//
//  Created by potatoler on 2020/9/22.
//

import Foundation

var encoder = JSONEncoder()
var decoder = JSONDecoder()

class ToDo:ObservableObject {
    @Published var ToDoList: [ImportantThing]
    var count = 0
    
    init() {
        self.ToDoList = []
    }
    init(data: [ImportantThing]) {
        self.ToDoList = []
        for item in data {
            self.ToDoList.append(ImportantThing(title: item.title, date: item.date, isChecked: item.isChecked, isFocused: item.isFocused, colour: item.colour, id: self.count))
            count += 1
        }
    }
    
    func Check(id: Int) {
        self.ToDoList[id].isChecked.toggle()
        self.StoreData()
    }
    
    func AddData(data: ImportantThing) {
        self.ToDoList.append(ImportantThing(title: data.title, date: data.date, isFocused: data.isFocused, colour: data.colour, id: self.count))
        self.count += 1
        self.Sort()
        self.StoreData()
    }
    
    func EditCard(id: Int, data: ImportantThing) {
        self.ToDoList[id].title = data.title
        self.ToDoList[id].date = data.date
        self.ToDoList[id].isChecked = data.isChecked
        self.ToDoList[id].isFocused = data.isFocused
        self.ToDoList[id].colour = data.colour
        self.Sort()
        self.StoreData()
    }
    
    func getCNDate(id: Int)-> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let datestr = dformatter.string(from: self.ToDoList[id].date)
        return datestr
     }
    
    func Sort() {
        self.ToDoList.sort(by: {(data1, data2) in
            return data1.date.timeIntervalSince1970 < data2.date.timeIntervalSince1970
        })
        for i in 0..<self.ToDoList.count {
            self.ToDoList[i].id = i
        }
    }
    
    func Delete(id: Int) {
        self.ToDoList[id].deleted = true
        self.Sort()
        self.StoreData()
    }
    
    func StoreData() {
        let dataStored = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.setValue(dataStored, forKey: "ToDoList")
    }
}

struct ImportantThing: Identifiable, Codable {
    var title: String = ""
    var date: Date = Date()
    var isChecked: Bool = false
    var isFocused: Bool = false
    var colour: String = "orange"
    var id: Int = 0
    var deleted = false
}
