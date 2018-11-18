//
//  ViewController.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var TFUserNameOutlet: UITextField!
    @IBOutlet weak var TFPasswordOutlet: UITextField!
    @IBOutlet weak var BtnRememberMeOutlet: UIButton!
    @IBOutlet weak var IMGLogo: UIImageView!
    
    var isRememberMeEnabled: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.IMGLogo.layer.cornerRadius = (self.IMGLogo.frame.size.width)/4.0
        self.IMGLogo.layer.masksToBounds = true
        if(UserDefaults.standard.value(forKey: "isRememberMeEnabled") != nil){
            if(UserDefaults.standard.value(forKey: "isRememberMeEnabled") as! Bool){
                DispatchQueue.main.async {
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    UIApplication.shared.keyWindow?.rootViewController = nvc
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Button Action
    @IBAction func BtnRememberMe(_ sender: Any) {
        isRememberMeEnabled = !isRememberMeEnabled
        if(isRememberMeEnabled){
            BtnRememberMeOutlet.setImage(UIImage(named: "check_Box"), for: .normal)
        }else{
            BtnRememberMeOutlet.setImage(UIImage(named: "uncheck_Box"), for: .normal)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if(validateTextFields()){
            if(TFUserNameOutlet.text == "Admin@admin.com" && TFPasswordOutlet.text == "Password"){
                if(isRememberMeEnabled){
                    UserDefaults.standard.set(true, forKey: "isRememberMeEnabled")
                    UserDefaults.standard.set(TFUserNameOutlet.text, forKey: "userName")
                    UserDefaults.standard.set(TFPasswordOutlet.text, forKey: "userPassword")
                }else{
                    UserDefaults.standard.set(false, forKey: "isRememberMeEnabled")
                }
                UserDefaults.standard.synchronize()
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                UIApplication.shared.keyWindow?.rootViewController = nvc
            }else{
                let alertController = UIAlertController(title: "Error", message: "Email Id And Password does not match", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }else{
            let alertController = UIAlertController(title: "Error", message: "Please Enter Valid Email ID and Password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Validations Methods
    func validateTextFields() -> Bool{
        guard (TFUserNameOutlet.hasText && TFPasswordOutlet.hasText && self.isEmailAddressValid(self.TFUserNameOutlet.text ?? "") && self.isPasswordValid(self.TFPasswordOutlet.text ?? "")) else {
            return false
        }
        return true
    }
    
    func isEmailAddressValid(_ emailAddress: String) -> Bool {
        if (emailAddress != "" && emailAddress.count > 5) {
            let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest .evaluate(with: emailAddress)
        } else {
            return false
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool{
        if((password.trimmingCharacters(in: CharacterSet.whitespaces)).count > 3){
            return true
        }
        return false
    }

}

