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
	
	var todoItems = TodoItems()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
		
		todoItems.loadData { [weak self] in
			
			guard let self = self else { return }
			
			self.tableView.reloadData()
		}
		
		LocalNotificationManager.authorizeLocalNotifications(viewController: self)
        
    }

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "ShowDetail" {
			let destinationVC = segue.destination as! TodoDetailTableViewController
			let selectedIndexPath = tableView.indexPathForSelectedRow!
			
			destinationVC.todoItem = todoItems.itemsArray[selectedIndexPath.row]
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
			
			todoItems.itemsArray[selectedIndexPath.row] = source.todoItem
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)

		}
		else {
			let newIndexPath = IndexPath(row: todoItems.itemsArray.count, section: 0)
			todoItems.itemsArray.append(source.todoItem)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
			tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
		}
		
		todoItems.saveData()
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
        
		return todoItems.itemsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        let id = Constants.cellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ListTableViewCell
		cell.delegate = self
		cell.todoItem = todoItems.itemsArray[indexPath.row]

        return cell
		
    }
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			todoItems.itemsArray.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			todoItems.saveData()
			
		}
		
	}
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		let itemToMove = todoItems.itemsArray[sourceIndexPath.row]
		
		todoItems.itemsArray.remove(at: sourceIndexPath.row)
		todoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
		
		todoItems.saveData()
		
	}
    
    
}


extension ToDoListViewController: ListTableViewCellDelegate {
	
	
	func checkboxToggle(sender: ListTableViewCell) {
		
		if let selectedIndexPath = tableView.indexPath(for: sender) {
			
			todoItems.itemsArray[selectedIndexPath.row].completed = !todoItems.itemsArray[selectedIndexPath.row].completed
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
			
			todoItems.saveData()
			
		}
	}
	
	
}

