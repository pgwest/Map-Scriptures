//
//  BooksViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/22/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit

class BooksViewController : UITableViewController {
    
    var books: [Book]!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        cell.textLabel?.text = books[indexPath.row].fullName
        //NEEDSWORK 
        
        
        return cell
    }
    
    
    
}
