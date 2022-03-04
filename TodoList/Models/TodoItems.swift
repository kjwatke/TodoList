//
//  TodoItems.swift
//  TodoList
//
//  Created by Kevin Watke on 3/4/22.
//

import Foundation

class TodoItems {
	
	var itemsArray: [TodoItem] = []
	
	
	func saveData() {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		let jsonEncoder = JSONEncoder()
		let data = try? jsonEncoder.encode(itemsArray)
		
		do {
			try data?.write(to: documentURL, options: .noFileProtection)
		}
		catch {
			print(error.localizedDescription)
		}
		
	}
	
	
	func loadData(completed: @escaping () -> () ) {
		
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
		
		guard let data = try? Data(contentsOf: documentURL) else { return }
		
		let jsonDecoder = JSONDecoder()
		
		do {
			itemsArray = try jsonDecoder.decode(Array<TodoItem>.self, from: data)
		} catch  {
			print(error.localizedDescription)
		}
		
		completed()
		
	}
	
	
}
