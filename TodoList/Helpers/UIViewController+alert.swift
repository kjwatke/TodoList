//
//  UIViewController+alert.swift
//  TodoList
//
//  Created by Kevin Watke on 3/4/22.
//

import UIKit

extension UIViewController {
	
	
	func oneButtonAlert(withTitle title: String, withMessage message: String) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(defaultAction)
		present(alertController, animated: true, completion: nil)
	}
	
	
}
