//
//  CategoryTableViewController.swift
//  Taskin
//
//  Created by Cassy on 5/22/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit
import RealmSwift

class GroupTableViewController: UITableViewController {
    let realm = try! Realm()
    var groups: Results<Group>?
    
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
                    let newGroup = Group()
                    newGroup.name = text
                    self.save(group: newGroup)
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
        return groups?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = groups?[indexPath.row].name
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedGroup = groups?[indexPath.row]
        }
    }
    
    //MARK:- Realm CRUD Methods
    
    func save(group: Group) {
        do {
            try realm.write {
                realm.add(group)
            }
        } catch {
            // handle error
        }
        tableView.reloadData()
    }
    
    func loadData(){
        groups = realm.objects(Group.self)
        tableView.reloadData()
    }
}
