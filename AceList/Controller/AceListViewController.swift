//
//  AceListViewController.swift
//  AceList
//
//  Created by Ace Goulet on 8/27/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class AceListViewController: SwipeTableViewController {
    
    var items : Results<Item>?
    lazy var realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {

        title = selectedCategory!.name
        guard let navBG = selectedCategory?.backgroundColor else { fatalError() }
        updateNavBar(withHexCode: navBG)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "#34CFB1")
    }
    
    //MARK: - Nav Bar setup methods
    
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else { fatalError("no nav bar, bro") }
        guard let bgColor = UIColor(hexString: colorHexCode) else { fatalError() }
        navBar.barTintColor = bgColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(bgColor, returnFlat: true)]
        navBar.tintColor = ContrastColorOf(bgColor, returnFlat: true)
        searchBar.layer.borderColor = bgColor.cgColor
        searchBar.barTintColor = bgColor
        searchBar.layer.borderWidth = 1
        view.backgroundColor = bgColor
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.backgroundColor ?? "#FFFFFF")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //display checkmarks where appropriate
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //swap checkmarks
        if let item = items?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                    item.dateModified = Date()
                }
            } catch {
                print("error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let enteredText = textField.text, !enteredText.isEmpty {

                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = enteredText
                            newItem.backgroundColor = UIColor.randomFlat.hexValue()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item, \(error)")
                    }
                }
                
                self.tableView.reloadData()
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
    
    
    //read data from coredata
    func loadItems() {

        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    //delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemToDelete = self.items?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("error deleting category \(error)")
            }
        }
    }
    
}

//MARK: - Search bar methods
extension AceListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let enteredText = searchBar.text, !enteredText.isEmpty {
            items = items?.filter("title CONTAINS[cd] %@", enteredText).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
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
