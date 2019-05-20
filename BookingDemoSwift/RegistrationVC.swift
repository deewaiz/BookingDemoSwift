//
//  RegistrationVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 11.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationVC: UIViewController {
    
    let URL_USER_REGISTER = "http://localhost/test/v1/register.php"
    let URL_USER_LOGIN = "http://localhost/test/v1/login.php"


    @IBOutlet weak var phoneOrEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneMessage: UILabel!
    @IBOutlet weak var passwordMessage: UILabel!
    
    let kAccountID = "ID"
    let kAccountPhone = "phone"
    let kAccountEmail = "eMail"
    let kAccountPassword = "password"
    
    var passwordTop: NSLayoutConstraint = NSLayoutConstraint()
    var registerTop: NSLayoutConstraint = NSLayoutConstraint()
    
    var phoneOrEmailOk: Bool = false
    var passwordOk: Bool = false
    
////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //eraseUserData(); return
        
        phoneMessage.alpha = 0
        
        passwordTop = NSLayoutConstraint(item: passwordField, attribute: .top, relatedBy: .equal, toItem: phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 8)
        registerTop = NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: passwordField, attribute: .bottom, multiplier: 1.0, constant: 8)
        
        NSLayoutConstraint.activate([passwordTop, registerTop])
        self.navigationController?.navigationBar.frame.origin.y = -44
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.frame.origin.y = -44
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, animations: { self.navigationController?.navigationBar.frame.origin.y = 20 })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.5, animations: { self.navigationController?.navigationBar.frame.origin.y = -44 })
        self.navigationController?.isNavigationBarHidden = true
    }
    
// MARK: - Actions
    @IBAction func actionRegister(_ sender: Any) {

        let parameters: Parameters = [
            "email": phoneOrEmailField.text!,
            "password": passwordField.text!
        ]
        
        let myUserDefaults: UserDefaults = UserDefaults()
        
        checkPhoneOrEmail()
        
        checkPassword()
        
        if (phoneOrEmailOk == true) && (passwordOk == true) {
            
            Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseString {
                response in
                var registerStr = response.result.value
                registerStr?.remove(at: (registerStr?.startIndex)!)
                if let result = registerStr {
                    let jsonData = self.convertToDictionary(text: result)! as NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Bool
                    
                    if !error {
                        Alamofire.request(self.URL_USER_LOGIN, method: .post, parameters: parameters).responseString {
                            response in
                            var loginStr = response.result.value
                            loginStr?.remove(at: (loginStr?.startIndex)!)
                            if let result = loginStr {
                                
                                let jsonData = self.convertToDictionary(text: result)! as NSDictionary
                                
                                if(!(jsonData.value(forKey: "error") as! Bool)) {
                                    
                                    let user = jsonData.value(forKey: "user") as! NSDictionary
                                    let userId = user.value(forKey: "id") as! Int
                                    
                                    myUserDefaults.set(userId, forKey: self.kAccountID)
                                    myUserDefaults.set(self.phoneOrEmailField.text, forKey: self.kAccountEmail)
                                    myUserDefaults.set(self.passwordField.text, forKey: self.kAccountPassword)
                                    
                                    print(loginStr!)
                                    print(myUserDefaults.object(forKey: self.kAccountID)!)
                                    print(myUserDefaults.object(forKey: self.kAccountEmail)!)
                                    print(myUserDefaults.object(forKey: self.kAccountPassword)!)
                                    
                                    self.performSegue(withIdentifier: "registerDone", sender: self)
                                } else {
                                    print("Invalid username or password")
                                }
                            }
                        }
                    } else {
                        print(jsonData.value(forKey: "message") as! String? as Any)
                    }
                    //self.labelMessage.text = jsonData.value(forKey: "message") as! String?
                    //print(jsonData.value(forKey: "message") as! String?)
                }
                
            }
            
            //saveUserData()
            
            //performSegue(withIdentifier: "registerDone", sender: self)
        }
    }
    
// MARK: - UserDefaults
    func saveUserData() {
        
        let myUserDefaults: UserDefaults = UserDefaults.standard
        
        //myUserDefaults = UserDefaults.standard
        
        //NSMutableArray()
        
        
        if validatePhone(phoneStr: phoneOrEmailField.text! as NSString) {
            myUserDefaults.set(self.phoneOrEmailField.text, forKey: kAccountPhone)
            NSLog("Phone ok")
        } else {
            myUserDefaults.set(self.phoneOrEmailField.text, forKey: kAccountEmail)
            NSLog("Mail ok")

        }
        myUserDefaults.set(self.passwordField.text, forKey: kAccountPassword)
        
        myUserDefaults.synchronize()
    }
    
    func eraseUserData() {
        
        let myUserDefaults: UserDefaults
        
        myUserDefaults = UserDefaults.standard
        
        myUserDefaults.set("", forKey: kAccountPhone)
        myUserDefaults.set("", forKey: kAccountEmail)
        myUserDefaults.set("", forKey: kAccountPassword)
    }
    
