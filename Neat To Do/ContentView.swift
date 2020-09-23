//
//  ContentView.swift
//  Neat To Do
//
//  Created by potatoler on 2020/9/21.
//

import SwiftUI

func InitUserData() -> [ImportantThing] {
    var output: [ImportantThing] = []
    if let dataStored = UserDefaults.standard.object(forKey: "ToDoList") as? Data{
        let data = try! decoder.decode([ImportantThing].self, from: dataStored)
        for item in data{
            if !item.deleted {
                output.append(ImportantThing(title: item.title, date: item.date, isChecked: item.isChecked, id: output.count))
            }
        }
    }
    return output
}

struct ContentView: View {
    
    @ObservedObject var userData: ToDo = ToDo(data: InitUserData())
    @State var showEditingPage = false
    @State var selection: [Int] = []
    @State var editingMode = false
    @State var showTop = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true){
                VStack {
                    ForEach(self.userData.ToDoList) {item in
                        if !item.deleted {
                            if !self.showTop || item.isFocused {
                                SingleCardView(index: item.id, editingMode: self.$editingMode, selection: self.$selection, showTop: self.$showTop)
                                    .environmentObject(self.userData)
                                    .padding([.top, .leading, .trailing], 15)
                                    .animation(.spring())
                                    .transition(.slide)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(!self.showTop ? "待办事项" : "特别关注")
            .navigationBarItems(trailing:
                HStack(spacing: 20) {
                    if self.editingMode {
                        DeleteButton(selection: self.$selection, editingMode: self.$editingMode)
                            .environmentObject(self.userData)
                        MoveTopButton(selection: self.$selection, editingMode: self.$editingMode)
                            .environmentObject(self.userData)
                    }
                    if !self.editingMode {
                        ShowTopButton(showTop: self.$showTop)
                        AddButton(showEditingPage: self.$showEditingPage)
                            .environmentObject(self.userData)
                    }
                    EditingButton(editingMode: self.$editingMode, selection: self.$selection)
                }
            )
        }
    }
}

struct EditingButton: View {
    
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    
    var body: some View {
        Button(action: {
            self.editingMode.toggle()
            self.selection.removeAll()
        }) {
            Image(systemName: "text.badge.checkmark")
                .imageScale(.large)
        }
    }
}

struct DeleteButton: View {
    
    @Binding var selection: [Int]
    @EnvironmentObject var userData: ToDo
    @Binding var editingMode: Bool
    
    var body: some View {
        Button(action: {
            for i in self.selection {
                userData.Delete(id: i)
            }
            self.editingMode = false
        }){
            Image(systemName: "trash")
                .imageScale(.large)
                .foregroundColor(.red)
        }
    }
}

struct MoveTopButton: View {
    
    @EnvironmentObject var userData: ToDo
    @Binding var selection: [Int]
    @Binding var editingMode: Bool
    
    var body: some View {
        Image(systemName: "star.lefthalf.fill")
            .imageScale(.large)
            .foregroundColor(.yellow)
            .onTapGesture {
                for i in self.selection{
                    self.userData.ToDoList[i].isFocused.toggle()
                }
                self.editingMode = false
            }
    }
}

struct ShowTopButton: View {
    
    @Binding var showTop: Bool
    
    var body: some View {
        Button(action: {
            self.showTop.toggle()
        }){
            Image(systemName: self.showTop ? "star.fill" : "star")
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}

struct AddButton: View {
    
    @Binding var showEditingPage: Bool
    @EnvironmentObject var userData: ToDo
    
    var body: some View {
        Button(action: {
            self.showEditingPage = true
        }){
            Image(systemName: "square.and.pencil")
                .imageScale(.large)
                .foregroundColor(.orange)
        }
        .sheet(isPresented: self.$showEditingPage, content: {
            EditingPage()
                .environmentObject(self.userData)
        })
        .shadow(radius: 0, x:0, y:0)
    }
}
struct SingleCardView: View {
    
    @EnvironmentObject var userData: ToDo
    var index: Int
    
    @State var showEditingPage = false
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    @Binding var showTop: Bool
    
    var body: some View {
        VStack {
            HStack {
                
                Rectangle()
                    .frame(width: 10)
                    .foregroundColor(Color(self.userData.ToDoList[self.index].colour))
                
                if self.editingMode {
                    Button(action: {
                        self.userData.Delete(id: self.index)
                        self.editingMode = false
                    }){
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .padding(.leading)
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: {
                    if !self.editingMode {
                        self.showEditingPage = true
                    }
                }) {
                    Group {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(self.userData.ToDoList[index].title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text(self.userData.getCNDate(id: index))
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                }
                .sheet(isPresented: self.$showEditingPage, content: {
                    EditingPage(title: self.userData.ToDoList[self.index].title,
                                date: self.userData.ToDoList[self.index].date,
                                isFocused: self.userData.ToDoList[self.index].isFocused,
                                id: self.index)
                        .environmentObject(self.userData)
                })
                
                if !self.showTop && self.userData.ToDoList[self.index].isFocused {
                    Image(systemName: "star.fill")
                        .imageScale(.medium)
                        .foregroundColor(.yellow)
                }
                
                if !self.editingMode {
                    Image(systemName: self.userData.ToDoList[index].isChecked ? "checkmark.square" : "square")
                        .imageScale(.large)
                        .padding(.trailing)
                        .onTapGesture {
                            self.userData.Check(id: self.index)
                        }
                }
                else {
                    Image(systemName: self.selection.firstIndex(where: {$0 == self.index}) == nil ?  "circle" : "checkmark.circle.fill")
                        .imageScale(.large)
                        .padding(.trailing)
                        .onTapGesture{
                            if self.selection.firstIndex(where: {
                                $0 == self.index
                            }) == nil {
                                self.selection.append(self.index)
                            }
                            else{
                                self.selection.remove(at:
                                    self.selection.firstIndex(where: {
                                    $0 == self.index
                                })!)
                            }
                        }
                }
            }
            .frame(height: 80)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5, x:0, y:5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userData: ToDo(data: [ImportantThing(title: "交钱给英语课代表", date: Date(), colour: "orange"),
                                          ImportantThing(title: "回去上生物课", date: Date(), colour: "blue"),
                                          ImportantThing(title: "写昨天T4", date:Date(), colour: "yellow"),
                                          ImportantThing(title: "考试", date: Date(), colour: "green"),
                                          ImportantThing(title: "完成 Project NTD", date: Date(), colour: "brown")
                               
        ]))
    }
}
