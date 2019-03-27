//
//  ItemsTableViewController.swift
//  todoey
//
//  Created by Peter on 11/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import SwiftRandom
import RealmSwift
import ChromaColorPicker
import ChameleonFramework

class ItemsTableViewController: UITableViewController

{
    //MARK: - Stored Properities
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - View Controllers life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        title = selectedCategory?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let colorHex = selectedCategory?.categoryColor else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
        
        tableView.reloadData()
    }    
    
    
    // MARK: - UI Config methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")}
        
        guard let navBarColor = UIColor.init(hexString: colourHexCode) else {fatalError()}
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
       
        UIView.animate(withDuration: 1) {
            
            navBar.barTintColor = navBarColor
            
            navBar.largeTitleTextAttributes = [.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            
            self.searchBar.barTintColor = navBarColor
        }
    }
    
    
    //MARK: - DB methods
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - @IBOutlets & @IBActions
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "title"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let title = alert.textFields?.first!.text
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = title!
                        
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving data to db \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor.init(hexString: selectedCategory!.categoryColor)?
                .darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(items!.count)) - CGFloat(0.05 * CGFloat(items!.count))) {
                
                cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        }else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error updating value " )
            }
        }
        
        tableView.reloadData()
    }


    // MARK: - Table view Delegate methods
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = items?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                }catch {
                    
                }
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    //MARK: - NAvigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCollorPicker" {
            
            let colorPickerVC = segue.destination as! ColorPickerViewController
            
            colorPickerVC.category = selectedCategory
        }
    }

}


// MARK: - UISearchBar Delegate Methods

extension ItemsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
         items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

