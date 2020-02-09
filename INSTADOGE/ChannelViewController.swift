//
//  ChannelViewController.swift
//  INSTADOGE
//
//  Created by Einar Flobak on 06.11.2017.
//  Copyright © 2017 Dogetek. All rights reserved.
//

import Foundation
import UIKit

class MyMessagesViewCell : UITableViewCell {


    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!
    
    
}

class ForeignMessagesViewCell : UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!
    
}


class ChannelViewController: UIViewController, UITabBarDelegate,  UITableViewDataSource, UITableViewDelegate, URLSessionDelegate  {
    
    @IBOutlet weak var messagesTable: UITableView!
    var messages = NSArray()
    var chnId = String()
    var userId = String()
    var userName = String()
   
    
    @IBOutlet weak var chnNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var user = Session.sharedInstance.getUserInfo() as! NSDictionary
        print(user)
        var userId1 = user.value(forKey: "id")!
        print(userId1)
        var userName1 = user.value(forKey: "username")!
        print(userId1)
        self.userId = userId1 as! String
        self.userName = userName1 as! String
        self.chnId = Session.sharedInstance.getCurrentChnId() as! String
        self.chnNameLabel.text = Session.sharedInstance.getCurrentChnName()
        getMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backtoMenu(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print("Row: \(row)")
//        let chnData = channels[row] as! NSDictionary
//        let id = chnData.value(forKey: "id")
//        let name = chnData.value(forKey: "name")
//        print(chnData.value(forKey: "id")!)
//        Session.sharedInstance.setCurrentChnId(id: id as! String)
//        Session.sharedInstance.setCurrentChnName(name: name as! String)
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "channelVC") as! ChannelViewController
//        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row] as! NSDictionary
        if ((message.value(forKey: "user_id") as! String) == (userId)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mine") as! MyMessagesViewCell
            cell.username.text = ((message.value(forKey: "username") ?? "-") as! String)
            cell.message.text = ((message.value(forKey: "content") ?? "-") as! String)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "foreign") as! ForeignMessagesViewCell
            cell.username.text = ((message.value(forKey: "username") ?? "-") as! String)
            cell.message.text = ((message.value(forKey: "content") ?? "-") as! String)
            return cell
        }
        
        
        
    }
    
    @IBAction func newMessage(_ sender: Any) {
        let alert = UIAlertController(title: "New message", message: "Enter text below", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Your message"
        }
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            self.sendNewMessage(input: (alert.textFields?[0].text! ?? "empty")!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Creation canceled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func sendNewMessage(input: String) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        
        let myUrl = URL(string: "https://www.dogetek.no/api/api.php/channel_posts//");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        // let postString = "name=\(alert.textFields?[0].text! ?? "NONAME")!)";
        // request.httpBody = postString.data(using: .utf8);
        
        let dic = ["channel_id": chnId,"user_id": userId, "username": userName,"content": input]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        }
        catch {
            // Add some error handling
        }
        
        //print(request)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                // Add some error handling
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                self.getMessages()
            }
            //print(response as Any)
            
        }
        task.resume()
    }
    
    
    func getMessages() {
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        
        let myUrl = URL(string: "https://www.dogetek.no/api/api.php/channel_posts/" + chnId + "/");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                // Add some error handling
                print(error as Any)
                return
                
            }
            print(response as Any)
            
            if let _data = data
            {
                var json = NSArray()
                do {
                    json = try JSONSerialization.jsonObject(with: _data) as! NSArray
                    
                    print("JSON Output: \(json)")
                    self.messages = json
                    
                    // Update Table View
                    DispatchQueue.main.async {
                        self.messagesTable.reloadData()
                    }
                    
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
}

