//
//  SwiftUIView.swift
//  Neat To Do
//
//  Created by potatoler on 2020/9/22.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var userData: ToDo
    
    @State var title: String = ""
    @State var date: Date = Date()
    @State var isFocused: Bool = false
    @State var colour: String = "orange"
    
    var id: Int? = nil
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("事项设定")) {
                    TextField("待办内容", text: self.$title)
                    DatePicker(selection: self.$date, label: { Text("截止时间") })
                    
                }
                
                Section {
                    Toggle(isOn: self.$isFocused) {
                        Text("特别关注")
                    }
                    HStack {
                        Text("颜色")
                        Spacer()
                        HStack {
                            Image(systemName: self.colour == "pink" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("pink"))
                                .onTapGesture{
                                    self.colour = "pink"
                            }
                            Image(systemName: self.colour == "red" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("red"))
                                .onTapGesture{
                                    self.colour = "red"
                                }
                            Image(systemName: self.colour == "orange" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("orange"))
                                .onTapGesture{
                                    self.colour = "orange"
                                }
                            Image(systemName: self.colour == "yellow" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("yellow"))
                                .onTapGesture{
                                    self.colour = "yellow"
                                }
                            Image(systemName: self.colour == "green" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("green"))
                                .onTapGesture{
                                    self.colour = "green"
                                }
                            Image(systemName: self.colour == "blue" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("blue"))
                                .onTapGesture{
                                    self.colour = "blue"
                                }
                            Image(systemName: self.colour == "indigo" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("indigo"))
                                .onTapGesture{
                                    self.colour = "indigo"
                                }
                            Image(systemName: self.colour == "purple" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("purple"))
                                .onTapGesture{
                                    self.colour = "purple"
                                }
                            Image(systemName: self.colour == "brown" ? "checkmark.circle.fill" : "circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("brown"))
                                .onTapGesture{
                                    self.colour = "brown"
                                }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        if self.id == nil {
                            self.userData.AddData(data: ImportantThing(title: self.title, date: self.date, isFocused: self.isFocused, colour: self.colour))
                        }
                        else {
                            self.userData.EditCard(id: self.id!, data: ImportantThing(title: self.title, date: self.date, isFocused: self.isFocused, colour: self.colour))
                        }
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("确认")
                    }
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("取消")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle(self.id == nil ? "添加待办事项" : self.title)
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
