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

class SupportViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    // MARK: - Buttons
    @IBAction func sendMessage(_ sender: UIButton) {
        displayMessageInterface()
    }
    
    // MARK: - Message Functions
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        let number = getNumber()
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.body = "I love Swift!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    // MARK: - CoreData Functions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getNumber() -> String {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] { // Adding number to existing Contact
                return data.value(forKey: "number") as! String
            }
        } catch {
            print("Failed")
        }
        return "Failed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
