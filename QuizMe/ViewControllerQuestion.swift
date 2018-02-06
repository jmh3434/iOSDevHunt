//
//  ViewController.swift
//  QuizMe
//
//  Created by James Hunt on 3/4/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import Parse


class ViewControllerQuestion: UIViewController, UITextFieldDelegate {

    var buttonSelected=0;
    var answerPicked=false
    var oneQuestionMade=false
    var handle:FIRDatabaseHandle?
    var ref:FIRDatabaseReference?
    var amountOfQuestions = 0
    
    
    @IBOutlet weak var questionNumText: UILabel!
    
    
    
    
    
    var Questions:Array<String>=Array()
    var AnswersPicked:Array<Int>=Array()
    var Answers1:Array<String>=Array()
    var Answers2:Array<String>=Array()
    var Answers3:Array<String>=Array()
    var Answers4:Array<String>=Array()
    var quizName=""
    var yourName=""
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var answerText1: UITextField!
    @IBOutlet weak var answerText2: UITextField!
    @IBOutlet weak var answerText3: UITextField!
    @IBOutlet weak var answerText4: UITextField!
    
    
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        
        self.questionText.delegate = self
        self.answerText1.delegate = self
        self.answerText2.delegate = self
        self.answerText3.delegate = self
        self.answerText4.delegate = self
        
        questionNumText.text = "Question: 1"
        enterButton.layer.cornerRadius = 10
        enterButton.clipsToBounds = true
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.questionText.resignFirstResponder()
        self.answerText1.resignFirstResponder()
        self.answerText2.resignFirstResponder()
        self.answerText3.resignFirstResponder()
        self.answerText4.resignFirstResponder()
        
        
        return true
    }
    func captureScreen() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    @IBAction func finishPressed(_ sender: Any) {
        if(PFUser.current()?.username != usernameTitle){
      notificationMessage = "(\(usernameTitle), \((PFUser.current()?.username)!) made a quiz for you on the QuizMe iOS app called \(quizName)"
        IAnotherUserMadeAQuiz = true
        }
        
        performSegue(withIdentifier: "backToHome", sender: self)
        
        
        
        
        
    }
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    
    
    let listOfSwearWords = ["darn", "crap", "newb","fuck","cunt","bitch","damn","shit","whore","slut","fag"]
    /* list as lower case */
    
    
    
    
    @IBAction func enterPressed(_ sender: UIButton) {
        // filter material
        //filter objectionable content
        
        if(containsSwearWord(text: questionText.text!, swearWords: listOfSwearWords)){
            let alert = UIAlertController(title: "Try Again",
                                          message:"There is offensive material in this post",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            
        }
        
        
        if (self.questionText.text=="")||(self.answerText1.text=="")||(self.answerText2.text=="")||(self.answerText3.text=="")||(self.answerText4.text=="")||(answerPicked==false){
            let alert = UIAlertController(title: "Check Again",
                                          message:"fill out all text fields and click on Answer A, B, C, or D",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }else{
            Questions.append(self.questionText.text!)
            Answers1.append(self.answerText1.text!)
            Answers2.append(self.answerText2.text!)
            Answers3.append(self.answerText3.text!)
            Answers4.append(self.answerText4.text!)
            
            AnswersPicked.append(buttonSelected)
            buttonSelected=0;
            answerPicked=false
            oneQuestionMade=true
            
            button1.backgroundColor=UIColor.clear
            button2.backgroundColor=UIColor.clear
            button3.backgroundColor=UIColor.clear
            button4.backgroundColor=UIColor.clear
            
            answerText1.text = ""
            answerText2.text = ""
            answerText3.text = ""
            answerText4.text = ""
            questionText.text = ""
            
            questionNumText.text = "Question: \(Questions.count+1)"
            amountOfQuestions=amountOfQuestions+1
            
            
            
            for i in (0..<Questions.count){
                
                let key = quizName
                var j = 0
                j = AnswersPicked[i]
                
                let person: NSDictionary = ["YourName":yourName,
                                            "Answer1":Answers1[i],
                                            "Answer2":Answers2[i],
                                            "Answer3":Answers3[i],
                                            "Answer4":Answers4[i],
                                            "Question":Questions[i],
                                            "QuestionNum":("\(i)"),
                                            "CorrectAnswer:": ("\(j)"),
                                            "AmountOfQuestions": ("\(amountOfQuestions)")]
                
                //self.ref?.updateChildValues(["/users/\(key)/\(i)":person])
                self.ref?.updateChildValues(["/\(usernameTitle)/\(key)/\(i)":person])

                
            }

            
            
        }
        
        
        // print("hello")
    }
    @IBAction func button1(_ sender: Any) {
        buttonSelected=1
        answerPicked=true
        button1.backgroundColor=UIColor.green
        button2.backgroundColor=UIColor.clear
        button3.backgroundColor=UIColor.clear
        button4.backgroundColor=UIColor.clear
    }
    @IBAction func button2(_ sender: Any) {
        buttonSelected=2
        answerPicked=true
        button2.backgroundColor=UIColor.green
        button3.backgroundColor=UIColor.clear
        button4.backgroundColor=UIColor.clear
        button1.backgroundColor=UIColor.clear
    }
    @IBAction func button3(_ sender: Any) {
        buttonSelected=3
        answerPicked=true
        button3.backgroundColor=UIColor.green
        button4.backgroundColor=UIColor.clear
        button1.backgroundColor=UIColor.clear
        button2.backgroundColor=UIColor.clear
    }
    @IBAction func button4(_ sender: Any) {
        buttonSelected=4
        answerPicked=true
        button4.backgroundColor=UIColor.green
        button3.backgroundColor=UIColor.clear
        button2.backgroundColor=UIColor.clear
        button1.backgroundColor=UIColor.clear
        
    }
    
    
    
   
    
    
    
    
    
}

