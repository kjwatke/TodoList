//
//  ViewController.swift
//  TodoList
//
//  Created by Kevin Watke on 2/25/22.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todoArray = [ "Learn Swift", "Build Apps", "Change the World", "Take a Vacation" ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    
}

