//
//  GameTime.swift
//  QuizMe
//
//  Created by James Hunt on 3/4/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAnalytics
import Social
import Parse

import MessageUI

class GameTime:UIViewController, MFMessageComposeViewControllerDelegate {
    
   
    @IBOutlet var scoreButton: UIButton!
    
    @IBOutlet weak var questionTextField: UILabel!
    
    var questionsMissed = [""]
    
    
    
    var quizName:String = ""
    var yourName:String = ""
    var quickStart = false
   
    var handle:FIRDatabaseHandle?
    var ref:FIRDatabaseReference?

    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var questionNumText: UILabel!
    var pickedNum=0;
    var currentQuestion=0;
    var numRight=0
    var wrongAnswer=false
    var buttonPressed=false
    var amountOfQuestions = 0
    
    var QuestionsGame:Array<String>=Array()
    var AnswersGame = [Int](repeating: 0, count: 80)
    var AnswersG1:Array<String>=Array()
    var AnswersG2:Array<String>=Array()
    var AnswersG3:Array<String>=Array()
    var AnswersG4:Array<String>=Array()
    var tempArray:[String] = []
    var tempArrayofPickedAnswers:[Int] = []
    
    @IBOutlet weak var buttonOut1: UIButton!
    @IBOutlet weak var buttonOut2: UIButton!
    @IBOutlet weak var buttonOut3: UIButton!
    @IBOutlet weak var buttonOut4: UIButton!
    
    @IBOutlet weak var nextQuestionOutlet: UIButton!
    
