//
//  AceListViewController.swift
//  AceList
//
//  Created by Ace Goulet on 8/27/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import UIKit
import CoreData

class AceListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //setup data from coredata
        loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AceListItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //display checkmarks where appropriate
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //swap checkmarks
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let enteredText = textField.text, !enteredText.isEmpty {

                let newItem = Item(context: self.context)
                newItem.title = enteredText
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item Title"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Manipulate Data model
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //read data from coredata
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension AceListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let enteredText = searchBar.text, !enteredText.isEmpty {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", enteredText)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        } else {
            loadItems()
        }
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
