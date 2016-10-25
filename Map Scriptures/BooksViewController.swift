//
//  BooksViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/22/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit

class BooksViewController : UITableViewController {
    
    //Mark: - Properties
    
    var books: [Book]!
    
    
    //Mark: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        cell.textLabel?.text = books[indexPath.row].fullName
        //NEEDSWORK 
        
        
        return cell
    }
    
    //Mark: Segue helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Chapters" {
            if let destVC = segue.destination as? ChaptersViewController {
                if let indexPath = tableView.indexPathForSelectedRow{
//                    destVC.books = books
                    destVC.title = books[indexPath.row].fullName
                    destVC.numberChapters = books[indexPath.row].numChapters!
                    destVC.currentBook = books[indexPath.row]
                }
            }
        }
    }
    
    
    //Mark: Table view delgate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NEEDS WORK
    }
    
    
}
