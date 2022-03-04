//
//  ViewController.swift
//  TodoList
//
//  Created by Kevin Watke on 2/25/22.
//

import UIKit
import UserNotifications


class ToDoListViewController: UIViewController {
	
	
    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addBarButton: UIBarButtonItem!
	
	var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
		
		loadData()
		authorizeLocalNotifications()
        
    }
	
	
	func setNotifications() {
		
		guard todoItems.count > 0 else {
			return
		}
		
		// Remove all notifications
		
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		
		// lets re-create them with the updated data that we just saved
		
		for index in 0..<todoItems.count {
			
			if todoItems[index].reminderSet {
				
				let todo = todoItems[index]
				todoItems[index].notificationID = setCalendarNotification(
					title: todo.name , subtitle: "Subtitle goes here", body: todo.notes, badgeNumber: nil, sound: .default, date: todo.date)
			}
		}
	}
	
	
	func authorizeLocalNotifications() {
		
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
	
	
	func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
	
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
	
	
	func loadData() {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		guard let data = try? Data(contentsOf: documentURL) else { return }
		
		let jsonDecoder = JSONDecoder()
		
		do {
			todoItems = try jsonDecoder.decode(Array<TodoItem>.self, from: data)
			tableView.reloadData()
		} catch  {
			print(error.localizedDescription)
		}
	}
	
	
	func saveData() {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		let jsonEncoder = JSONEncoder()
		let data = try? jsonEncoder.encode(todoItems)
		
		do {
			try data?.write(to: documentURL, options: .noFileProtection)
		}
		catch {
			print(error.localizedDescription)
		}
		
		setNotifications()
	}

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "ShowDetail" {
			let destinationVC = segue.destination as! TodoDetailTableViewController
			let selectedIndexPath = tableView.indexPathForSelectedRow!
			
			destinationVC.todoItem = todoItems[selectedIndexPath.row]
		}
		else {
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				tableView.deselectRow(at: selectedIndexPath, animated: true)
			}
		}
	}
	
	
	@IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
		
		let source = segue.source as! TodoDetailTableViewController
	
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			
			todoItems[selectedIndexPath.row] = source.todoItem

		}
		else {
			let newIndexPath = IndexPath(row: todoItems.count, section: 0)
			todoItems.append(source.todoItem)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
			tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
		}
		
		saveData()
	}
	
	
	@IBAction func editPressed(_ sender: UIBarButtonItem) {
		
		if tableView.isEditing {
			tableView.setEditing(false, animated: true)
			sender.title = "Edit"
			addBarButton.isEnabled = true
		}
		else {
			tableView.setEditing(true, animated: true)
			sender.title = "Done"
			addBarButton.isEnabled = false
		}
	}
	
}

// MARK: - UITableViewDelegate and UITableViewDataSource Methods

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        let id = Constants.cellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ListTableViewCell
		cell.delegate = self
		cell.todoItem = todoItems[indexPath.row]

        return cell
		
    }
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			todoItems.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveData()
			
		}
		
	}
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		let itemToMove = todoItems[sourceIndexPath.row]
		
		todoItems.remove(at: sourceIndexPath.row)
		todoItems.insert(itemToMove, at: destinationIndexPath.row)
		
		saveData()
		
	}
    
    
}


extension ToDoListViewController: ListTableViewCellDelegate {
	
	
	func checkboxToggle(sender: ListTableViewCell) {
		
		if let selectedIndexPath = tableView.indexPath(for: sender) {
			
			todoItems[selectedIndexPath.row].completed = !todoItems[selectedIndexPath.row].completed
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
			
			saveData()
			
		}
	}
	
	
}

