//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Damini Verma on 2017-04-07.
//  Copyright © 2017 Damini Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    
    var appDelegate:AppDelegate!
    var context:NSManagedObjectContext!
    let cellIdentifier:String = "imageCell"
    var images: [Images]? = []
    var uiImages: [UIImage]? = []
    
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
            images?.forEach({ (image) in
                let img = UIImage(data: (image.image?.data(using: String.Encoding.utf8))!)!
                uiImages?.append(img)
            })
            collectionView.reloadData()
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
//        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        uiImages?.append(info[UIImagePickerControllerOriginalImage] as! UIImage)
        collectionView.reloadData()

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
        nNote.id = Int32(nNote.objectID.hash)
            
        print(nNote.desc!)
        let imageEntity = NSEntityDescription.entity(forEntityName: "Images", in: context)
        
        uiImages?.forEach({ (image) in
            let data = UIImageJPEGRepresentation(image, 1)! as Data
            
            let nImage = Images(entity: imageEntity!, insertInto: context)
            nImage.image = String(data:data,encoding:.utf8);
            nImage.noteId = nNote.id
        })
        
        appDelegate.saveContext()
        
    }
    
    
    func editNote(){
        nNotes?.title = noteTitle.text
        nNotes?.desc = noteDescription.text
        
        let imageEntity = NSEntityDescription.entity(forEntityName: "Image", in: context)
        
        uiImages?.forEach({ (image) in
            let data = UIImageJPEGRepresentation(image, 1)! as Data
            
            let nImage = Images(entity: imageEntity!, insertInto: context)
            nImage.image = String(data:data,encoding:.utf8);
            nImage.noteId = (nNotes?.id)!
        })
        
        appDelegate.saveContext()
    }
    
    func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uiImages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
//        let image = images?[indexPath.row]
//        let image = UIImage(data: (images?[indexPath.row].image?.data(using: String.Encoding.utf8))!)

        let imageView = UIImageView(image: uiImages?[indexPath.row])
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        cell.addSubview(imageView)
        return cell
    }
}
