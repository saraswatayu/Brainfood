//
//  FoodListTableViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController {
    
    let client = APIClient()
    var items = [FoodItem]()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    @IBAction func refresh() {
        refreshButton?.isEnabled = false
        
        let _ = client.request().then { [weak self] foodItems in
            self?.items = foodItems
        }.always(on: DispatchQueue.main) { [weak self] in
            self?.tableView.reloadData()
            self?.refreshButton?.isEnabled = true
        }
    }
    
    @IBAction func add() {
        let alertController = UIAlertController(title: "Add New Item", message: "Enter item name", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first {
                let vendorId = UIDevice.current.identifierForVendor?.uuidString ?? "placeholder"
                let itemDescription = textField.text ?? ""
                let foodItem = FoodItem(vendorID: vendorId, itemDescription: itemDescription)
                let _ = self?.client.addFoodItem(item: foodItem).then {
                    alertController.dismiss(animated: true, completion: nil)
                }.always {
                    self?.refresh()
                }
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addTextField { textField in
            textField.placeholder = "pineapple"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.itemDescription
        cell.detailTextLabel?.text = item.vendorID

        return cell
    }

}
