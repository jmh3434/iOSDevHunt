//
//  TableVC.swift
//  QuizMe
//
//  Created by James Hunt on 3/8/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class TableVC : UITableViewController {
    var handle:FIRDatabaseHandle?
    var ref:FIRDatabaseReference?
    var QuestionsGame = ["questionsgame"]
    var tempArray:[String] = []
    var myArray:[String] = []
    var AnswersGame:Array<Int>=Array()
    var AnswersG1:Array<String>=Array()
    var AnswersG2:Array<String>=Array()
    var AnswersG3:Array<String>=Array()
    var AnswersG4:Array<String>=Array()
    
    @IBOutlet var tableview: UITableView!
    
    typealias FinishedDownload = () -> ()
    

    var quizName = ""
    var quickStart = false
    
    override func viewDidLoad() {
        
        getNewData { () -> () in
            
            self.tableview.reloadData()
        }
        
    
        
    }
    func reloadData(){
        tableview.reloadData()
    }
    
    func getNewData(completion: @escaping () -> ()){
        myList.removeAll()
        self.tempArray.removeAll()
        ref = FIRDatabase.database().reference()
        //handle = ref?.child("users").observe(.value, with: {(snapshot) in
        handle = ref?.child("\(usernameTitle)").observe(.value, with: {(snapshot) in

        
            
            let value = snapshot.value as? NSDictionary
            
            var nameOfQuizes = value!.allKeys 
            for i in (0..<nameOfQuizes.count){
               
                myList.append(nameOfQuizes[i] as! String)
                self.tableview.reloadData()
            }
            completion()
            
            
            
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        quizName = (currentCell.textLabel?.text!)!
        quizTitle = quizName
        
        
        
                  performSegue(withIdentifier: "quickStart",
                          sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let svc = segue.destination as! GameTime;
            quickStart = true
        
        
            svc.quickStart = quickStart
            svc.quizName = quizName
        
        
    }
   
    
}
