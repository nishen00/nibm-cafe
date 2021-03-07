//
//  ViewController.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-01.
//

import UIKit
import FirebaseAuth
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var phoneNo: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerbtn: UIButton!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let userid = UserDefaults.standard.value(forKey: "userId") as? String
        
        if userid != nil
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeSet") as! UITabBarController

                self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }        // Do any additional setup after loading the view.
    }
    
    func validation() -> String? {
        if Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phoneNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return ""
        }
        else
        {
            return "Requeire fields empty"
        }
        
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
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
    
    
    @IBAction func signupHit(_ sender: Any) {
        
        let phone = phoneNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validation() != ""
        {
            
            
            if email.isEmail && pass.ispassword && phone.isphone
            {
            
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                if err != nil {
//                    self.showToast(message:"Registrasion fail", font: .systemFont(ofSize: 12.0))
                    let alert = UIAlertController(title: "Registration failure", message: "User already Exist", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                         })
                         alert.addAction(ok)
                    self.present(alert, animated: true)
                }
                else
                {
                    let db = Firestore.firestore()
                  
                    let ref =  db.collection("User")
                    
                    let imagename : String? = (result?.user.uid)! + ".png"
                    
                    
                    ref.addDocument(data: ["phone" :phone,"UID" : result!.user.uid , "image":imagename!,"email": result!.user.email!]) { (erro) in
                        if erro != nil
                        {
//                            self.showToast(message:"Registration error ", font: .systemFont(ofSize: 12.0))
                            
                        }
                        else
                        {
                            UserDefaults.standard.set(result?.user.uid, forKey: "userId")
                          
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeSet") as! UITabBarController

                                self.navigationController?.pushViewController(nextViewController, animated: true)
                        }
                    }
                }
            }
            }
            else
            {
                
                if email.isEmail
                {
                    
                }
                else
                {
                let alert = UIAlertController(title: "Registration failure", message: "Invalid Email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.Email.layer.borderWidth = 1.0
                    self.Email.layer.borderColor = UIColor.red.cgColor
                     })
                     alert.addAction(ok)
                self.present(alert, animated: true)
                }
                
                if pass.ispassword
                {
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Registration failure", message: "Password must be Minimum 8 characters at least 1 Alphabet and 1 Number", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.password.layer.borderWidth = 1.0
                        self.password.layer.borderColor = UIColor.red.cgColor
                         })
                         alert.addAction(ok)
                    self.present(alert, animated: true)
                }
                
                if phone.isphone
                {
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Registration failure", message: "Invalid Phone number", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.phoneNo.layer.borderWidth = 1.0
                        self.phoneNo.layer.borderColor = UIColor.red.cgColor
                         })
                         alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Registration failure", message: "Required field empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                 })
                 alert.addAction(ok)
            self.present(alert, animated: true)
        }

        
    }
    

}

extension String {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    private static let __passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    private static let __phonenumberRegex = "^[0-9]{10}$"
    public var isEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    
    public var ispassword: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__passwordRegex)
        return predicate.evaluate(with: self)
    }
    
    public var isphone: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__phonenumberRegex)
        return predicate.evaluate(with: self)
    }
}

