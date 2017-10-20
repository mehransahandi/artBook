//
//  ViewController.swift
//  artBook
//
//  Created by Mehran Sahandi on 19.10.2017.
//  Copyright © 2017 Mehran Sahandi. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var artistName = [String]()
    var artName = [String]()
    var year = [Int]()
    var image = [UIImage]()
    
    var selectedPainting = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self
        tableView.dataSource = self
     
        getinfo()
    }
    // refresh after save
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.getinfo), name: NSNotification.Name(rawValue : "newPainting"), object: nil)
    }
    
    
    //retrive information
    @objc func getinfo()  {
        
        artistName.removeAll(keepingCapacity: false)
        artName.removeAll(keepingCapacity: false)
        year.removeAll(keepingCapacity: false)
        image.removeAll(keepingCapacity: false)
        
        // fetching process
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDeligate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Painting")
        
        fetchrequest.returnsObjectsAsFaults = false
        
        do {
           let results = try contex.fetch(fetchrequest)
            
            if results.count>0{
                
                for result in results as! [NSManagedObject]{
                    
                    if let artName = result.value(forKey: "artName") as? String {
                        self.artName.append(artName)
                        
                    }
                    
                    if let artistName = result.value(forKey: "artist") as? String {
                        self.artistName.append(artistName)
                        
                    }
                    
                    if let year = result.value(forKey: "year") as? Int {
                        self.year.append(year)
                        
                    }
                    if let imageData = result.value(forKey: "image") as? Data {
                        let image = UIImage(data: imageData)
                        self.image.append(image!)
                        
                    }
                    
                    
                    
                    
                } // for
                
            } // if
        
        
        }catch {
            print("eroor catch")
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = artistName[indexPath.row]
        return cell
    }
    
    // selected row to next page
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedPainting = artName[indexPath.row]
        performSegue(withIdentifier: "ToInfoVC", sender: nil)
    }
    // send selected item with segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToInfoVC" {
            let destinationVC = segue.destination as! InfoVC
            destinationVC.selectedPainting = selectedPainting
            
            
        }
    }
    
    @IBAction func BTNAddPressed(_ sender: Any) {
        selectedPainting = ""
        performSegue(withIdentifier: "ToInfoVC", sender: nil)
        
    }
    

}

