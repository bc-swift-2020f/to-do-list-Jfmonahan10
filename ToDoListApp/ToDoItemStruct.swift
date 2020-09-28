//
//  ToDoItemStruct.swift
//  ToDoListApp
//
//  Created by James Monahan on 9/28/20.
//  Copyright © 2020 James Monahan. All rights reserved.
//

import Foundation

struct ToDoItem: Codable{
    var name: String
    var date: Date
    var notes: String
    var reminderSwitch: Bool
}
