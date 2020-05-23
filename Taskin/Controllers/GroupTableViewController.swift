//
//  CategoryTableViewController.swift
//  Taskin
//
//  Created by Cassy on 5/22/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit
import CoreData

class GroupTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addCategoryTextField = UITextField()
        let addGroupAlert = UIAlertController(title: "Create a new Category.", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let text = addCategoryTextField.text {
                if text != "" {
                    let newCategory = Group(context: self.context)
                    newCategory.name = text
                    self.categories.append(newCategory)
                    self.saveData()
                } else {
                    // prompt again?
                }
            }
        }
        
        addGroupAlert.addTextField { (textfield) in
            textfield.placeholder = "Enter new Category"
            addCategoryTextField = textfield
        }
        
        addGroupAlert.addAction(addAction)
        present(addGroupAlert, animated: true, completion: nil)
    }
    
    //MARK:- TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedGroup = categories[indexPath.row]
        }
    }
    
    //MARK:- Data Model Methods
    
    func saveData(){
        do {
            try context.save()
        } catch {
            // handle error
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Group> = Group.fetchRequest()){
        do {
            categories = try context.fetch(request)
        } catch {
            // handle error
        }
        tableView.reloadData()
    }
}
