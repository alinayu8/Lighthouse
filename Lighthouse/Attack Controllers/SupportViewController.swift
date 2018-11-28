//
//  SupportViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/27/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class SupportViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var listContacts = [Contact]()
    
    // MARK: - TableView Functions
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContacts.count
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Add text to cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
        let contact = listContacts[indexPath.row]
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showEntry", sender: tableView)
        let contactNumber = listContacts[indexPath.row].number
        let customizedMessage = getMessage()
        displayMessageInterface(number: contactNumber ?? "", message: customizedMessage)
    }
    
    // MARK: - Message Functions
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func displayMessageInterface(number: String, message: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.body = message
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    // MARK: - CoreData Functions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getMessage() -> String {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] { // Adding number to existing Contact
                return data.value(forKey: "message") as! String
            }
        } catch {
            print("Failed")
        }
        return "Failed"
    }
    
    // MARK: - General Setup Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchContacts()
    }
    
    func fetchContacts() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                self.loadContacts(data: data)
            }
        } catch {
            print("Failed")
        }
    }
    
    func loadContacts(data: NSManagedObject){
        let newContact = Contact()
        newContact.name = data.value(forKey: "name") as? String
        newContact.number = data.value(forKey: "number") as? String
        listContacts.append(newContact)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
