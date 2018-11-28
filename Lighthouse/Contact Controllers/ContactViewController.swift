//
//  ContactViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/27/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI
import Contacts

class ContactViewController: UIViewController, CNContactPickerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var listContacts = [Contact]()
    
    // MARK: - Buttons
        
    @IBAction func addContactButton(_ sender: Any) {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = self
        pickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        
        // Display only a person's phone, email, and postal address
        let displayedItems = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        pickerViewController.displayedPropertyKeys = displayedItems
        
        // Show the picker
        self.present(pickerViewController, animated: true, completion: nil)
    }

    // MARK: - Table View Controller
    
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
        print(contact)
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.number
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if (listContacts[indexPath.row].name == (data.value(forKey: "name") as? String) &&
                        listContacts[indexPath.row].number == (data.value(forKey: "number") as? String)) {
                        context.delete(data)
                        try context.save()
                    }
                }
            } catch {
                print("Failed")
            }
            listContacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - CNContactPickerDelegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            let contactName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            let contactNumber = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            print(contactName + " " + contactNumber)

            saveContact(contactName: contactName, contactNumber: contactNumber)
            self.tableView.reloadData()
        }
    }

    // Called when the user taps Cancel.
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        print("cancelled")
    }
    
    // MARK: - Text input
    
    @IBOutlet weak var messageField: UITextView!
    
    // MARK: - CoreData Functions
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveContact(contactName: String, contactNumber: String) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.returnsObjectsAsFaults = false
        do {
            // Creating new Contact
            let contact = NSEntityDescription.entity(forEntityName: "Contacts", in: context)
            let newContact = NSManagedObject(entity: contact!, insertInto: context)
            newContact.setValue(contactName, forKey: "name")
            newContact.setValue(contactNumber, forKey: "number")
            
            // Save contacts to array
            let newContactModel = Contact()
            newContactModel.name = contactName
            newContactModel.number = contactNumber
            listContacts.append(newContactModel)
            
            try context.save()
        } catch {
            print("Failed")
        }
    }
    
    // MARK: - Notes and Keyboard Functions
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if (self.messageField.isFirstResponder && self.view.frame.origin.y == 0) {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //deleteContacts()
        print("dismiss keyboard")
        view.endEditing(true)
        updateMessage(message: messageField.text)
    }
    
    func updateMessage(message: String) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                for data in result as! [NSManagedObject] {
                    data.setValue(message, forKey: "message")
                    try context.save()
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Messages", in: context)
                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                newEntity.setValue(message, forKey: "message")
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
    
    // MARK: - Random View Functions and Reloading things
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.messageField.delegate = self as? UITextViewDelegate
        fetchContacts()
        
        // Style text view
        let myColor = UIColor.gray
        messageField.layer.borderColor = myColor.cgColor
        messageField.layer.borderWidth = 1.0
        messageField.layer.cornerRadius = 10.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tap in view to exit keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
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
