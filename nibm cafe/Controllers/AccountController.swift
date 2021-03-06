//
//  AccountController.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-05.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class AccountController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    var orderId : String = ""
    let db = Firestore.firestore()
    var userid : String = ""
    private let storage = Storage.storage().reference()
    
    
    @IBOutlet weak var userdetailview: UIView!
    
    @IBOutlet weak var userimage: UIImageView!
    
    @IBOutlet weak var editpro: UIView!
    
 
    @IBOutlet weak var userName: UITextField!
    
    
    @IBOutlet weak var contact: UITextField!
    
   
    
 
    @IBOutlet weak var orderdetails: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userimage.image = #imageLiteral(resourceName: "images")
        userName.tag = 10000
        contact.tag = 20000
        
        
        userName.delegate = self
        contact.delegate = self
     
       
        
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
        
       
        
        

        // Do any additional setup after loading the view.
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        let userref2 = self.db.collection("User")
        if textField.tag == 10000
        {
            if userName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                userName.text = Auth.auth().currentUser?.email
            }
            else
            {
                let email = userName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                    if error != nil
                    {
                        print("error")
                    }
                    else
                    {
                        
                        userref2.whereField("UID", isEqualTo: self.userid).getDocuments { (snap, error) in
                            if error != nil
                            {
                                print("faile")
                            }
                            else
                            {
                                for elements in (snap?.documents)! {
                                    let data = elements.documentID
                                    
                                    let updateshowstatus = self.db.collection("User").document(data)
                                    
                                    updateshowstatus.updateData(["email":email]) { (error) in
                                        if error != nil
                                        {
                                           print("error")
                                        }
                                        else
                                        {
                                            print("updated")
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                       
                    }
                })
                
             
              
            }
            
            
        }
        else if textField.tag == 20000
        {
            if contact.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                contact.text = Auth.auth().currentUser?.phoneNumber
            }
            else
            {
                let phnnumber = contact.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            userref2.whereField("UID", isEqualTo: self.userid).getDocuments { (snapget, error) in
                if error != nil{
                    print("error")
                }
                else
                {
                    for element in (snapget?.documents)! {
                        let dataget = element.documentID
                        
                        let updateshowstatus = self.db.collection("User").document(dataget)
                        
                        updateshowstatus.updateData(["phone":phnnumber]) { (error) in
                            if error != nil
                            {
                               print("error")
                            }
                            else
                            {
                                print("updated phone")
                            }
                        }
                    }
                }
                
            }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        for subview in self.orderdetails.subviews {
            
               subview.removeFromSuperview()
            
        }
        
        let user = Auth.auth().currentUser
        
        userid = String(user!.uid)
        
        let userref = db.collection("User")
        
        userref.whereField("UID", isEqualTo: userid).getDocuments { (usersnap, error) in
            
            if error != nil
            {
                print("error")
            }
            else
            {
                let storage = Storage.storage()
                let storageRef = storage.reference()
                for element in (usersnap?.documents)!
                {
                    let data = element.data()
                    
                    self.userName.text = String(data["email"] as! String)
                    self.contact.text = String(data["phone"] as! String)
                    
                    let path = "userimages/" + String(data["image"] as! String)
                    
                    let formattedString = path.replacingOccurrences(of: " ", with: "")
                    
                    let islandRef = storageRef.child(formattedString)
                    
                    islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if error != nil {
                       print("error")
                      } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        
                        if image == nil
                        {
                            
                        }
                        else
                        {
                            self.userimage.image = image
                        }
                       
                        
                
                      }
                    }
                    
                }
            }
            
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
    
    
   
    @IBAction func uploadbtnhit(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
       present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imagedata = image.pngData() else {
            return
        }
        let path:String = "userimages/" + userid + ".png"
        
            storage.child(path).putData(imagedata, metadata: nil) { (_, Error) in
            if Error != nil
            {
                print("erro")
            }
            else
            {
                self.userimage.image = UIImage(data: imagedata)
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