    @IBAction func buttonText1(_ sender: Any) {
        pickedNum=1
        checkAnswer(pickedNumber: 1)

    }
    @IBAction func buttonText2(_ sender: Any) {
        pickedNum=2
        checkAnswer(pickedNumber: 2)

    }
    @IBAction func buttonText3(_ sender: Any) {
        pickedNum=3
        checkAnswer(pickedNumber: 3)
    }
    @IBAction func buttonText4(_ sender: Any) {
        pickedNum=4
        checkAnswer(pickedNumber: 4)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scoreButton.isHidden = true
      
        
        buttonOut1.layer.cornerRadius = 15
        buttonOut1.clipsToBounds = true
        buttonOut2.layer.cornerRadius = 15
        buttonOut2.clipsToBounds = true
        buttonOut3.layer.cornerRadius = 15
        buttonOut3.clipsToBounds = true
        buttonOut4.layer.cornerRadius = 15
        buttonOut4.clipsToBounds = true
        
        
        
        nextQuestionOutlet.layer.cornerRadius = 10
        nextQuestionOutlet.clipsToBounds = true
        
        
        AnswersGame.append(0)
        AnswersGame.append(0)
        AnswersGame.append(0)
        quizNameLabel.text = quizTitle
        
        getNewData { () -> () in
            //Method two has finished
            
            self.amountOfQuestions = Int(self.tempArray[0])!
            self.buttonOut1.setTitle( "\(self.tempArray[1])" , for: .normal )
            self.buttonOut2.setTitle( "\(self.tempArray[2])" , for: .normal )
            self.buttonOut3.setTitle( "\(self.tempArray[3])" , for: .normal )
            self.buttonOut4.setTitle( "\(self.tempArray[4])" , for: .normal )
            self.AnswersGame[self.currentQuestion] = Int(self.tempArray[5])!
            self.questionTextField.text=self.tempArray[6]
            
            

            

          
            
        }
        
        
       // questionTextField.isUserInteractionEnabled=false
        
        
    }
   
    
    func getNewData(completion: @escaping () -> ()){
    
        self.tempArray.removeAll()
        ref = FIRDatabase.database().reference()
        handle = ref?.child("\(usernameTitle)").child(quizName).child("\(currentQuestion)").observe(.childAdded, with: {(snapshot) in
            
            
            if let questionItem = snapshot.value as? String
            {
                self.tempArray.append(questionItem)
                if (self.tempArray.count>=8){
                    completion()
                   
                }
            }
        
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        questionTextField.lineBreakMode = .byWordWrapping
        questionTextField.numberOfLines = 0
        
        
        
        self.questionTextField.text=tempArray[6]
        
        self.buttonOut1.setTitle( "\(self.tempArray[1])" , for: .normal )
        self.buttonOut2.setTitle( "\(self.tempArray[2])" , for: .normal )
        self.buttonOut3.setTitle( "\(self.tempArray[3])" , for: .normal )
        self.buttonOut4.setTitle( "\(self.tempArray[4])" , for: .normal )
        
        
       
        questionNumText.text="1 / \(amountOfQuestions)"
        
       
        
    }
    
    
   


    
    
    
    
    func checkAnswer(pickedNumber:Int){
        
        if(buttonPressed==false){
        
        buttonPressed=true
        for i in (0..<currentQuestion+1)
        {
            if currentQuestion==i && AnswersGame[i]==1 && pickedNum==1 {
                
                buttonOut1.backgroundColor=UIColor.green
                numRight=numRight+1
                quizNameLabel.text="Nice!"
                quizNameLabel.textColor=UIColor.green
                wrongAnswer=false
                break
            }else if(currentQuestion==i && AnswersGame[i]==2 && pickedNum==2){
                buttonOut2.backgroundColor=UIColor.green
                numRight=numRight+1
                quizNameLabel.text="Nice!"
                quizNameLabel.textColor=UIColor.green
                wrongAnswer=false

                break
                
            }else if(currentQuestion==i && AnswersGame[i]==3 && pickedNum==3 ){
               
                buttonOut3.backgroundColor=UIColor.green
                numRight=numRight+1
                quizNameLabel.text="Nice!"
                quizNameLabel.textColor=UIColor.green
                wrongAnswer=false

                break
                
            }else if(currentQuestion==i && AnswersGame[i]==4 && pickedNum==4){
        
                buttonOut4.backgroundColor=UIColor.green
                numRight=numRight+1
                quizNameLabel.text="Nice!"
                quizNameLabel.textColor=UIColor.green
                wrongAnswer=false

                break
                
            }else{
                wrongAnswer=true
                
            }
          
            }
            if (wrongAnswer){
                let questionMissedString = questionTextField.text
                var myAnswer = "\n"+"I answered: "
                questionsMissed.append(questionMissedString!)
            
                switch pickedNumber {
                
                case 1:
                    buttonOut1.backgroundColor=UIColor.red
                    myAnswer.append((buttonOut1.titleLabel?.text)!)
                    
                    break
                case 2:
                    buttonOut2.backgroundColor=UIColor.red
                    myAnswer.append((buttonOut2.titleLabel?.text)!)

                    break
                case 3:
                    buttonOut3.backgroundColor=UIColor.red
                    myAnswer.append((buttonOut3.titleLabel?.text)!)

                    break
                case 4:
                    buttonOut4.backgroundColor=UIColor.red
                    myAnswer.append((buttonOut4.titleLabel?.text)!)

                    break
                default:
                    break
                }
                questionsMissed.append(myAnswer+"\n")
                switch AnswersGame[currentQuestion] {
                case 1:
                    buttonOut1.backgroundColor=UIColor.green
                    break
                case 2:
                    buttonOut2.backgroundColor=UIColor.green
                    break
                case 3:
                    buttonOut3.backgroundColor=UIColor.green
                    break
                case 4:
                    buttonOut4.backgroundColor=UIColor.green
                    break
                default:
                    break
                }
                myAnswer = ""
            }
            
        }
      
        
              
        
        if(currentQuestion+1==amountOfQuestions){
            presentGameOver()
        }
        
        
    }

    
    
    @IBAction func endGame(_ sender: UIButton) {
        
        QuestionsGame.removeAll()
        AnswersG1.removeAll()
        AnswersG2.removeAll()
        AnswersG3.removeAll()
        AnswersG4.removeAll()
        
        performSegue(withIdentifier: "endGame",
                     sender: self)
        
        
        
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        
        if(currentQuestion+1==amountOfQuestions){
            presentGameOver()
            //was currentQuestion+1
         
        }else{
            nextQuestion()
            
            
        }
        
        
    }
    
    @IBOutlet var scoreLabel: UILabel!
   
    
    func presentGameOver(){
        scoreButton.isHidden = false
        
        scoreLabel.text = "\((PFUser.current()?.username)!) got \(numRight) correct out of \(amountOfQuestions) questions right on \(quizName) quiz"
        
    }
    func captureScreen() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
   
    @IBAction func shareScore(_ sender: Any) {
//       socialShare(sharingText: "Just hit \(highscore)! Beat it! #SwypI", sharingImage: UIImage(named: "The screenshot you are saving"), sharingURL: NSURL(string: "http://itunes.apple.com/app/"))
        var missedStuff = "\n"+"I missed these questions: \n"
        var i = 1
        for eachquestion in questionsMissed {
            missedStuff.append(eachquestion)
            i+=1
        }
        let text = "Check out my score!"+" I got \(numRight) correct out of \(amountOfQuestions) on \(quizName)"+missedStuff+"My username is \((PFUser.current()?.username)!) on the SimpleQuizMe iOS app"
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
       
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func nextQuestion(){
        
        
        if(buttonPressed==false){
            let alert = UIAlertController(title: "Try Again",
                                          message:"make sure to press the correct letter",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        quizNameLabel.text=quizTitle
        quizNameLabel.textColor=UIColor.white
        
        wrongAnswer=false
       
        buttonOut1.backgroundColor=UIColor.white
        buttonOut2.backgroundColor=UIColor.white
        buttonOut3.backgroundColor=UIColor.white
        buttonOut4.backgroundColor=UIColor.white
            
        
        currentQuestion=currentQuestion+1
         questionNumText.text = "\(currentQuestion+1) / \(amountOfQuestions)"
       
        buttonPressed=false
            getNewData { () -> () in
                // method two has finished
                self.questionTextField.text=self.tempArray[6]
               
                self.buttonOut1.setTitle( "\(self.tempArray[1])" , for: .normal )
                self.buttonOut2.setTitle( "\(self.tempArray[2])" , for: .normal )
                self.buttonOut3.setTitle( "\(self.tempArray[3])" , for: .normal )
                self.buttonOut4.setTitle( "\(self.tempArray[4])" , for: .normal )
                
                
                
                self.amountOfQuestions = Int(self.tempArray[0])!
                
                self.AnswersGame[self.currentQuestion] = Int(self.tempArray[5])!

            }
       
            
    }
    }
    
}
