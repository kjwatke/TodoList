//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by Kevin Watke on 3/3/22.
//

import UIKit


protocol ListTableViewCellDelegate: AnyObject {

	func checkboxToggle(sender:ListTableViewCell)
	
}


class ListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var checkbox: UIButton!
	
	weak var delegate: ListTableViewCellDelegate?
	var todoItem: TodoItem! {
		
		didSet {
			
			titleLabel.text = todoItem.name
			checkbox.isSelected = todoItem.completed
			
		}
		
	}
	
	
	@IBAction func checkboxPressed(_ sender: UIButton) {
	
		delegate?.checkboxToggle(sender: self)
		
	}
	
	
}
