//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Peter on 11/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import SwiftRandom
import RealmSwift

class CategoryTableViewController: UITableViewController
{
    // MARK: Stored properities
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    // MARK: - VC Life cycle methods
      
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count  ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteCategory(at: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
    }
 
    
    // MARK: - @IBActions
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "title"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
          
            let name = alert.textFields?.first!.text
            
            let newCategory = Category()
            newCategory.name = name!
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Realm CRUD methods
    
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        
        if let categoryToDelete = categories?[indexPath.row]  {
            do {
                
                try realm.write {
                    realm.delete(categoryToDelete.items)
                    realm.delete(categoryToDelete)
                }

            } catch {
                print(error)
                
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItems" {
            
            let itemsVC = segue.destination as! ItemsTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                itemsVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }

}
