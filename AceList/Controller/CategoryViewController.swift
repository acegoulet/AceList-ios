//
//  CategoryViewController.swift
//  AceList
//
//  Created by Ace Goulet on 8/29/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#f1f1f1")
        tableView.rowHeight = 80
        loadCategories()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("no nav bar, bro") }
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:FlatWhite()]
    }

    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let enteredText = textField.text, !enteredText.isEmpty {
                
                let newCategory = Category()
                newCategory.name = enteredText
                newCategory.backgroundColor = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            let cellColor = UIColor(hexString: category.backgroundColor ?? "#FFFFFF")
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor!, returnFlat: true)
        }
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AceListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //read data from coredata
    func loadCategories() {

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryToDelete = categories?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(categoryToDelete.items)
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("error deleting category \(error)")
            }
        }
    }
}
