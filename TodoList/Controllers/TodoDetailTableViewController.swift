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
		
		
		// Handle keyboard if we tap outside of a field
		
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		nameField.delegate = self
		
		if todoItem == nil {
			todoItem = TodoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
			nameField.becomeFirstResponder()
		}
		
		updateUI()
		
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		print("Preparing to unwind from detail...")
		print("todoItem.completed = ", todoItem.completed)
		let completedStatus = todoItem.completed
		todoItem = TodoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: completedStatus)
		
	}
	
	
	func enableDisableSaveButton(text: String) {
		
		if text.count > 0 {
			saveBarButton.isEnabled = true
		}
		else {
			saveBarButton.isEnabled = false
		}
		
	}
	
	
	func updateUI() {
		
		nameField.text = todoItem.name
		datePicker.date = todoItem.date
		noteView.text = todoItem.notes
		reminderSwitch.isOn = todoItem.reminderSet
		dateLabel.textColor = reminderSwitch.isOn ? .black : .gray
		dateLabel.text = dateFormatter.string(from: todoItem.date)
		enableDisableSaveButton(text: nameField.text!)
		
	}
	
	
	func updateReminderSwitch() {
		
		LocalNotificationManager.isAuthorized { [weak self] authorized in
			
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				if !authorized && self.reminderSwitch.isOn {
					self.oneButtonAlert(
						withTitle: "User Has Not Allowed Notifications",
						withMessage: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications")
					self.reminderSwitch.isOn = false
				}
				
				self.view.endEditing(true)
				self.dateLabel.textColor = self.reminderSwitch.isOn ? .black : .gray
				self.tableView.beginUpdates()
				self.tableView.endUpdates()
			}
		}
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
		self.updateReminderSwitch()
	}
	
	
	@IBAction func datePickerChanged(_ sender: UIDatePicker) {
		view.endEditing(true)
		dateLabel.text = dateFormatter.string(from: sender.date)
	}
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
	
	
	@IBAction func textFieldEditingChanged(_ sender: UITextField) {
		enableDisableSaveButton(text: sender.text!)
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


extension TodoDetailTableViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		noteView.becomeFirstResponder()
		return true
	}
	
}
