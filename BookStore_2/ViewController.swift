//
//  ViewController.swift
//  BookStore_2
//
//  Created by Hugo A Valencia on 3/31/20.
//  Copyright © 2020 Hugo A Valencia. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var toolbar : UINavigationItem!
    var result: [Book] = []
    var ascending : Bool = true
    var fal = false
    var cnt = 0;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
    }
    
   func loadBooks() -> [Book] {
        let fetchRequest : NSFetchRequest<Book> = Book.fetchRequest()
        let sort = NSSortDescriptor(key: "title", ascending: ascending)
        fetchRequest.sortDescriptors = [sort]
        var result : [Book] = []
        
        do {
            result = try managedObjectContext.fetch(fetchRequest)
        } catch {
            NSLog("My Error: %@", error as NSError)
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            return loadBooks().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                else {
                    return UITableViewCell()
            }
            
            let book: Book = loadBooks()[indexPath.row]
            cell.textLabel?.text = book.title
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let book : Book = loadBooks()[indexPath.row]
                managedObjectContext.delete(book)
                try managedObjectContext.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                NSLog("My Error: %@", error)
            }
            
            
        }
    }

    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedObjectContext) as! Book
        cnt += 1;
        if(loadBooks().count == 1){
            cnt = 1;
        }
        book.title = "My Book" + String(cnt)
        do {
            try managedObjectContext.save()
        }catch let error as NSError {
            NSLog("My Error: %@", error)
        }
        
        myTableView.reloadData()
    }
    
    @IBAction func changeOrder(_ sender: UIBarButtonItem) {
           ascending = !ascending
           myTableView.reloadData()
       }
    
    var rightButtons : [UIBarButtonItem] = []
    
    
//    @IBAction func deleteRow(_ sender: UIBarButtonItem) {
//        //let deleteItem = result[loadBooks().count-1]
//        managedObjectContext.delete(result[loadBooks().count-1])
//
//        do{
//            try self.managedObjectContext.save()
//        }catch let error as NSError {
//            NSLog("My Error: %@", error)
//        }
//
//        myTableView.reloadData()
//
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if fal {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            fal = false
//        }
  // }

}


