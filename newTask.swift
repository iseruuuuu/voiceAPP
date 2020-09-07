//
//  newTask.swift
//  voiceAPP
//
//  Created by user on 2020/09/06.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI

struct newTask: View {
    @State var task: String = ""
    @State var task2: String = ""
    @State var time: Date? = Date()
    @State var category: Int16 = Entity.Category.ImpUrg_1st.rawValue
    var categories: [Entity.Category]
        = [.ImpUrg_1st, .ImpNUrg_2nd, .NImpUrg_3rd, .NImpNUrg_4th, .NImpNUrg_5th, .NImpNUrg_6th]
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func save() {
        do {
            try self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //enviromentは、
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("タスク")) {
                TextField("情報の入力", text: $task)}
                
                
                
                
                
                Section(header: Toggle(isOn: Binding(isNotNil: $time, defaultValue: Date())){Text("時間設定")}) {
                    if time != nil {
                DatePicker(selection: Binding($time, Date()), label: { Text("日時")})
                } else {
                    Text("時間未設定").foregroundColor(.secondary)}}
                
                
                
                
                Picker(selection: $category, label: Text("種類")) {
                    ForEach(categories, id: \.self) { category in
                    HStack {
                        CategoryImage(category)
                        Text(category.toString())
                    }.tag(category.rawValue)}}
                
                
                
                
                Section(header: Text("操作")) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("キャンセル")
                    }.foregroundColor(.red)}}
                
                
                
                
                    Section(header: Text("メモ")) {
                    TextField("メモ", text: $task2)}
                
                
                
            }.navigationBarTitle("内容の追加")
                .navigationBarItems(trailing: Button(action: {
                    Entity.create(in: self.viewContext, category: Entity.Category(rawValue: self.category) ?? .ImpUrg_1st,
                        task: self.task, time: self.time) //task2: self.task
                    
                    
                    
                    
                    
                    self.save()
                    //dismissで画面を閉じる
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
            })
        }
    }
}

struct newTask_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    static var previews: some View {
        newTask()
            .environment(\.managedObjectContext, context)
    }
}
