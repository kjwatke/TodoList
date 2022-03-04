//
//  TodoItems.swift
//  TodoList
//
//  Created by Kevin Watke on 3/4/22.
//

import Foundation
import UserNotifications

class TodoItems {
	
	var itemsArray: [TodoItem] = []
	
	
	func loadData(completed: @escaping () -> () ) {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		guard let data = try? Data(contentsOf: documentURL) else { return }
		
		let jsonDecoder = JSONDecoder()
		
		do {
			itemsArray = try jsonDecoder.decode(Array<TodoItem>.self, from: data)
		} catch  {
			print(error.localizedDescription)
		}
		
		completed()
		
	}
	
	
	func saveData() {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		let jsonEncoder = JSONEncoder()
		let data = try? jsonEncoder.encode(itemsArray)
		
		do {
			try data?.write(to: documentURL, options: .noFileProtection)
		}
		catch {
			print(error.localizedDescription)
		}
		
		setNotifications()
		
	}
	
	
	func setNotifications() {
		
		guard itemsArray.count > 0 else {
			return
		}
		
			// Remove all notifications
		
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		
			// lets re-create them with the updated data that we just saved
		
		for index in 0..<itemsArray.count {
			
			if itemsArray[index].reminderSet {
				
				let todo = itemsArray[index]
				itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(
					title: todo.name , subtitle: "Subtitle goes here", body: todo.notes, badgeNumber: nil, sound: .default, date: todo.date)
			}
		}
	}
	
	
}
