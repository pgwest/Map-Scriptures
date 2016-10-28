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
        else if segue.identifier == "Show Scripture1" {
            if let destVC = segue.destination as? ScriptureViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destVC.book = books[indexPath.row]
                    if books[indexPath.row].id > 201 && books[indexPath.row].id <= 204{
                        destVC.chapter = Int()
                    }
                    else if books[indexPath.row].id == 301 {
                        destVC.chapter = Int()
                    }
                    else{
                        destVC.chapter = 1 //Int()
                    }
                    destVC.title = books[indexPath.row].fullName
                }
            }
        }
    }
    
    
    //Mark: Table view delgate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NEEDS WORK
        
        if books[indexPath.row].numChapters == nil {
            performSegue(withIdentifier: "Show Scripture1", sender: self)
        }
        else if (books[indexPath.row].numChapters! > 1) {
            performSegue(withIdentifier: "Show Chapters", sender: self)
        }
        else {
            performSegue(withIdentifier: "Show Scripture1", sender: self)
        }

    }
    
    
}
