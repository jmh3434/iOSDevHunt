//
//  Login.swift
//  Curb Alert
//
//  Created by James Hunt on 7/6/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Firebase

var enteredUsername = ""


var name = ""
class Login: UIViewController, UITextFieldDelegate{
        var ref:FIRDatabaseReference?
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func forgotButton(_ sender: Any) {
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()

        
    }
    func login(){
        // Retrieving the info from the text fields
        let username1 = usernameField.text
        let password1 = passwordField.text
        
        let username = username1?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let password = password1?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        // Defining the user object
        PFUser.logInWithUsername(inBackground: username!, password: password!, block: {(user, error) -> Void in
            if let error = error as NSError? {
                let errorString = error.userInfo["error"] as? NSString
                self.alert(message: errorString!, title: "Error")
            }
            else {
                self.getNewData { () -> () in
                    enteredUsername = username!
                    for i in (0..<1){
                        
                        //let key = quizName
                        
                        
                        let person: NSDictionary = ["YourName":"samplePerson",
                                                    "Answer1":"sample A",
                                                    "Answer2":"sample B",
                                                    "Answer3":"sample C",
                                                    "Answer4":"sample D",
                                                    "Question":"Sample Question",
                                                    "QuestionNum":"0",
                                                    "CorrectAnswer:": "2",
                                                    "AmountOfQuestions": "1"]
                        
                        //self.ref?.updateChildValues(["/users/\(key)/\(i)":person])
                        self.ref?.updateChildValues(["/\(usernameTitle)/\("sample")/\(i)":person])
                        
                    }
                    self.performSegue(withIdentifier: "loginSeg", sender: self)
                    
                    
                }
                
            }
        })
    }
    func getNewData(completion: @escaping () -> ()){
       // self.alert(message: "Welcome back!", title: "Login")
        if let currentUser = PFUser.current(){
        
           // usernameTitle = self.usernameField.text!
        
            usernameTitle = (currentUser.username!)
        }else{
            usernameTitle = self.usernameField.text!
        }
        
        completion()
        
    }
    
    @IBAction func loginFacebookButtonPressed(_ sender: Any) {
        
    }
    @IBAction func signupButtonPressed(_ sender: Any) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
        
            print("trying to be quick")
            self.getNewData { () -> () in
                enteredUsername = (currentUser?.username!)!
                for i in (0..<1){
                    
                    //let key = quizName
                    
                    
                    let person: NSDictionary = ["YourName":"samplePerson",
                                                "Answer1":"sample A",
                                                "Answer2":"sample B",
                                                "Answer3":"sample C",
                                                "Answer4":"sample D",
                                                "Question":"Sample Question",
                                                "QuestionNum":"0",
                                                "CorrectAnswer:": "2",
                                                "AmountOfQuestions": "1"]
                    
                    //self.ref?.updateChildValues(["/users/\(key)/\(i)":person])
                    self.ref?.updateChildValues(["/\(enteredUsername)/\("sample")/\(i)":person])
                    
                }
                
                
                
            }
            self.performSegue(withIdentifier: "loginSeg", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
              
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    
    
    
}
