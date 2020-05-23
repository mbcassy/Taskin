//
//  ViewController.swift
//  Taskin
//
//  Created by Cassy on 5/19/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var taskArray = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
            //this is what happens after add task is clicked
            if let text = addTaskTextField.text {
                if text != "" {
                    let newTask = Task(context: self.context)
                    newTask.title = text
                    newTask.completed = false
                    newTask.inCategory = self.selectedGroup
                    self.taskArray.append(newTask)
                    self.saveData()
                } else {
                    // prompt again?
                }
            }
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
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = (task.completed) ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskArray[indexPath.row].completed = !taskArray[indexPath.row].completed
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Model Methods
    
    func saveData(){
        do {
            try context.save()
        } catch {
            // do something on error
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil){
        let groupPredicate = NSPredicate(format: "inCategory.name MATCHES %@", selectedGroup!.name!)
        
        if let predicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [groupPredicate, predicate])
        } else {
            request.predicate = groupPredicate
        }
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            // do something on error
        }
        tableView.reloadData()
    }
    
    //MARK: - UISearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request)
        do {
            taskArray = try context.fetch(request)
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

