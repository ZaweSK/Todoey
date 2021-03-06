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
import ChameleonFramework
import ChromaColorPicker

class CategoryTableViewController: UITableViewController
{
   
    // MARK: Stored properities
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    // MARK: - VC Life cycle methods
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navBarColor = UIColor.white
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")}
        
        UIView.animate(withDuration: 1) {
            navBar.barTintColor = navBarColor
            
            navBar.largeTitleTextAttributes = [.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        }

        tableView.reloadData()
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count  ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            var cellColor: UIColor
            
            let categoryColor = UIColor.init(hexString: category.categoryColor)
            cellColor = categoryColor != nil ? categoryColor! : UIColor.white
        
            
            cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
            cell.textLabel?.text = category.name
            
            cell.backgroundColor = UIColor.init(hexString: category.categoryColor)
            
        } else {
            
            cell.textLabel?.text = "No categories"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            checkForDeletion(at: indexPath)
    
        }
    }
    
    // MARK: - Deletion Warning
 
    func checkForDeletion(at indexPath: IndexPath) {
        
        if let categoryToDelete = categories?[indexPath.row] {
            
            let alertController = UIAlertController(title: "Are you sure you wanto to delete category \(categoryToDelete.name)", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
              
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                
                self.delete(categoryToDelete)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
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

            guard name!.count > 0 else {return}

            let newCategory = Category()

            newCategory.name = name!

            newCategory.categoryColor = UIColor.randomFlat.hexValue()

            self.save(category: newCategory)
        }

        alert.addAction(action)

        present(alert, animated: true) {
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissAlertController(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
    
    func delete(_ category: Category) {
        
        do {
            
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
            
        } catch {
            print(error)
            
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
