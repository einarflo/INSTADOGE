//
//  LoginViewController.swift
//  INSTADOGE
//
//  Created by Einar Flobak on 06.11.2017.
//  Copyright © 2017 Dogetek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, URLSessionDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordInput.delegate = self
        usernameInput.delegate = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameInput {
            passwordInput.becomeFirstResponder()
        }
        else if textField == passwordInput {
//            textField.resignFirstResponder()
            doLogin((Any).self)
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func doLogin(_ sender: Any) {
        
        // Some logic
        
        getLogin(username: (usernameInput.text)!)
        
        
        
    }
    
    @IBAction func createNewUser(_ sender: Any) {
       
        if let url = URL(string: "https://www.dogetek.no/intraDoge/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func getLogin(username: String)  {
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        
        let myUrl = URL(string: "https://www.dogetek.no/api/api.php/users/" + username + "/");
        //print(myUrl)
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            //var json = NSArray()
            if error != nil
            {
                // Add some error handling
                print(error as Any)
                return
                
            }
            
            if let _data = data
            {
                
                do {
                    var jsonResult: NSDictionary
                    try jsonResult = JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    self.validateLogin(data: jsonResult)
                }
                catch {
                    // Add some error handling
                
                }
                
            }
            else
            {
                // Add some error handling
               
            }
            
        }
        task.resume()
    }
    
    func validateLogin(data: NSDictionary) {
        print(data)
        print(data.value(forKey: "username")!)
        //let pass = passwordInput.text
        let user = usernameInput.text
        if ((data.value(forKey: "username")! as! String) == user) {
            Session.sharedInstance.setUserInfo(details: data)
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
}

