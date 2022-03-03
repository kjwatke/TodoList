//
//  TodoItem.swift
//  TodoList
//
//  Created by Kevin Watke on 2/28/22.
//

import Foundation


struct TodoItem: Codable {
	
	var name: String
	var date: Date
	var notes: String
	var reminderSet: Bool
	var notificationID: String?
	var completed: Bool
	
}
