//
//  ViewController.swift
//  TodoList
//
//  Created by Kevin Watke on 2/25/22.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addBarButton: UIBarButtonItem!
	
    var todoArray = [ "Learn Swift", "Build Apps", "Change the World", "Take a Vacation" ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail" {
			let destinationVC = segue.destination as! TodoDetailTableViewController
			let selectedIndexPath = tableView.indexPathForSelectedRow!.row
			
			destinationVC.todoItem = todoArray[selectedIndexPath]
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
			
			todoArray[selectedIndexPath.row] = source.todoItem
			tableView.reloadData()
		}
		else {
			let newIndexPath = IndexPath(row: todoArray.count, section: 0)
			todoArray.append(source.todoItem)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
			tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
		}
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
        
        return todoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = Constants.cellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row]
        
        return cell
    }
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			todoArray.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			
		}
	}
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		let itemToMove = todoArray[sourceIndexPath.row]
		
		todoArray.remove(at: sourceIndexPath.row)
		todoArray.insert(itemToMove, at: destinationIndexPath.row)
	}
    
    
}

