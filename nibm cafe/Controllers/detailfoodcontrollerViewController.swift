//
//  detailfoodcontrollerViewController.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-03.
//

import UIKit
import FirebaseStorage

class detailfoodcontrollerViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var foodname: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var documentid: UILabel!
    
    @IBOutlet weak var note: UILabel!
    
    @IBOutlet weak var dislbl: UILabel!
    
    
    var name = ""
    var price2 = ""
    var discrip = ""
    var foodid = ""
    var docid = ""
    var discount = ""
    var cart :[cartitem] = []
    var userId : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userId = UserDefaults.standard.value(forKey: "userId") as! String
        foodname.text = name
        
        price.text = "RS."+price2
        
        note.text = discrip
        documentid.text = docid
        documentid.isHidden = true
        
        if discount == "0"
        {
            dislbl.isHidden = true
        }
        else
        {
            dislbl.text = discount+"%OFF"
        }
        
        loadimage()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false    }
    
    func loadimage() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let path = "foodimages/"+foodid+".jpg"
        
       
        let formattedString = path.replacingOccurrences(of: " ", with: "")
        let islandRef = storageRef.child(formattedString)
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
           print("error")
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.image.image = image
            
            
          }
        }
    }
    
    
    
    @IBAction func addtocart(_ sender: Any) {
        
        if cart.firstIndex(where: {$0.documentId == docid}) != nil {
            
        }
        else
        {
        
        let cartitem = nibm_cafe.cartitem(Name: name, price: Float(price2)!, id: foodid, documentId: docid,qty: 1,singleprice: Float(price2)!,userId: userId)
        
        self.cart.append(cartitem)
        }
        
     
        let next = (storyboard?.instantiateViewController(withIdentifier: "homeSet") as? tabBarController)!

            self.navigationController?.pushViewController(next, animated: true)
        
        next.cart = cart
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSet"
        {
            let secon = segue.destination as! foodsectioncontroller
            
            
            
            secon.cart = cart
        }
    }
    
   

}
