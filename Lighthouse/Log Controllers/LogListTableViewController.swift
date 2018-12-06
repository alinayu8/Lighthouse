//
//  LogListTableViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/8/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData

class LogListTableViewController: UITableViewController {
    var entries = [Entry]()
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // clear entries if already populated
//        if (entries.count >= 0) {
//            entries.removeAll()
//        }
        fetchEntries() // get entries from CoreData
        
        tableView.register(UINib(nibName: "LogListViewCell", bundle: nil), forCellReuseIdentifier: "LogListCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Add text to cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogListCell", for: indexPath) as! LogListViewCell
        let entry = entries[indexPath.row]
        
        cell.entryDate?.text = formatEntryDate(date: entry.startTime!)
        if let notes = entry.notes {
            cell.entryNotes?.text = notes
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEntry", sender: tableView)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if (entries[indexPath.row].startTime == (data.value(forKey: "start_time") as? Date) &&
                        entries[indexPath.row].endTime == (data.value(forKey: "end_time") as? Date) &&
                        entries[indexPath.row].latitude == (data.value(forKey: "latitude") as? Double) &&
                        entries[indexPath.row].longitude == (data.value(forKey: "longitude") as? Double)) {
                        context.delete(data)
                        try context.save()
                    }
                }
            } catch {
                print("Failed")
            }
            
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.entries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Functions
    
    func formatEntryDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEntry" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let entry = entries[indexPath.row]
                (segue.destination as! EntryViewController).entryDetail = entry
            }
        }
        
    }
    
    // MARK: - Fetch CoreData
    
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func fetchEntries() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                self.loadEntries(data: data)
            }
        } catch {
            print("Failed")
        }
    }
    
    func loadEntries(data: NSManagedObject){
        let newEntry = Entry()
        newEntry.startTime = data.value(forKey: "start_time") as? Date
        newEntry.endTime = data.value(forKey: "end_time") as? Date
        newEntry.latitude = data.value(forKey: "latitude") as? Double
        newEntry.longitude = data.value(forKey: "longitude") as? Double
        newEntry.notes = (data.value(forKey: "notes") as? String)
        entries.append(newEntry)
        //print("re-appending" + newEntry.notes!)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