// MARK: - Checking
    func checkPhoneOrEmail() {
        
        if phoneOrEmailField.text == "" && phoneMessage.text == "" {
            UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneMessage(str: "Введите телефон или E-Mail") })
            phoneOrEmailOk = false
            return
        }
        if (phoneOrEmailField.text?.contains("@"))! && phoneMessage.text == "" {
            if !validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
                UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneMessage(str: "E-Mail введен неверно") })
                phoneOrEmailOk = false
                return
            }
        }
        if !(phoneOrEmailField.text?.contains("@"))! {
            if !validatePhone(phoneStr: phoneOrEmailField.text! as NSString) && phoneMessage.text == "" {
                UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneMessage(str: "Телефон введен неверно") })
                phoneOrEmailOk = false
                return
            }
        }
        
        if phoneOrEmailField.text == "" {
            phoneMessage.text = "Введите телефон или E-Mail"
            phoneOrEmailOk = false
            return
        }
        if (phoneOrEmailField.text?.contains("@"))! {
            if !validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
                phoneMessage.text = "E-Mail введен неверно"
                phoneOrEmailOk = false
                return
            }
        }
        if !(phoneOrEmailField.text?.contains("@"))! {
            if !validatePhone(phoneStr: phoneOrEmailField.text! as NSString) {
                phoneMessage.text = "Телефон введен неверно"
                phoneOrEmailOk = false
                return
            }
        }
        
        if (validatePhone(phoneStr: phoneOrEmailField.text! as NSString) || validateEmail(eMailStr: phoneOrEmailField.text! as NSString)) && phoneMessage.text != "" {
            disappearPhoneMessage()
            phoneOrEmailOk = true
        } else if validatePhone(phoneStr: phoneOrEmailField.text! as NSString) || validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
            phoneOrEmailOk = true
        }
    }
    
    func checkPassword() {
        
        if passwordField.text == "" && passwordMessage.text == "" {
            UIView.animate(withDuration: 0.5, animations: { self.moveRegister() }, completion: { success in self.appearPasswordMessage(str: "Введите пароль") })
            passwordOk = false
            return
        }
        if (passwordField.text?.characters.count)! < 6 && passwordMessage.text == "" {
            UIView.animate(withDuration: 0.5, animations: { self.moveRegister() }, completion: { success in self.appearPasswordMessage(str: "Пароль должен быть от 6 символов") })
            passwordOk = false
            return
        }
        
        if passwordField.text == "" && passwordMessage.text != "Введите пароль" {
            passwordMessage.text = "Введите пароль"
            passwordOk = false
            return
        }
        if (passwordField.text?.characters.count)! < 6 && passwordField.text != "" && passwordMessage.text != "Пароль должен быть от 6 символов" {
            passwordMessage.text = "Пароль должен быть от 6 символов"
            passwordOk = false
            return
         }
        
        if (passwordField.text?.characters.count)! > 5 && passwordMessage.text != "" {
            disappearPasswordMessage()
            passwordOk = true
        }
        if (passwordField.text?.characters.count)! > 5 {
            passwordOk = true
        }
    }

// MARK: - Moving
    func movePassword() {
        
        self.passwordField.frame.origin.y = self.passwordField.frame.minY + 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY + 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY + 38
        
        NSLayoutConstraint.deactivate([self.passwordTop])
        self.passwordTop = NSLayoutConstraint(item: self.passwordField, attribute: .top, relatedBy: .equal, toItem: self.phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 46)
        NSLayoutConstraint.activate([self.passwordTop])
    }
    
    func unmovePassword() {
        
        self.passwordField.frame.origin.y = self.passwordField.frame.minY - 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY - 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY - 38
        
        NSLayoutConstraint.deactivate([self.passwordTop])
        self.passwordTop = NSLayoutConstraint(item: self.passwordField, attribute: .top, relatedBy: .equal, toItem: self.phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activate([self.passwordTop])
    }
    
    func moveRegister() {
        
        self.registerButton.frame.origin.y = self.registerButton.frame.minY + 38
        
        NSLayoutConstraint.deactivate([self.registerTop])
        self.registerTop = NSLayoutConstraint(item: self.registerButton, attribute: .top, relatedBy: .equal, toItem: self.passwordField, attribute: .bottom, multiplier: 1.0, constant: 46)
        NSLayoutConstraint.activate([self.registerTop])
    }
    
    func unmoveRegister() {
        
        self.registerButton.frame.origin.y = self.registerButton.frame.minY - 38
        
        NSLayoutConstraint.deactivate([self.registerTop])
        self.registerTop = NSLayoutConstraint(item: self.registerButton, attribute: .top, relatedBy: .equal, toItem: self.passwordField, attribute: .bottom, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activate([self.registerTop])
    }
    
    func appearPhoneMessage(str: NSString) {
        
        phoneMessage.text = str as String
        UIView.animate(withDuration: 0.5, animations: { self.phoneMessage.alpha = 1 })
    }
    
    func disappearPhoneMessage() {
        
        UIView.animate(withDuration: 0.5, animations: { self.phoneMessage.alpha = 0 }, completion: { success in
            self.phoneMessage.text = ""
            UIView.animate(withDuration: 0.5, animations: { self.unmovePassword() })
        })
    }
    
    func appearPasswordMessage(str: NSString) {
        
        passwordMessage.text = str as String
        UIView.animate(withDuration: 0.5, animations: { self.passwordMessage.alpha = 1 })
    }
    
    func disappearPasswordMessage() {
        
        UIView.animate(withDuration: 0.5, animations: { self.passwordMessage.alpha = 0 }, completion: { success in
            self.passwordMessage.text = ""
            UIView.animate(withDuration: 0.5, animations: { self.unmoveRegister() })
        })
    }

// MARK: - Validating
    func validatePhone(phoneStr: NSString) -> Bool {
    
        let phoneRegex: NSString = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with:phoneStr)
    }
    
    func validateEmail(eMailStr: NSString) -> Bool {
        
        let eMailRegex: NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let eMailTest: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", eMailRegex)
        return eMailTest.evaluate(with:eMailStr)
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
