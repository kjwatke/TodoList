//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by Kevin Watke on 3/3/22.
//

import UIKit


protocol ListTableViewCellDelegate: class {

	func checkboxToggle(sender:ListTableViewCell)
	
}


class ListTableViewCell: UITableViewCell {
	
	weak var delegate: ListTableViewCellDelegate?
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var checkbox: UIButton!
	
	
	@IBAction func checkboxPressed(_ sender: UIButton) {
	
		delegate?.checkboxToggle(sender: self)
		
	}
	
	
}
