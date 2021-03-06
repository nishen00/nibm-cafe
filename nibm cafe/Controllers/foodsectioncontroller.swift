//
//  foodsectioncontroller.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-02.
//

import UIKit
import Firebase
import FirebaseStorage

class foodsectioncontroller: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
   
    
    @IBOutlet weak var ordersavebtn: UIButton!
    @IBOutlet weak var cartview: UIView!
    
    
    @IBOutlet weak var columnview: UIView!
    
    @IBOutlet weak var countitm: UILabel!
    var food : [food] = []
    var cart : [cartitem] = []
    var total : Float = 0
    var userId :String = ""
    
    let db = Firestore.firestore()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let bar = tabBarController as! tabBarController
        self.cart = bar.cart
        userId = UserDefaults.standard.value(forKey: "userId") as! String
        self.navigationController?.navigationItem.hidesBackButton = true
        
        cartsection()
        
       
        tableview.delegate = self
        tableview.dataSource = self
        
        
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func cartsection(){
      
        var cons : CGFloat = 10
        var itemcount : Int = 0
        var tagp : Int = 1
       
       
        
        for element in cart
        {
            
            total = total + Float(element.price)
          
            
            let label = UILabel()
            label.textAlignment = .center
            label.text = element.Name
            
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            
            self.cartview.addSubview(label)
            label.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            
            
            let labeldocumentid = UILabel()
           
            labeldocumentid.textAlignment = .center
            labeldocumentid.text = element.documentId
            
            labeldocumentid.translatesAutoresizingMaskIntoConstraints = false
            labeldocumentid.tag = tagp + 10
            
            
            self.cartview.addSubview(labeldocumentid)
            labeldocumentid.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            labeldocumentid.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
            
            labeldocumentid.isHidden = true
            
            
            let lable2 = UILabel()
            lable2.text = String( element.qty)
            lable2.textAlignment = .center
            lable2.translatesAutoresizingMaskIntoConstraints = false
            self.cartview.addSubview(lable2)
            
            lable2.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            lable2.tag = tagp - 5

            
            lable2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            
            let lable3 = UILabel()
            lable3.text = String( element.price)
            lable3.textAlignment = .center
            lable3.translatesAutoresizingMaskIntoConstraints = false
            lable3.tag = tagp - 25
            self.cartview.addSubview(lable3)
            
            lable3.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            
            lable3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            
            
            let singleprice = UILabel()
            singleprice.text = String( element.singleprice)
            singleprice.textAlignment = .center
            singleprice.translatesAutoresizingMaskIntoConstraints = false
            singleprice.tag = tagp-10
            self.cartview.addSubview(singleprice)
            
            singleprice.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            
            singleprice.rightAnchor.constraint(equalTo: lable3.leftAnchor, constant: -10).isActive = true
            
            singleprice.isHidden = true
            
            
            let buttonnegative = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            buttonnegative.backgroundColor = .black
            buttonnegative.setTitle("-", for: .normal)
            buttonnegative.backgroundColor = .clear
            buttonnegative.layer.cornerRadius = 5
            buttonnegative.layer.borderWidth = 1
            let lead2:String = "44"
            let settagto2 = String(lead2 + String(tagp))
            buttonnegative.tag = Int(settagto2)!
            
            buttonnegative.addTarget(self, action: #selector(processButtonClickEvent), for: UIControl.Event.touchDown)
//            buttonnegative.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            buttonnegative.translatesAutoresizingMaskIntoConstraints = false
              self.cartview.addSubview(buttonnegative)
            
            buttonnegative.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            
            buttonnegative.rightAnchor.constraint(equalTo: lable2.leftAnchor, constant: -10).isActive = true
            
            
            let buttonplus = UIButton()
            buttonplus.backgroundColor = .black
            buttonplus.setTitle("+", for: .normal)
            buttonplus.backgroundColor = .clear
            buttonplus.layer.cornerRadius = 5
            buttonplus.layer.borderWidth = 1
            let lead:String = "22"
            let settagto = String(lead + String(tagp))
            buttonplus.tag = Int(settagto)!
                
            buttonplus.addTarget(self, action: #selector(processButtonClickEvent), for: UIControl.Event.touchDown)
            
//            buttonnegative.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            buttonplus.translatesAutoresizingMaskIntoConstraints = false
              self.cartview.addSubview(buttonplus)
            
            buttonplus.topAnchor.constraint(equalTo: columnview.bottomAnchor, constant: cons).isActive = true
            
            buttonplus.leftAnchor.constraint(equalTo: lable2.rightAnchor, constant: 10).isActive = true
            
            
            
            
            cons = cons + 30
            itemcount = itemcount + 1
            tagp = tagp + 1
            
            
            
            
        }
        
        var totalstring : String = ""
        totalstring = "Order (Rs." + String(total) + ")"
        
        ordersavebtn.setTitle(totalstring, for: .normal)
        countitm.text = String(itemcount)+" Items"
    }
    
    
    
    @objc func processButtonClickEvent(srcObj : UIButton) -> Void{
        
       
        
        let tag : String = String(srcObj.tag)
        
        let first4 = String(tag.prefix(2))
       
        
        
        if first4 == "44"
        {
            let tagid : Int = Int(tag.dropFirst(2))!
        let singleprice = cartview.viewWithTag(tagid - 10) as! UILabel
        let documentid = cartview.viewWithTag(tagid + 10) as! UILabel
        let qty = cartview.viewWithTag(tagid - 5) as! UILabel
        let exactprice = cartview.viewWithTag(tagid - 25) as! UILabel

        let qtyset = (qty.text! as NSString).intValue
        let saleprice = (singleprice.text! as NSString).floatValue
        
            

       if qtyset != 0
       {
        qty.text = String(qtyset-1)
        exactprice.text = String(saleprice * Float(qtyset-1))
        if let index = cart.firstIndex(where: {$0.documentId == documentid.text}) {
            cart[index].qty = Int(qtyset-1)
            cart[index].price =  Float(saleprice * Float(qtyset-1))
        }
        
        
        total = total - Float(saleprice)
       
        let totalstring = "Order (Rs." + String(total) + ")"
        
        ordersavebtn.setTitle(totalstring, for: .normal)
       }

        }
        
        if first4 == "22"
        {
            let tagid : Int = Int(tag.dropFirst(2))!
        let singleprice = cartview.viewWithTag(tagid - 10) as! UILabel
            let documentid = cartview.viewWithTag(tagid + 10) as! UILabel
        let qty = cartview.viewWithTag(tagid - 5) as! UILabel
        let exactprice = cartview.viewWithTag(tagid - 25) as! UILabel

        let qtyset = (qty.text! as NSString).intValue
        let saleprice = (singleprice.text! as NSString).floatValue

       
        qty.text = String(qtyset+1)
        exactprice.text = String(saleprice * Float(qtyset+1))
            
            if let index = cart.firstIndex(where: {$0.documentId == documentid.text}) {
                cart[index].qty = Int(qtyset+1)
                cart[index].price =  Float(saleprice * Float(qtyset+1))
            }
            total = total + Float(saleprice)
           
            let totalstring = "Order (Rs." + String(total) + ")"
            
            ordersavebtn.setTitle(totalstring, for: .normal)
        
        }
       
        
        
       
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        food.removeAll()
        let docRef = db.collection("Food")
        docRef.getDocuments { (snapshot, error) in
            if error != nil
            {
                print("error")
            }
            else
            {
                for document in (snapshot?.documents)!
                {
                    let dd=document.data()
                   let name = dd["Name"] as! String
                    let discrip = dd["description"] as! String
                    let price = dd["price"] as! Float
                    let discount = dd["discount"] as! Int
                    let foodId = dd["id"] as! String
                    let docid = dd["dicid"] as! String
                    
                  
                    
                    
                    
                    let foodget = nibm_cafe.food(Name:name,discription: discrip,price: price,discount: discount,id: foodId,documentId: docid)
                    
                    self.food.append(foodget)
                    
                    
                    
                }
                
                self.tableview.reloadData()
               
              
               
                
               
            }
            
            
        }
    }
    
    
    
    
    @IBAction func orederevent(_ sender: Any) {
        
        
        if total>0
        {
        
        let db = Firestore.firestore()
      
        let ref =  db.collection("order").document()
        
            
            
        
            ref.setData(["userId":userId,"docid": ref.documentID,"totalAmount":total,"dateTime":Date(),"status":1]) { (error) in
            if error != nil
            {
             
            }
            else
            {
               
                for element in self.cart
               {
                    let ref2 =  db.collection("orderdtl").document()
                    ref2.setData(["itemcode":element.documentId,"qty":element.qty,"singleprice":element.singleprice,"userid":element.userId,"orderid":ref.documentID,"selfdocid": ref2.documentID,"Name":element.Name,"date": Date()]) { (err) in
                        if err != nil{
                            
                        }
                        else
                        {
                            
                        }
                    }
               }
                
                self.showToast(message:"order successfully", font: .systemFont(ofSize: 12.0))
                self.total = 0
                self.cart.removeAll()
                print(self.cart.count)
                self.cartsection()
                
                for subview in self.cartview.subviews {
                    if subview.tag != 10000
                    {
                       subview.removeFromSuperview()
                    }
                }
                
                self.tabBarController?.selectedIndex = 1
                
                
               
            }
            
        }
        }
        else
        {
            self.showToast(message:"please select food item first!!", font: .systemFont(ofSize: 12.0))
        }
        }
    
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-200, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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

extension foodsectioncontroller : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case tableview:
            let next = (storyboard?.instantiateViewController(withIdentifier: "detailfoodcontrollerViewController") as? detailfoodcontrollerViewController)!
            
            self.navigationController?.pushViewController(next, animated: true)
            let foo = food[indexPath.row]
            next.name = foo.Name
            next.price2 = String( foo.price )
            next.discrip = food[indexPath.row].discription
            next.foodid = food[indexPath.row].id
            next.docid = food[indexPath.row].documentId
            next.discount = String(food[indexPath.row].discount)
            next.cart = cart
            
            
            
        default:
            print("went wrong")
        }
        
        
        
    }
}

extension foodsectioncontroller : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        
        
        
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch tableView {
        case tableview:
            let foo = food[indexPath.row]
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! tablecellcontrollerTableViewCell
            
            cell.setfood(food: foo)
        
        
        return cell
            
       
        default:
            let cell2 = UITableViewCell()
            return cell2
        }
        }
    
}

