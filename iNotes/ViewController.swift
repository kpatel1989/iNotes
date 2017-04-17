//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Damini Verma on 2017-04-07.
//  Copyright © 2017 Damini Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteDescription: UITextField!
    var appDelegate:AppDelegate!
    var context:NSManagedObjectContext!
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var imageView: UIImageView!
    
    var nNotes : List? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        if nNotes != nil {
            noteTitle.text = nNotes?.title
            noteDescription.text = nNotes?.desc
            imageView.image = UIImage(data: (nNotes?.image?.data(using: String.Encoding.utf8))!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        back()
    }
    
    @IBAction func clickPhoto(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
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
        
        print(nNote.desc!)
        
        let data = UIImageJPEGRepresentation(imageView.image!, 1)! as Data
        nNote.image = String(data:data,encoding:.utf8);
        
        appDelegate.saveContext()
        
    }
    
    
    func editNote(){
        nNotes?.title = noteTitle.text
        nNotes?.desc = noteDescription.text
        let data = UIImageJPEGRepresentation(imageView.image!, 1)! as Data
        nNotes?.image = String(data:data,encoding:.utf8);
        
        appDelegate.saveContext()
    }
    
    func back()
    {
        navigationController?.popViewController(animated: true)
    }
}
