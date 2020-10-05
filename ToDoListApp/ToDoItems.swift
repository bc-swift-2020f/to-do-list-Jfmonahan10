//
//  ToDoItems.swift
//  ToDoListApp
//
//  Created by James Monahan on 10/5/20.
//  Copyright © 2020 James Monahan. All rights reserved.
//

import Foundation
import UserNotifications

class ToDoItems{
    var itemsArray: [ToDoItem] = []
    func saveData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do{
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch{
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }
    func loadData(completed: @escaping ()->() ){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: documentURL) else{return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            
        } catch {
            print("ERROR: Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
    
    func setNotifications(){
        guard itemsArray.count > 0 else{
            return
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSwitch {
                let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
}
