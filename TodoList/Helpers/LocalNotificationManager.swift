//
//  LocalNotificationManager.swift
//  TodoList
//
//  Created by Kevin Watke on 3/4/22.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
	
	
	static func authorizeLocalNotifications() {
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
			
			guard error == nil else {
				print(error!.localizedDescription)
				return
			}
			
			if granted {
				print("Notifications Authorization Granted!")
			}
			else {
				print("The user denied notifications")
			}
		}
	}
	
	
	static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
		
			// Create content
		
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = subtitle
		content.body = body
		content.sound = sound
		content.badge = badgeNumber
		
			// Create a trigger
		
		var dateComponent = Calendar.current.dateComponents([.year,.month, .day, .hour, .minute], from: date)
		dateComponent.second = 00
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
		
			// Create request
		
		let notificationID = UUID().uuidString
		let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
		
			// register request with the notification center
		UNUserNotificationCenter.current().add(request) { error in
			
			if let error = error {
				
			}
			else {
				
			}
		}
		
		return notificationID
	}
	
	
}
