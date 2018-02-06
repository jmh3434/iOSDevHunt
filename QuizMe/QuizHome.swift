//
//  quizHome.swift
//  QuizMe
//
//  Created by James Hunt on 3/5/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Parse

 var myList:[String]=[]
 var quizTitle = ""
 var added = false


class QuizHome: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var createQuizButton: UIButton!
    @IBOutlet var findFriendsButton: UIButton!
    
     var cellContent = [""]
    
    @IBOutlet var shareQuiz: UIButton!
    
    let colorService = ColorServiceManager()
    let username = PFUser.current()?.username!
    
    
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
    @IBOutlet weak var knownUser: UITextField!
   
    @IBOutlet weak var helloLabel: UILabel!
    var handle:FIRDatabaseHandle?
    var tempArray:[String] = []

    
    var quizName="Untitled"
    var yourName=""
    var Questions:Array<String>=Array()
    var AnswersPicked:Array<Int>=Array()
    var Answers1:Array<String>=Array()
    var Answers2:Array<String>=Array()
    var Answers3:Array<String>=Array()
    var Answers4:Array<String>=Array()
    
    
    var amountOfQuestions = 0
    
    
    
    @IBOutlet weak var addQuiz: UIButton!
   
    
    var ref:FIRDatabaseReference?
    
    @IBOutlet weak var textField: UITextField!
 
    func socialShare(sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
    super.viewDidLoad()
        if IAnotherUserMadeAQuiz {
            
            shareQuiz.setTitle("Share Quiz With \(usernameTitle)", for: .normal)
            
            shareQuiz.isHidden = false
        }else{
        
        shareQuiz.isHidden = true
        }
        
        
        if let opened:Array = defaults.array(forKey: "friendList"){
            print("saved")
            cellContent = opened as! [String]
            print("opened Cell content:",cellContent)
           
        }
        
        findFriendsButton.layer.cornerRadius = 7.0
        findFriendsButton.clipsToBounds = true
        createQuizButton.layer.cornerRadius = 7.0
        createQuizButton.clipsToBounds = true
        
        
        colorService.delegate = self
        
         ref = FIRDatabase.database().reference()
        for i in (0..<2){
            
            
            //let key = quizName
            
            
            let person: NSDictionary = ["YourName":"samplePerson",
                                        "Answer1":"A Movie",
                                        "Answer2":"A Person",
                                        "Answer3":"A Book",
                                        "Answer4":"all the above",
                                        "Question":"Harry Potter is:",
                                        "QuestionNum":"0",
                                        "CorrectAnswer:": "4",
                                        "AmountOfQuestions": "1"]
            
            //self.ref?.updateChildValues(["/users/\(key)/\(i)":person])
            self.ref?.updateChildValues(["/\(usernameTitle)/\("sample quiz")/\(i)":person])
            
        }

        
        
        
        self.textField.delegate = self
       
        
        
       

        
       
    }
    @IBAction func knowUserPressed(_ sender: Any) {
        usernameTitle = knownUser.text!
        self.viewDidLoad()
        
    }
    
    @IBAction func shareQuizPressed(_ sender: Any) {
         socialShare(sharingText: "\(notificationMessage)", sharingImage: nil, sharingURL: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if IAnotherUserMadeAQuiz {
            
            shareQuiz.setTitle("Share Quiz With \(usernameTitle)", for: .normal)
            shareQuiz.isHidden = false
            print("I am here")
            
            
            
            
            socialShare(sharingText: "\(notificationMessage)", sharingImage: nil, sharingURL: nil)
            
            IAnotherUserMadeAQuiz = false
            
        }
        if(PFUser.current()?.username != usernameTitle){
            helloLabel.text = usernameTitle+" made these quizzes. Take one or make a quiz for this user!"
        }else{
        helloLabel.text = "Welcome, "+usernameTitle+"! Create a quiz below"
        }
    }
    func getNewData(completion: @escaping () -> ()){
        
        self.tempArray.removeAll()
        ref = FIRDatabase.database().reference()
        //handle = ref?.child("users").observe(.value, with: {(snapshot) in
        handle = ref?.child("\(usernameTitle)").observe(.value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
                        var nameOfQuizes = value!.allKeys
            for i in (0..<nameOfQuizes.count){
                myList.append(nameOfQuizes[i] as! String)
            }
          completion()
            
            
            if let quizNames = snapshot.value as? String
            {
                
                self.tempArray.append(quizNames)
                
                if self.tempArray.count>4{
                   // completion()
                }
                
                
                
            }
            
        })
    }
    @IBAction func addQuizPressed(_ sender: Any) {
        if textField.text == "" {
            let alert = UIAlertController(title: "More Info Needed",
                                          message:"Enter Quiz Name Before Adding a Quiz",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
        
        performSegue(withIdentifier: "addQuizSeg", sender: self)
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
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
      
        
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "logoutSeg"){
            PFUser.logOut()

            
        }else if(segue.identifier == "knowSeg"){
            
        }else{
        if(textField.text == ""){
            let alert = UIAlertController(title: "More Info Needed",
                                          message:"Enter Quiz Name Before Adding A Quiz",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            
        }else{
        if (segue.identifier == "addQuizSeg"){
            
            if(textField.text==""){
                quizName="Untitled"
            }else{
                quizName=textField.text!
                
            }
            
            
        let svc = segue.destination as! ViewControllerQuestion;
        svc.quizName = quizName
        svc.yourName = yourName
            }
   
        }
    }
    
   
    }
    
    
    
    
}
extension QuizHome : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
            
            
            self.colorService.send(colorName: ((self.username!)))
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            if (colorString != PFUser.current()?.username){
                if (self.checkForDuplicates(userCheck: colorString)==false){
                    self.cellContent.append(colorString)
                    
                    let alert = UIAlertController(title: "User Found",
                                                  message:"User "+colorString+" has been added to your friend list",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    
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

