//
//  LoginViewController.swift
//  BoWang
//
//  Created by zhe on 2017/9/21.
//  Copyright © 2017年 Microsoft. All rights reserved.
//


//test for uploader at github 
import Foundation
import UIKit

protocol ToDoItemDelegate4 {
    func didSaveItem(_ theUser: String, _ bookId: String)
}

class LoginViewController: UIViewController,  UIBarPositioningDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    

    
    @IBOutlet weak var passwordText: UITextField!

    
    
    var itemTable2 = (UIApplication.shared.delegate as! AppDelegate).client.table(withName: "book_users")
    
    var itemTable = (UIApplication.shared.delegate as! AppDelegate).client.table(withName: "login")
    var bookIdList = NSMutableArray()
        
    var loginName = ""
    var list = NSMutableArray()
    var list2 = NSMutableArray()
    var list3 = NSMutableArray()
    var dicClient = [String:Any]()
    var dicClient2 = [String:Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("99999999999999999999999999")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let client = delegate.client
        itemTable = client.table(withName: "login")
        
        itemTable.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if !self.list.contains("\(item["email"]!)"){
                        self.list.add("\(item["email"]!)")
                    }
                    
                    self.dicClient["email"] = "\(item["email"]!)"
                    self.dicClient["password"] = "\(item["password"]!)"
                    
                    if !self.list2.contains(self.dicClient){
                        self.list2.add(self.dicClient)
                    }
                }
            }
        }
        UserDefaults.standard.set(list2, forKey: "theUserData")
        UserDefaults.standard.set(list, forKey: "theEmailData")
        print("ffffffffffff : ", list)
        print("nnnnnnnnnnnn : ", list2)
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let client = delegate.client
        itemTable = client.table(withName: "login")
        
        itemTable.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if !self.list.contains("\(item["email"]!)"){
                        self.list.add("\(item["email"]!)")
                    }
                    
                    self.dicClient["email"] = "\(item["email"]!)"
                    self.dicClient["password"] = "\(item["password"]!)"
                    
                    if !self.list2.contains(self.dicClient){
                        self.list2.add(self.dicClient)
                    }
                }
            }
        }
        UserDefaults.standard.set(list2, forKey: "theUserData")
        UserDefaults.standard.set(list, forKey: "theEmailData")

    }

    
    
    @IBAction func loginButton(_ sender: UIButton) {
        viewDidLoad()
        self.setNeedsFocusUpdate()
        //if UserDefaults.standard.array(forKey: "theEmailData") != nil{
            //list = UserDefaults.standard.array(forKey: "theEmailData")! as! NSMutableArray
        //}
        //if UserDefaults.standard.array(forKey: "theUserData") != nil{
            //list2 = UserDefaults.standard.array(forKey: "theUserData")! as! NSMutableArray
        //}
        
        
        let userEmail = emailText.text
        let userPassword = passwordText.text
        
        //send 'email' and 'password' to server
        //here just read email and password
        self.dicClient["email"] = userEmail
        self.dicClient["password"] = userPassword
        print("the list isssssssss : ", list)
        print("the list2 isrrrrrrrrrrrrr : ", list2)
        if list.contains(userEmail){
            if list2.contains(dicClient){
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
            }
            else{
                displayMyAlertMessage(userMessage: "Wrong Password!")
                
                return
            }
        }
        else {
            displayMyAlertMessage(userMessage: "The name does not exist!")
            
            return
        }
        
        UserDefaults.standard.set(userEmail, forKey: "userRegistEmail")
        
        performSegue(withIdentifier: "login", sender: nil)
        

    }
    

    func displayMyAlertMessage(userMessage: String)  {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
