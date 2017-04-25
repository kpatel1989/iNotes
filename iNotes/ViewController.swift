//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Damini Verma on 2017-04-07.
//  Copyright © 2017 Damini Verma. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    
    var appDelegate:AppDelegate!
    var context:NSManagedObjectContext!
    let cellIdentifier:String = "imageCell"
    var images: [Images] = []
    var uiImages: [[String:Any]] = []
    var imageEntity:NSEntityDescription!
    var lastImage:[String:Any]!
    var nNotes : List? = nil
    let regionRadius : CLLocationDistance = 1000
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        imageEntity = NSEntityDescription.entity( forEntityName: "Images", in: context)
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        if nNotes != nil {
            noteTitle.text = nNotes?.title
            noteDescription.text = nNotes?.desc
            images.forEach({ (image:Images) in
                let img = UIImage(data: Data(base64Encoded: image.image!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)!
                uiImages.append(["image":img,"lat": image.lat, "long": image.long, "address" : image.address])
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        lastImage = ["image" : info[UIImagePickerControllerOriginalImage] as! UIImage , "lat": 0.0, "long" : 0.0, "address" : ""]
        
        uiImages.append(lastImage)
        
        collectionView.reloadData()
        locationManager = CLLocationManager();
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        let authSatus = CLLocationManager.authorizationStatus()
        if (authSatus == .restricted || authSatus == .denied)    // restricted or denied
        {
            // Show alert and close the app
        } else if(authSatus == .notDetermined) {                // not determined
            locationManager.requestAlwaysAuthorization();
        }
        locationManager.requestLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                
                    //stop updating location to save battery life
                self.locationManager.stopUpdatingLocation()
                self.uiImages[self.uiImages.count-1]["address"] = (pm.locality ?? "") + "," + (pm.postalCode ?? "") + "," + (pm.administrativeArea ?? "") + ", " + (pm.country ?? "")
                
            } else {
                print("Problem with the data received from geocoder")
            }
            self.collectionView.reloadData()
        })
        if (lastImage != nil) {
            
            uiImages[uiImages.count-1]["lat"] = locationManager.location!.coordinate.latitude
            uiImages[uiImages.count-1]["long"] = locationManager.location!.coordinate.longitude
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
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
        
        uiImages.forEach({ (image) in
            let data:Data = UIImagePNGRepresentation(image["image"] as! UIImage)!;
            
            let nImage = Images(entity: imageEntity!, insertInto: context)
            let utfImage:String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            nImage.image = utfImage
            nImage.lat = image["lat"] as! Double
            nImage.long = image["long"] as! Double
            nImage.address = image["address"] as! String
            nImage.noteId = nNote.id
        })
        
        appDelegate.saveContext()
        
    }
    
    
    func editNote(){
        nNotes?.title = noteTitle.text
        nNotes?.desc = noteDescription.text
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        fetch.predicate = NSPredicate(format: "noteId == %@", NSNumber(value: (nNotes?.id)!))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            let result = try context.execute(request)
            print(result)
        } catch {
            print("Delete request error")
        }
        
        uiImages.forEach({ (image) in
            let data:Data = UIImagePNGRepresentation(image["image"] as! UIImage)!
            
            let nImage = Images(entity: imageEntity!, insertInto: context)
            let utfImage:String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            nImage.image = utfImage
            nImage.lat = image["lat"] as! Double
            nImage.long = image["long"] as! Double
            nImage.address = image["address"] as! String
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
        return uiImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell

        cell.image.image = uiImages[indexPath.row]["image"] as! UIImage
        cell.locationCell.text = "at :" + String(describing:uiImages[indexPath.row]["address"]!)
        
        return cell
    }
}
