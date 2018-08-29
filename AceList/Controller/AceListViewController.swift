//
//  AceListViewController.swift
//  AceList
//
//  Created by Ace Goulet on 8/27/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import UIKit

class AceListViewController: UITableViewController {
    
    //var itemArray = ["Make App", "Market App", "Get Rich"]
    var itemArray = [Item]()
    //let allItems = ItemData()
    
    //user defaults
    //let defaults = UserDefaults.standard
    
    //encoded data file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        itemArray.append(Item(itemTitle: "Make App", itemDone: false))
//
//        itemArray.append(Item(itemTitle: "Market App", itemDone: true))
//
//        itemArray.append(Item(itemTitle: "Get Rich", itemDone: false))
        
//        setup data from user defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        
        //setup data from encoded plist
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
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //swap checkmarks
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let enteredText = textField.text, !enteredText.isEmpty {

                self.itemArray.append(Item(itemTitle: enteredText, itemDone: false))
                
                //save to user defaults
                //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
                
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        //save encoded data in custom plist
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    //setup data from encoded plist
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

