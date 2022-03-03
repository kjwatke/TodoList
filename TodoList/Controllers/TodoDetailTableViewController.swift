//
//  TodoDetailTableViewController.swift
//  TodoList
//
//  Created by Kevin Watke on 2/26/22.
//

import UIKit


private let dateFormatter: DateFormatter = {

	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .short
	dateFormatter.timeStyle = .short
	return dateFormatter
	
}()


class TodoDetailTableViewController: UITableViewController {

    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
	@IBOutlet weak var reminderSwitch: UISwitch!
	@IBOutlet weak var dateLabel: UILabel!
	
	
	var todoItem: TodoItem!
	let datePickerIndexPath = IndexPath(row: 1, section: 1)
	let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
	let notesRowHeight: CGFloat = 200
	let defaultRowHeight: CGFloat = 44
	
	
    override func viewDidLoad() {
        
		super.viewDidLoad()
		
		if todoItem == nil {
			todoItem = TodoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
		}
		
		updateUI()
		
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		print("Preparing to unwind from detail...")
		print("todoItem.completed = ", todoItem.completed)
		let completedStatus = todoItem.completed
		todoItem = TodoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: completedStatus)
	}
	
	
	func updateUI() {
		
		nameField.text = todoItem.name
		datePicker.date = todoItem.date
		noteView.text = todoItem.notes
		reminderSwitch.isOn = todoItem.reminderSet
		dateLabel.textColor = reminderSwitch.isOn ? .black : .gray
		dateLabel.text = dateFormatter.string(from: todoItem.date)
		
	}
    
    
    // MARK: - @IBAction Methods
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
        
    }
	
	
	@IBAction func reminderSwitchFlipped(_ sender: UISwitch) {
		
		dateLabel.textColor = reminderSwitch.isOn ? .black : .gray
		tableView.beginUpdates()
		tableView.endUpdates()
		
	}
	
	
	@IBAction func datePickerChanged(_ sender: UIDatePicker) {
		
		dateLabel.text = dateFormatter.string(from: sender.date)
		
	}
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}


extension TodoDetailTableViewController  {
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		switch indexPath {
			case datePickerIndexPath:
				return reminderSwitch.isOn ? datePicker.frame.height : 0
			case notesTextViewIndexPath:
				return notesRowHeight
			default:
				return defaultRowHeight
		}
	}
}
