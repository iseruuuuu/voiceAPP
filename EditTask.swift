//
//  EditTask.swift
//  voiceAPP
//
//  Created by user on 2020/09/07.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI

struct EditTask: View {
    @ObservedObject var todo: Entity
    @State var showingSheet = false
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
    
    fileprivate func delete() {
        viewContext.delete(todo)
        save()
    }
    
    //enviromentは、
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
      
            Form {
                Section(header: Text("タスク")) {
                    TextField("情報の入力", text: Binding($todo.task,"内容の編集"))
                    
                    
                }
                Section(header: Toggle(isOn: Binding(isNotNil: $todo.time, defaultValue: Date())){Text("時間設定")}) {
                    if todo.time != nil {
                        DatePicker(selection: Binding($todo.time, Date()), label: { Text("日時")})
                    } else {
                        Text("時間未設定").foregroundColor(.secondary)
                    }
                }
                Picker(selection: $todo.category, label: Text("種類")) {
                    ForEach(categories, id: \.self) { category in
                    HStack {
                        CategoryImage(category)
                        Text(category.toString())
                    }.tag(category.rawValue)
                }
            }
                
                Section(header: Text("メモ")) {
                               TextField("メモ", text: Binding($todo.task2,"メモ"))
                                   }
                
                
                Section(header: Text("操作")) {
                Button(action: {
                    self.showingSheet = true
                    
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("削除")
                    }.foregroundColor(.red)}}
                
               
                
                
                
    }.navigationBarTitle("内容の編集")
     .navigationBarItems(trailing: Button(action: {
                    self.save()
                    //dismissで画面を閉じる
                    self.presentationMode.wrappedValue.dismiss()
            }) {
            Text("閉じる")
            })
                .actionSheet(isPresented: $showingSheet) {
                    ActionSheet(title: Text("タスクの削除"), message: Text("情報を削除します。よろしいですか？"), buttons: [.destructive(Text("削除")) {
                        self.delete()
                        self.presentationMode.wrappedValue.dismiss()
                        },
                        .cancel(Text(" キャンセル"))
                    ])
        }
    }
}

struct EditTask_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    static var previews: some View {
        let newTodo = Entity(context: context)
        return NavigationView {
            EditTask(todo: newTodo)
            .environment(\.managedObjectContext, context)
        }
    }
}
