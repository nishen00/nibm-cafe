//
//  AccountController.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-05.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountController: UIViewController {
    
    
    var orderId : String = ""
    let db = Firestore.firestore()
    
    @IBOutlet weak var userdetailview: UIView!
    
    @IBOutlet weak var userimage: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var contact: UILabel!
    
    @IBOutlet weak var orderdetails: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userdetailview.layer.borderWidth = 1.0
        userdetailview.layer.borderColor = UIColor.darkGray.cgColor
        userdetailview.backgroundColor = .white
        userdetailview.layer.shadowColor = UIColor.gray.cgColor
        userdetailview.layer.shadowOpacity = 0.4
        userdetailview.layer.shadowOffset = CGSize.zero
        userdetailview.layer.shadowRadius = 6
        
        
        orderdetails.layer.borderWidth = 1.0
        orderdetails.layer.borderColor = UIColor.darkGray.cgColor
        orderdetails.backgroundColor = .white
        orderdetails.layer.shadowColor = UIColor.gray.cgColor
        orderdetails.layer.shadowOpacity = 0.4
        orderdetails.layer.shadowOffset = CGSize.zero
        orderdetails.layer.shadowRadius = 6
        
        userimage.layer.borderWidth=1.0
        userimage.layer.masksToBounds = false
        
        userimage.layer.cornerRadius = userimage.frame.size.height/2
        userimage.clipsToBounds = true
        
        let user = Auth.auth().currentUser
        
        userName.text = String((user?.email)!)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for subview in self.orderdetails.subviews {
            
               subview.removeFromSuperview()
            
        }
        
        if orderId != ""
        {
        
        var cons : CGFloat = 50
        let docRef = db.collection("order").document(orderId)
        
        docRef.getDocument { (document, error) in
            if let document = document,document.exists{
                
                let dd = document.data()
                let totalfind = dd!["totalAmount"] as! Float
                
               
                let ts =  dd!["dateTime"]  as! Timestamp
                let aDate = ts.dateValue()
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss aa"
                    let formattedTimeZoneStr = formatter.string(from: aDate)
                
                let date = UILabel()
                
                date.textAlignment = .center
                date.text = formattedTimeZoneStr
                date.textColor = UIColor.black
                self.orderdetails.addSubview(date)
                date.translatesAutoresizingMaskIntoConstraints = false
                date.leftAnchor.constraint(equalTo: self.orderdetails.leftAnchor, constant: 10).isActive = true
                date.topAnchor.constraint(equalTo: self.orderdetails.topAnchor, constant: 5).isActive = true
                
                
                let docorderdtl = self.db.collection("orderdtl")
                
                docorderdtl.whereField("orderid", isEqualTo: self.orderId).getDocuments { (snap, error) in
                    
                    if error != nil
                    {
                        print("error")
                    }
                    else
                    {
                        for element in (snap?.documents)! {
                            let data = element.data()
                            
                            let item = UILabel()
                            
                            item.textAlignment = .center
                            item.text = data["Name"] as? String
                            item.textColor = UIColor.black
                            self.orderdetails.addSubview(item)
                            item.translatesAutoresizingMaskIntoConstraints = false
                            item.leftAnchor.constraint(equalTo: self.orderdetails.leftAnchor, constant: 30).isActive = true
                            item.topAnchor.constraint(equalTo: date.bottomAnchor, constant: cons).isActive = true
                            
                            
                            let qty = data["qty"] as? Int
                            let singleprice = data["singleprice"] as? Int
                            
                            let convertstrinprice = String(singleprice!)
                            let convertstrinqty = String(qty!)
                            
                            let final = convertstrinqty + " X " + "Rs." + convertstrinprice
                            
                            let price = UILabel()
                            
                            price.textAlignment = .center
                            price.text = final
                            price.textColor = UIColor.black
                            self.orderdetails.addSubview(price)
                            price.translatesAutoresizingMaskIntoConstraints = false
                            price.rightAnchor.constraint(equalTo: self.orderdetails.rightAnchor, constant: -30).isActive = true
                            price.topAnchor.constraint(equalTo: date.bottomAnchor, constant: cons).isActive = true
                            
                            cons = cons + 50
                        }
                        
                        
                        
                        let total = UILabel()
                        let totget = String("TOTAL: Rs." + String(totalfind))
                        total.textAlignment = .center
                        total.text = totget
                        total.textColor = UIColor.black
                        self.orderdetails.addSubview(total)
                        total.translatesAutoresizingMaskIntoConstraints = false
                        total.rightAnchor.constraint(equalTo: self.orderdetails.rightAnchor, constant: -30).isActive = true
                        total.topAnchor.constraint(equalTo: date.bottomAnchor, constant: cons + 5).isActive = true
                        
                        
                        
                        
                        
                    
                        
                        
                        
                        
                    }
                }
                
                
                
                
               
            }
        }
        }
        
        
       
        
        
        
        
        
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
