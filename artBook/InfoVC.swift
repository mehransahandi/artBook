//
//  InfoVC.swift
//  artBook
//
//  Created by Mehran Sahandi on 19.10.2017.
//  Copyright © 2017 Mehran Sahandi. All rights reserved.
//

import UIKit
import CoreData

class InfoVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TXTArtName: UITextField!
    @IBOutlet weak var TXTArtistName: UITextField!
    @IBOutlet weak var TXTYear: UITextField!
    @IBOutlet weak var BTNSave: UIButton!
    
    var selectedPainting = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageView.isUserInteractionEnabled = true
      
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoVC.imageselction))
        ImageView.addGestureRecognizer(gestureRecognizer)
        ///////////////
        if selectedPainting != ""{
            let appdeligate = UIApplication.shared.delegate as! AppDelegate
            let contecx = appdeligate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Painting")
            
            fetchRequest.predicate = NSPredicate(format: "artName = %@", self.selectedPainting)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                
                let results = try contecx.fetch(fetchRequest)
                if results.count>0{
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let artName = result.value(forKey: "artName") as? String {
                            
                            TXTArtName.text = artName
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            TXTYear.text = String(year)
                        }
                        
                        if let artistName = result.value(forKey: "artist") as? String {
                            TXTArtistName.text = artistName
                            
                        }
                        
                        if let imagedata = result.value(forKey: "image") as? Data {
                            
                            let image = UIImage(data:imagedata)
                            self.ImageView.image = image
                            
                        }
                        
                        
                    }// for
                    BTNSave.isHidden = true
                    
                } // if
                
            } catch {
                
                print("erorr data fetch")
            }
            
            
            
        }
       // fetchselected()
    }

    
    @objc func imageselction () {
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self // should add UIImagePickerControllerDelegate , UINavigationControllerDelegate to class
        imagePiker.sourceType = .photoLibrary
        imagePiker.allowsEditing = true
        present(imagePiker, animated: true, completion: nil)
        
    }
    // what to do after selection of image? added to imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         ImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // fetchselected function
    func fetchselected()  {
        
    }
    
    
    
    
    
    
    // save process
    
    @IBAction func BTNSavePressed(_ sender: Any) {
        
        // core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // connect to coreData model created ANd USING THIS WE CAN INSERT TO DATABASE
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Painting", into: context)
        
        newArt.setValue(TXTArtName.text, forKey: "artName")
        newArt.setValue(TXTArtistName.text, forKey: "artist")
        // convert string to int
        if let yeartext = Int(TXTYear.text!) {
            newArt.setValue(yeartext, forKey: "year")
            
        }
        // convert image to data
        if let data = UIImageJPEGRepresentation(ImageView.image!, 0.5){
            
            newArt.setValue(data, forKey: "image")
        }
        // save
        do {
            try context.save()
            // after save sent back to first view
            NotificationCenter.default.post(name: NSNotification.Name(rawValue : "newPainting"), object: nil) // send mesage to vc
             self.navigationController?.popViewController(animated: true)
            
        } catch {
            
            print("error")
        }
        
        
    }
    

}
