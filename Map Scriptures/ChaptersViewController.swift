//
//  ChaptersViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/24/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit

class ChaptersViewController : UITableViewController {
    
    //Mark: - Properties
    
    var numberChapters = 0;
//    var books: [Book]!
    var currentBook = Book()

    
    //Mark: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberChapters
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath)
        
        cell.textLabel?.text = "Chapter \(indexPath.row + 1)"
        
        
        //NEEDSWORK
        
        
        return cell
    }
    
    
    // Mark: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Scripture", sender: self)
    }
    
    
    //Mark: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Scripture" {
            if let destVC = segue.destination as? ScriptureViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destVC.book = currentBook
                    destVC.chapter = indexPath.row + 1
                    destVC.title = currentBook.fullName + " \(indexPath.row + 1)"
                }
            }
        }
    }
   
    
}
