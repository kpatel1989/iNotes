//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Damini Verma on 2017-04-07.
//  Copyright © 2017 Damini Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteDescription: UITextField!
    var appDelegate:AppDelegate!
    var context:NSManagedObjectContext!
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    var nNotes : List? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        if nNotes != nil {
            noteTitle.text = nNotes?.title
            noteDescription.text = nNotes?.desc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        back()
    }
    
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        if nNotes != nil{
            editNote()
        }
        else{
            newNote()
        }
        
        back()
    }
    
    func newNote()
    {
        let entity = NSEntityDescription.entity(forEntityName: "List", in: context)
        let nNote = List(entity: entity!, insertInto: context)
        nNote.title = noteTitle.text
        nNote.desc = noteDescription.text
        print(nNote.desc)
        appDelegate.saveContext()
        
    }
    
    
    func editNote(){
        nNotes?.title = noteTitle.text
        nNotes?.desc = noteDescription.text
        appDelegate.saveContext()
    }
    
    func back()
    {
        navigationController?.popViewController(animated: true)
    }
}
