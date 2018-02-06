//
//  knownUser.swift
//  QuizMe
//
//  Created by James Hunt on 7/30/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Parse
import Social
import MessageUI



var userFriend = ""


 let defaults:UserDefaults = UserDefaults.standard


class knownUser: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MFMessageComposeViewControllerDelegate {
    
   var cellContent = [""]
   var blockedUsers = [""]
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    let colorService = ColorServiceManager()
    
    let username = PFUser.current()?.username!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
        userFriend = knownUserTF.text!
        
        
        
        
       
        if let listOfBloackedUsers:Array = defaults.array(forKey: "blocked"){
           
            blockedUsers = listOfBloackedUsers as! [String]
        }

        for user in cellContent {
            for blockedPerson in blockedUsers {
                if user == blockedPerson {
                    cellContent = Array(Set(cellContent).subtracting(blockedUsers))
                }
            }
        }
        
        if let opened:Array = defaults.array(forKey: "friendList"){
            print("saved")
            cellContent = opened as! [String]
            print("opened Cell content:",cellContent)
            tv.reloadData()
        }
        
               
    }
    
    
    @IBAction func redTapped() {
        self.change(color: .red)
        
        colorService.send(colorName: "red")
    }
    
    @IBAction func yellowTapped() {
        self.change(color: .yellow)
        colorService.send(colorName: "yellow")
    }
    
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    


    
    @IBAction func share(_ sender: Any) {
        // text to share
        var person = ""
        if let usernameText = PFUser.current()?.username{
            person = usernameText
        }
        let text = "\"SimpleQuizMe\" is an app to make simple quizzes. Add me by username '\(String(describing: person))' once you download the app. You can find the app in the iOS App Store using keyword 'SimpleQuizMe'"
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.knownUserTF.resignFirstResponder()
        
        
        
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        let user = (currentCell.textLabel?.text!)!
        

        print(user)
        usernameTitle = user
        performSegue(withIdentifier: "clickedCell", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        
        cell.textLabel?.text  = cellContent[indexPath.row]
        
        return cell

    }

    @IBAction func blockUser(_ sender: Any) {
        if(knownUserTF.text! == ""){
        let alert = UIAlertController(title: "username field empty",
                                      message:"enter a username to block this user",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }else{
        blockedUsers.append(knownUserTF.text!)
        
        for user in cellContent {
            for blockedPerson in blockedUsers {
                if user == blockedPerson {
                    cellContent = Array(Set(cellContent).subtracting(blockedUsers))
                }
            }
        }
        
        defaults.set(self.cellContent, forKey: "friendList")
        tv.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
        
    }
    @IBAction func reportUser(_ sender: Any) {
        if(knownUserTF.text! == ""){
            let alert = UIAlertController(title: "username field empty",
                                          message:"enter a username to report this user",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "\(knownUserTF.text!) should be blocked from my account within 24 hours"
            controller.recipients = ["jmh3434@gmail.com"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    //... handle sms screen actions
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tv: UITableView!
    
    
    var handle:FIRDatabaseHandle?
    var ref:FIRDatabaseReference?
    @IBOutlet weak var knownUserTF: UITextField!
    var userExists = false
        @IBAction func enterQuiz(_ sender: Any) {
        
        
        let textFieldText = knownUserTF.text
        
        let knownUserText = textFieldText?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        ref = FIRDatabase.database().reference()
        
        let query = PFUser.query()
        
        query?.whereKey("username", equalTo: (knownUserText!))
        
 
        
        query?.getFirstObjectInBackground(block: { (object, error) in
            if (object != nil) {
                if self.checkForDuplicates(userCheck: knownUserText!) == false{
                    print("user exists")
                    
                    self.cellContent.append(knownUserText!)
                    self.tv.reloadData()
                    defaults.set(self.cellContent, forKey: "friendList")
                    
                    let alert = UIAlertController(title: "User Added",
                                                  message:"User with username \(knownUserText!) was added to your friend list",
                        preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)


                    
                }else{
                    let alert = UIAlertController(title: "User Already Added",
                                                  message:"User with username \(knownUserText!) is already in your friend list",
                        preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                
                }
            }
            else
            {
                print("user doesnt not exist")
                let alert = UIAlertController(title: "User doesn't exist",
                                              message:"No user with username \(knownUserText!)",
                    preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    

       
        
       
        
    
    
}
    
    @IBAction func back(_ sender: Any) {
        
        usernameTitle = (PFUser.current()?.username)!
    }
    
}



extension knownUser : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
           // self.connectionsLabel.text = "Connections: \(connectedDevices)"
            
            
            self.colorService.send(colorName: ((self.username!)))
        }
    }
    func checkForDuplicates(userCheck:String) -> Bool {
        for user in cellContent {
            if user == userCheck {
                return true
            }
        }
        return false
    }

    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            if (colorString != PFUser.current()?.username){
                if (self.checkForDuplicates(userCheck: colorString)==false){
                    self.cellContent.append(colorString)
                    
                    let alert = UIAlertController(title: "User Found Nearby",
                                                  message:"User "+colorString+" has been added to your friend list using bluetooth",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    defaults.set(self.cellContent, forKey: "friendList")
                    
                }
                
                
            }

            print("PF user is:"+colorString)
            
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default: break
                
            }
        }
    }
}
