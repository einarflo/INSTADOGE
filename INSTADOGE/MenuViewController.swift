//
//  MenuViewController.swift
//  INSTADOGE
//
//  Created by Einar Flobak on 06.11.2017.
//  Copyright © 2017 Dogetek. All rights reserved.
//

import UIKit
import Foundation


class ChannelViewCell : UITableViewCell {
    
 
    @IBOutlet weak var channelName: UILabel!
    
}


class MenuViewController: UIViewController, UITabBarDelegate,  UITableViewDataSource, UITableViewDelegate, URLSessionDelegate {
    
    @IBOutlet weak var channelList: UITableView!
    
    var channels = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getChannels()
        channelList.delegate = self
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        tap.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: Any) {
    
    
    
    let alert = UIAlertController(title: "Log out?", message: "Please confirm by clicking ok", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
    
    // Some logic for deauthenticating
    
    let VC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
    self.navigationController?.pushViewController(VC, animated: false)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
    }))
    self.present(alert, animated: true, completion: nil)
    
    }
    func createNewChannel(input: String) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        
        let myUrl = URL(string: "https://www.dogetek.no/api/api.php/channels//");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        // let postString = "name=\(alert.textFields?[0].text! ?? "NONAME")!)";
        // request.httpBody = postString.data(using: .utf8);
        
        let dic = ["name": input]
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
                self.getChannels()
            }
            //print(response as Any)
            
        }
        task.resume()
    }
    
    @IBAction func newChannel(_ sender: Any) {
        let alert = UIAlertController(title: "New channel", message: "Enter the name of the new channel", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Channel name"
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            self.createNewChannel(input: (alert.textFields?[0].text! ?? "NONAME")!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Creation canceled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print("Row: \(row)")
        let chnData = channels[row] as! NSDictionary
        let id = chnData.value(forKey: "id")
        let name = chnData.value(forKey: "name")
        print(chnData.value(forKey: "id")!)
        Session.sharedInstance.setCurrentChnId(id: id as! String)
        Session.sharedInstance.setCurrentChnName(name: name as! String)
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "channelVC") as! ChannelViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChannelViewCell
     
        let channel = channels[indexPath.row] as! NSDictionary
        
        //print(channel.value(forKey: "name") ?? "NONAME")
        cell.channelName.text = channel.value(forKey: "name") as? String
        return cell
    }
    
    func getChannels() {
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        
        let myUrl = URL(string: "https://www.dogetek.no/api/api.php/channels//");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                // Add some error handling
                print(error as Any)
                return
                
            }
            
            if let _data = data
            {
                var json = NSArray()
                do {
                    json = try JSONSerialization.jsonObject(with: _data) as! NSArray
                    
                    print("JSON Output: \(json)")
                    self.channels = json

                        // Update Table View
                    DispatchQueue.main.async {
                        self.channelList.reloadData()
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

