//
//  ViewController.swift
//  Taskin
//
//  Created by Cassy on 5/19/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var taskList: Results<Task>?
    var selectedGroup: Group? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addTaskTextField = UITextField()
        let alert = UIAlertController(title: "Enter a new Task.", message: "", preferredStyle: .alert)
        let addTaskAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = addTaskTextField.text, let currentGroup = self.selectedGroup {
                if text != "" {
                    do {
                        try self.realm.write {
                            let newTask = Task()
                            newTask.title = text
                            currentGroup.tasks.append(newTask)
                        }
                    } catch {
                        // handle error
                    }
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter a new Task."
            addTaskTextField = textfield
        }
        alert.addAction(addTaskAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        if let task = taskList?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = (task.completed) ? .checkmark : .none
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = taskList?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(task)
                    task.completed = !task.completed
                }
            } catch {
                // handle error
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Realm CRUD Methods
    
    func loadData(){
        taskList = selectedGroup?.tasks.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - UISearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request)
        do {
            //taskList = try context.fetch(request)
        } catch {
            // do something on error
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

