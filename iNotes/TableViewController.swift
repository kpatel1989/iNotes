//
//  TableViewController.swift
//  CoreDataAssignment
//
//  Created by Damini Verma on 2017-04-07.
//  Copyright © 2017 Damini Verma. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var appDelegate : AppDelegate!
    var context : NSManagedObjectContext!
    
    var frc : NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController()
    var imageFrc : NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController()
    
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>{
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func listFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func getImageFetchedResultsController(list:List) -> NSFetchedResultsController<NSFetchRequestResult>{
        frc = NSFetchedResultsController(fetchRequest: imagesFetchRequest(list: list), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func imagesFetchRequest(list:List) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        
        let whereDescriptor = NSPredicate(format: "noteId == %@",list.id)
        fetchRequest.predicate = whereDescriptor;
        return fetchRequest
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        frc = getFetchedResultsController()
        frc.delegate = self
        do
        {
            try frc.performFetch()
        }catch{
                print("nil Error")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numberOfsections = frc.sections?.count
        return numberOfsections!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfrows = frc.sections?[section].numberOfObjects
        return numberOfrows!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let list = frc.object(at: indexPath) as! List
        cell.textLabel?.text = list.title
        let description = list.desc
        cell.detailTextLabel?.text = description
        

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
        
        let managedObject : NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        context.delete(managedObject)
        appDelegate.saveContext()
        
//        do{
//            try context.save()
//        }catch{
//            print("nil Error")
//        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let itemController : ViewController = segue.destination as! ViewController
            let nItem : List = frc.object(at: indexPath!) as! List
            itemController.nNotes = nItem
            imageFrc = getFetchedResultsController()
            do {
                try imageFrc.performFetch()
            } catch {
                print("Error fetching images")
            }
            
            let images : [Images] = imageFrc.fetchedObjects as! [Images];
            itemController.images = images
            
        }
    }
    

}
