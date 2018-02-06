//
//  Register.swift
//  Curb Alert
//
//  Created by James Hunt on 7/6/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKLoginKit
import FacebookLogin
var usernameTitle = ""


class Register: UIViewController, FBSDKLoginButtonDelegate {
    var dict : [String : AnyObject]!
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameButton: UITextField!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var confirmPasswordButton: UITextField!
    @IBOutlet weak var emailAddressButton: UITextField!
    
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        //adding it to view
        view.addSubview(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regiserButtonPressed(_ sender: Any) {
        registerUser()
        
    }
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func registerUser() {
        // Defining the user object
        let user = PFUser()
        let username1 = usernameButton.text
        let password1 = passwordButton.text
        
        
        let username2 = username1?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let password2 = password1?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        
        user.username = username2
        user.password = password2
        
        
        
        
       
        
        
        
        
        // Signing up using the Parse API
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error as NSError? {
                let errorString = error.userInfo["error"] as? NSString
                // In case something went wrong, use errorString to get the error
                print(errorString!)
                self.alert(message: errorString!, title: "Error")
            } else {
                //self.alert(message: "Registered successfully", title: "Registering")
                usernameTitle = self.usernameButton.text!
                self.performSegue(withIdentifier: "registerSeg", sender: self)
            }
        }
        
        
    }
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
