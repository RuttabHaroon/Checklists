//
//  ViewController.swift
//  Checklists
//
//  Created by RUTTAB on 8/11/19.
//  Copyright © 2019 RUTTAB. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController  {

    var items = [ChecklistItem]()
    var checklist: Checklist!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUp()
        
        //intializeChecklistArr()
        
        loadChecklistItems()
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    // MARK:- Actions
    @IBAction func addItem() {
//        let newRowIndex = items.count
//        let item = ChecklistItem()
//        item.text = "I am a new row"
//        item.checked = true
//        items.append(item)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
}

//MARK:- Implementation
extension ChecklistViewController {
    func intializeChecklistArr() {
        // Replace previous code with the following
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
    }
    
    func setUp() {
        title = checklist.name
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        (item.checked) ? (label.text = "√") : (label.text = "")
        //(item.checked) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}


// MARK:- Table View Data Source
extension ChecklistViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]

        
        configureText(for: cell, with: item)
        
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItemListArray()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveItemListArray()
    }
    
}

//MARK:- Data Persistence
extension ChecklistViewController {
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveItemListArray(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    func loadChecklistItems() {
        //get the file from the url
        let path = dataFilePath()
        //retrieve the data from the file
        if let data = try? Data(contentsOf: path) {
            //the decoder instance that will decode or deserilize the data
            let decoder = PropertyListDecoder()
            do {
                //deserilize the data back into an array of ChecklistItem objects
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        } }
}

// MARK:- AddItemViewControllerDelegate
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        saveItemListArray()
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        saveItemListArray()
        navigationController?.popViewController(animated:true)
    }
}
