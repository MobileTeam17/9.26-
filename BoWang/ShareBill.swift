//
//  Report.swift
//  BoWang
//
//  Created by Peach on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class ShareBill: UIViewController,  UIBarPositioningDelegate, UITextFieldDelegate, ToDoItemDelegate  {
    
    var list = NSMutableArray()
    var dicClient = [String:Any]()
    var refresh : UIRefreshControl!
    var value = ""
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var itemTable = (UIApplication.shared.delegate as! AppDelegate).client.table(withName: "table2")
    var owner = ""
    var loginName = UserDefaults.standard.string(forKey: "userRegistEmail")
    var bookId = ""
    var sum : Double = Double()
    var cost = NSMutableArray()
    
    
    @IBOutlet weak var hello: UILabel!
    @IBOutlet weak var SUM: UILabel!
    @IBOutlet weak var ShareBill: UILabel!
    
    
    
    override func viewDidLoad(){
    
        if UserDefaults.standard.string(forKey: loginName!) != nil{
            bookId = UserDefaults.standard.string(forKey: loginName!)!
        }
        
        hello.text = "  Hello:  \(loginName!) !  welcome to the app"
        refresh = UIRefreshControl()
      
        
        list = NSMutableArray()
  
        refresh.backgroundColor = UIColor.darkGray
        refresh.attributedTitle = NSAttributedString(string: "reload the bill information")
        refresh.addTarget(self, action: #selector(billListAndDetail.refreshData(_:)), for: UIControlEvents.valueChanged)
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let client2 = delegate.client
        itemTable = client2.table(withName: "billListAndDetails")
        itemTable.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if self.bookId == ""{
                    }
                    else{
                        if "\(item["deleted"]!)" == "0"{
                            if "\(item["accountBookId"]!)" == self.bookId {
                                self.dicClient["id"] = "\(item["id"]!)"
                                self.dicClient["label"] = "\(item["label"]!)"
                                self.dicClient["createdAt"] = "\(item["createdAt"]!)"
                                self.dicClient["theCost"] = "\(item["theCost"]!)"
                                self.dicClient["updatedAt"] = "\(item["updatedAt"]!)"
                                self.dicClient["spendBy"] = "\(item["spendBy"]!)"
                                self.sum += Double(item["theCost"] as! String)!
                                //print(self.sum)
                                //print(self.dicClient["spendBy"])
                                if !self.list.contains(self.dicClient){
                                    self.list.add(self.dicClient)
                                }
                            }
                        }
                    }
                    self.SUM.text = String(self.sum)
//                    
//                    var user = NSMutableArray()
//                    for u in user{
//                        
//                        if (self.dicClient["spendBy"] != nil) && !(array.contains(self.dicClient["spendBy"] as! String )){
//                            print(self.dicClient["spendBy"] as! String)
//                            array.add(self.dicClient["spendBy"] as! String)
//                            print(array)
//                    }
                    
                    //print(array)
                }
              
            }
        }
        
        print("the transfer bookid is : ", self.bookId)
        
    }
    
    
    
    func share(){
        
        
    
    
    
    }
    
    func refreshData(_ sender: UIRefreshControl!){
        
        refresh.endRefreshing()
    }
    
    
    
    

    
    func didSaveItem(_ label: String, _ theCost: String, _ describetion: String)
    {
        if label.isEmpty {
            return
        }
        if theCost.isEmpty {
            return
        }
        if describetion.isEmpty {
            return
        }
        
        
        // We set created at to now, so it will sort as we expect it to post the push/pull
        let itemToInsert = ["label": label, "theCost": theCost, "owner": owner,"describ":describetion, "__createdAt": Date(), "spendBy": loginName, "accountBookId": bookId] as [String : Any]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.itemTable.insert(itemToInsert) {
            
            (item, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error != nil {
                print("Error: " + (error! as NSError).description)
            }
        }
        
        
        
        self.dicClient["label"] = "\(itemToInsert["label"]!)"
        self.dicClient["theCost"] = "\(itemToInsert["theCost"]!)"
        self.dicClient["createdAt"] = "\(itemToInsert["__createdAt"]!)"
        self.dicClient["spendBy"] = loginName
        self.dicClient["accountBookId"] = bookId
        
        self.list.add(self.dicClient)
        
        
    }
    
    
    
    
}
