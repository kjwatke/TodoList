//
//  LocalNotificationManager.swift
//  TodoList
//
//  Created by Kevin Watke on 3/4/22.
//

import UserNotifications
import UIKit

struct LocalNotificationManager {
	
	
	static func isAuthorized(completed: @escaping (Bool) -> () ) {
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
			
			guard error == nil else {
				print(error!.localizedDescription)
				completed(false)
				return
			}
			
			if granted {
				print("Notifications Authorization Granted!")
				completed(true)
			}
			else {
				print("The user denied notifications")
				completed(false)
			}
		}
		
	}
	
	
	static func authorizeLocalNotifications(viewController: UIViewController) {
		
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
				
				DispatchQueue.main.async {
					
					viewController.oneButtonAlert(
						withTitle: "User has not allowed notifications",
						withMessage: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications."
					)
				}
				
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
