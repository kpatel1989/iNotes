//
//  ViewController.swift
//  iNotes
//
//  Created by Kartik Patel on 2017-03-28.
//  Copyright © 2017 Kartik Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var data:[String]!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem
        load()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "notesTableCell", for: indexPath);
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    @IBAction func addBtnClick(_ sender: UIBarButtonItem) {
        data.insert("Row \(data.count+1)", at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .left)
        save()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        table.setEditing(editing, animated:animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .right)
        save()
    }
    
    func save() {
        UserDefaults.standard.set(data, forKey: "notes")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
             data = loadedData
            table.reloadData()
        } else{
            data = []
        }
    }
}

