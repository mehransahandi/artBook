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
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageView.isUserInteractionEnabled = true
      
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoVC.imageselction))
        ImageView.addGestureRecognizer(gestureRecognizer)
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
             print("done")
        } catch {
            
            print("error")
        }
        
        
    }
    

}
