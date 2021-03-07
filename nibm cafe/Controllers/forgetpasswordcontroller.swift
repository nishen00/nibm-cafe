//
//  forgetpasswordcontroller.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-07.
//

import UIKit
import FirebaseAuth



class forgetpasswordcontroller:
    
    UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func sendhit(_ sender: Any) {
        
        let emailget = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if emailget.isEmail {
        
        Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
           if error != nil
           {
              print ("error")
           }
            else
           {
            let alert = UIAlertController(title: "Reset Email", message: "Please Check your Email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.email.layer.borderWidth = 1.0
                self.email.layer.borderColor = UIColor.red.cgColor
                 })
                 alert.addAction(ok)
            self.present(alert, animated: true)
           }
        }
        }
        
        else
        {
            let alert = UIAlertController(title: "Reset Email", message: "Invalid Email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.email.layer.borderWidth = 1.0
                self.email.layer.borderColor = UIColor.red.cgColor
                 })
                 alert.addAction(ok)
            self.present(alert, animated: true)
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


