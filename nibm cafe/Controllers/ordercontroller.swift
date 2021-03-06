//
//  ordercontroller.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-05.
//

import UIKit
import Firebase
import FirebaseStorage

class ordercontroller: UIViewController {
    
    
    
    @IBOutlet weak var content: UIView!
    let db = Firestore.firestore()
    var userId :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.value(forKey: "userId") as! String

   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        orderlist()
    }
    
    func orderlist() {
        
        
        for subview in self.content.subviews {
           
               subview.removeFromSuperview()
            
        }
        
        let docRef = db.collection("order")
        docRef.whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if error != nil
            {
                print("error")
            }
            else
            {
                var cons : CGFloat = 120
                var count : Int = 0
                for document in (snapshot?.documents)!
                {
                    if count == 0
                    {
                        cons = 30
                    }
                    
                    let dd = document.data()
                    let statusget = dd["status"] as? Int
                  
                    let viewDemo = UIView()
            //        viewDemo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    viewDemo.backgroundColor = .white
                    viewDemo.tag = count
                    viewDemo.layer.borderWidth = 2.0
                    viewDemo.backgroundColor = .white
                    viewDemo.layer.shadowColor = UIColor.gray.cgColor
                    viewDemo.layer.shadowOpacity = 0.4
                    viewDemo.layer.shadowOffset = CGSize.zero
                    viewDemo.layer.shadowRadius = 6
                    viewDemo.layer.borderColor = UIColor.lightGray.cgColor
                    if statusget == 1
                    {
                    let uiviewclick = UITapGestureRecognizer(target: self, action: #selector (self.viewclickset(_:) ))
                    uiviewclick.view?.tag = count
                    
                    viewDemo.addGestureRecognizer(uiviewclick)
                    }
                    self.content.addSubview(viewDemo)
                  viewDemo.translatesAutoresizingMaskIntoConstraints = false
                    viewDemo.topAnchor.constraint(equalTo: self.content.topAnchor, constant: cons).isActive = true
                    viewDemo.leftAnchor.constraint(equalTo: self.content.leftAnchor, constant: 10).isActive = true
                    viewDemo.rightAnchor.constraint(equalTo: self.content.rightAnchor, constant: -10).isActive = true
                    viewDemo.heightAnchor.constraint(equalToConstant: 90).isActive = true
                    
                    
                    let orderid = UILabel()
                    
                    orderid.textAlignment = .center
                    orderid.text = String(" Order Id " + String(count + 1))
                  
                    orderid.textColor = UIColor.lightGray
                    viewDemo.addSubview(orderid)
                    orderid.translatesAutoresizingMaskIntoConstraints = false
                    orderid.leftAnchor.constraint(equalTo: viewDemo.leftAnchor, constant: 10).isActive = true
                    orderid.centerYAnchor.constraint(equalTo: viewDemo.centerYAnchor).isActive = true
                    
                    
                    
                    let orderidspam = UILabel()
                    
                    orderidspam.textAlignment = .center
                    orderidspam.text = dd["docid"] as? String
                    orderidspam.tag = count + 10
                    orderidspam.textColor = UIColor.lightGray
                    viewDemo.addSubview(orderidspam)
                    orderidspam.translatesAutoresizingMaskIntoConstraints = false
                    orderidspam.leftAnchor.constraint(equalTo: viewDemo.leftAnchor, constant: 10).isActive = true
                    orderidspam.centerYAnchor.constraint(equalTo: viewDemo.centerYAnchor).isActive = true
                    
                    orderidspam.isHidden = true
                    
                    
                    let status = UILabel()
                    
                    status.textAlignment = .center
                  

                    if  statusget == 1
                    {
                    status.text = "Ready To Pick Up"
                        status.textColor = .green
                    }
                    else if statusget == 2
                    {
                    status.text = "Waiting to accept"
                        status.textColor = UIColor.darkGray
                    }
                    else if statusget == 3
                    {
                        status.text = "Preparing Food"
                        status.textColor = UIColor.darkGray
                    }
                    viewDemo.addSubview(status)
                    status.translatesAutoresizingMaskIntoConstraints = false
                    status.rightAnchor.constraint(equalTo: viewDemo.rightAnchor, constant: -10).isActive = true
                    status.centerYAnchor.constraint(equalTo: viewDemo.centerYAnchor).isActive = true
                    if count != 0
                    {
                    cons = cons + 90 + 5
                    }
                    else
                    {
                        cons = 120 + 5
                    }
                    count = count + 1
                    
                }
                
            }
        }
        
        
        
        
        
        
        
       
        
    }
    
    
    @objc func viewclickset(_ sender:UITapGestureRecognizer){
        
        
        let orderid = content.viewWithTag(sender.view!.tag + 10) as! UILabel
        
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![2] as! AccountController
        
        svc.orderId = String(orderid.text!)
        
        self.tabBarController?.selectedIndex = 2
    }
    
    

    

}
