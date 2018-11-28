//
//  ContactViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/27/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Text input
    @IBOutlet weak var firstContactName: UITextField!
    @IBOutlet weak var secondContactName: UITextField!
    @IBOutlet weak var thirdContactName: UITextField!
    @IBOutlet weak var fourthContactName: UITextField!
    
    @IBOutlet weak var firstContactNumber: UITextField!
    @IBOutlet weak var secondContactNumber: UITextField!
    @IBOutlet weak var thirdContactNumber: UITextField!
    @IBOutlet weak var fourthContactNumber: UITextField!
    
    @IBOutlet weak var messageField: UITextView!
    // MARK: - CoreData Functions
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveContact(contactName: String, contactNumber: String) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] { // Adding number to existing Contact
                if contactName == (data.value(forKey: "name") as! String) {
                    data.setValue(contactNumber, forKey: "number")
                    try context.save()
                    break
                }
            }
            // Creating new Contact
            let contact = NSEntityDescription.entity(forEntityName: "Contacts", in: context)
            let newContact = NSManagedObject(entity: contact!, insertInto: context)
            newContact.setValue(contactName, forKey: "name")
            newContact.setValue(contactNumber, forKey: "number")
        } catch {
            print("Failed")
        }
    }
    
    func deleteContacts() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
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
        deleteContacts()
        if (firstContactName.text != "") {
            print("first contact")
            saveContact(contactName: firstContactName.text!, contactNumber: firstContactNumber.text ?? "")
        }
        
        if (secondContactName.text != "") {
            print("second contact")
            saveContact(contactName: secondContactName.text!, contactNumber: secondContactNumber.text ?? "")
        }
        
        if (thirdContactName.text != "") {
            print("third contact")
            saveContact(contactName: thirdContactName.text!, contactNumber: thirdContactNumber.text ?? "")
        }
        
        if (fourthContactName.text != "") {
            print("fourth contact")
            saveContact(contactName: fourthContactName.text!, contactNumber: fourthContactNumber.text ?? "")
        }
        
        print("dismiss keyboard")
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageField.delegate = self as? UITextViewDelegate
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
