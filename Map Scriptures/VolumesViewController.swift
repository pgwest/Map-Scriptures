//
//  VolumesViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/22/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit

class VolumesViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.firstLoad = true
    }
    
    var volumes = GeoDatabase.sharedGeoDatabase.volumes()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Books" {
            if let destVC = segue.destination as? BooksViewController {
                if let indexPath = tableView.indexPathForSelectedRow{
                    destVC.books = GeoDatabase.sharedGeoDatabase.booksForParentId(indexPath.row + 1)
                    destVC.title = volumes[indexPath.row]
                }
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath)
        
        cell.textLabel?.text = volumes[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }
    
    
    
}
