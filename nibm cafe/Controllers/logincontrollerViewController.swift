//
//  logincontrollerViewController.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-01.
//

import UIKit
import FirebaseAuth

class logincontrollerViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userid = UserDefaults.standard.value(forKey: "userId") as? String
        
        if userid != nil
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeSet") as! UITabBarController

                self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
        

        // Do any additional setup after loading the view.
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
    
    func validation() -> String? {
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" 
        {
            return ""
        }
        else
        {
            return "Requeire fields empty"
        }
        
    }
    
    
    @IBAction func loginhit(_ sender: Any) {
        
        if validation() != ""
        {
            let emailget = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordget = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: emailget, password: passwordget) { (Result, Error) in
                if Error != nil
                {
                    self.showToast(message:"invalid Authentication", font: .systemFont(ofSize: 12.0))
                }
                else
                {
                    UserDefaults.standard.set(Result?.user.uid, forKey: "userId")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeSet") as! UITabBarController

                        self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
            
            
        }
        else
        {
            self.showToast(message:"requeied field empty!!", font: .systemFont(ofSize: 12.0))
        }
        
    }
    
     

}
