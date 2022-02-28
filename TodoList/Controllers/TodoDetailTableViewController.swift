//
//  TodoDetailTableViewController.swift
//  TodoList
//
//  Created by Kevin Watke on 2/26/22.
//

import UIKit

class TodoDetailTableViewController: UITableViewController {

    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
	
	var todoItem: String!
	
    override func viewDidLoad() {
        
		super.viewDidLoad()
		
		if todoItem == nil {
			todoItem = ""
		}
		
		nameField.text = todoItem
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		todoItem = nameField.text!
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
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}
