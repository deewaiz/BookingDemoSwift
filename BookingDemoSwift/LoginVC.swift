//
//  LoginVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 11.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {

    let URL_USER_LOGIN = "http://localhost/test/v1/login.php"
    var json = [[String:Any]]()
    
    @IBOutlet weak var phoneOrEmailField: UITextField!  // Поля для ввода
    @IBOutlet weak var passwordField: UITextField!      //
    @IBOutlet weak var loginButton: UIButton!           // Кнопки
    @IBOutlet weak var registerButton: UIButton!        //
    @IBOutlet weak var phoneOrEmailMessage: UILabel!    // Сообщения об ошибках
    @IBOutlet weak var passwordMessage: UILabel!        //
    
    let kAccountID = "ID"
    let kAccountPhone = "phone"
    let kAccountEmail = "eMail"
    let kAccountPassword = "password"
    
    var passwordTop: NSLayoutConstraint = NSLayoutConstraint()
    var loginButtonTop: NSLayoutConstraint = NSLayoutConstraint()
    
    var phoneOrEmailOk: Bool = false
    var passwordOk: Bool = false
    
////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        phoneOrEmailMessage.alpha = 0
        passwordMessage.alpha = 0
        
        passwordTop = NSLayoutConstraint(item: passwordField, attribute: .top, relatedBy: .equal, toItem: phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        loginButtonTop = NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: passwordField, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        
        NSLayoutConstraint.activate([passwordTop, loginButtonTop])
        
        let defaultValues = UserDefaults.standard
        
        let url = "http://localhost/test.local/service.php"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print("Error")
            }
            else {
                do {
                    
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [[String:Any]]
                    defaultValues.set(fetchedData, forKey: "json")
                    defaultValues.synchronize()
                    print((defaultValues.object(forKey: "json") as! [[String:Any]]))

                    //print(defaultValues.object(forKey: "json"))
                    //print(self.arrayOfCellData)
                    
                    //self.arrayOfCellData.append(<#T##newElement: MainVC.cellData##MainVC.cellData#>)
                    //print(fetchedData)
                    //print(fetchedData[0]["name"]!)
                    //print(fetchedData.count)
                    
                    
                    //self.testText.text = String(describing: fetchedData)
                    
                    
                }
                catch {
                    print("Error 2")
                }
                
            }
        }
        task.resume()
        //print((defaultValues.object(forKey: "json") as! [[String:Any]]).count, 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super .viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        
        let parameters: Parameters = [
            "email":phoneOrEmailField.text!,
            "password":passwordField.text!
        ]
        
        let myUserDefaults: UserDefaults = UserDefaults()
        
        
        
        checkPhoneOrEmail()
        
        checkPassword()
        
        if phoneOrEmailOk && passwordOk {
            
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseString {
                response in
                var myString = response.result.value
                myString?.remove(at: (myString?.startIndex)!)
                if let result = myString {
                    
                    let jsonData = self.convertToDictionary(text: result)! as NSDictionary
                    
                    if (!(jsonData.value(forKey: "error") as! Bool)) {
                        
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        let userId = user.value(forKey: "id") as! Int
                        
                        myUserDefaults.set(userId, forKey: self.kAccountID)
                        myUserDefaults.set(parameters["email"], forKey: self.kAccountEmail) //self.phoneOrEmailField.text, forKey: self.kAccountEmail)
                        myUserDefaults.set(self.passwordField.text, forKey: self.kAccountPassword)
                        
                        print(myString!)
                        print(myUserDefaults.object(forKey: self.kAccountID)!)
                        print(myUserDefaults.object(forKey: self.kAccountEmail)!)
                        print(myUserDefaults.object(forKey: self.kAccountPassword)!)
                        
                        self.performSegue(withIdentifier: "loginDone", sender: self)
                        
                    } else {
                        
                        print("Invalid username or password")
                        if self.passwordMessage.text == "" {
                            UIView.animate(withDuration: 0.5, animations: { self.moveLoginButton() }, completion: { success in self.appearPasswordMessage(str: "Неверный пароль") })
                            self.passwordOk = false
                            return
                        } else {
                            self.passwordMessage.text = "Неверный пароль"
                            self.passwordOk = false
                            return
                        }
                    }
                }
            }
        
        }
    }
    
// MARK: - Checking
    func checkPhoneOrEmail() {
        
        if phoneOrEmailField.text == "" && phoneOrEmailMessage.text == "" {
            UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneOrEmailMessage(str: "Введите телефон или E-Mail") })
            phoneOrEmailOk = false
            return
        }
        if (phoneOrEmailField.text?.contains("@"))! && phoneOrEmailMessage.text == "" {
            if !validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
                UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneOrEmailMessage(str: "E-Mail введен неверно") })
                phoneOrEmailOk = false
                return
            }
        }
        if !(phoneOrEmailField.text?.contains("@"))! {
            if !validatePhone(phoneStr: phoneOrEmailField.text! as NSString) && phoneOrEmailMessage.text == "" {
                UIView.animate(withDuration: 0.5, animations: { self.movePassword() }, completion: { success in self.appearPhoneOrEmailMessage(str: "Телефон введен неверно") })
                phoneOrEmailOk = false
                return
            }
        }
        if phoneOrEmailField.text == "" {
            phoneOrEmailMessage.text = "Введите телефон или E-Mail"
            phoneOrEmailOk = false
            return
        }
        if (phoneOrEmailField.text?.contains("@"))! {
            if !validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
                phoneOrEmailMessage.text = "E-Mail введен неверно"
                phoneOrEmailOk = false
                return
            }
        }
        if !(phoneOrEmailField.text?.contains("@"))! {
            if !validatePhone(phoneStr: phoneOrEmailField.text! as NSString) {
                phoneOrEmailMessage.text = "Телефон введен неверно"
                phoneOrEmailOk = false
                return
            }
        }
        if (validatePhone(phoneStr: phoneOrEmailField.text! as NSString) || validateEmail(eMailStr: phoneOrEmailField.text! as NSString)) && phoneOrEmailMessage.text != "" {
            disappearPhoneOrEmailMessage()
            phoneOrEmailOk = true
        } else if validatePhone(phoneStr: phoneOrEmailField.text! as NSString) || validateEmail(eMailStr: phoneOrEmailField.text! as NSString) {
            phoneOrEmailOk = true
        }
    }
    
    func checkPassword() {
        
        if passwordField.text == "" && passwordMessage.text == "" {
            UIView.animate(withDuration: 0.5, animations: { self.moveLoginButton() }, completion: { success in self.appearPasswordMessage(str: "Введите пароль") })
            passwordOk = false
            return
        }
        
        if passwordField.text == "" {
            passwordMessage.text = "Введите пароль"
            passwordOk = false
            return
        }
        
        if !(passwordField.text == "") && passwordMessage.text != "" {
            disappearPasswordMessage()
            passwordOk = true
        } else if !(passwordField.text == "") {
            passwordOk = true
        }
    }
    
// MARK: - Moving
    func movePassword() {
        
        self.passwordField.frame.origin.y = self.passwordField.frame.minY + 38
        self.loginButton.frame.origin.y = self.loginButton.frame.minY + 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY + 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY + 38
        
        NSLayoutConstraint.deactivate([self.passwordTop])
        self.passwordTop = NSLayoutConstraint(item: self.passwordField, attribute: .top, relatedBy: .equal, toItem: self.phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 46)
        NSLayoutConstraint.activate([self.passwordTop])
    }
    
    func unmovePassword() {
        
        self.passwordField.frame.origin.y = self.passwordField.frame.minY - 38
        self.loginButton.frame.origin.y = self.loginButton.frame.minY - 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY - 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY - 38
        
        NSLayoutConstraint.deactivate([self.passwordTop])
        self.passwordTop = NSLayoutConstraint(item: self.passwordField, attribute: .top, relatedBy: .equal, toItem: self.phoneOrEmailField, attribute: .bottom, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activate([self.passwordTop])
    }
    
    func moveLoginButton() {
        
        self.loginButton.frame.origin.y = self.loginButton.frame.minY + 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY + 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY + 38
        
        NSLayoutConstraint.deactivate([self.loginButtonTop])
        self.loginButtonTop = NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.passwordField, attribute: .bottom, multiplier: 1.0, constant: 46)
        NSLayoutConstraint.activate([self.loginButtonTop])
    }
    
    func unmoveLoginButton() {
        
        self.loginButton.frame.origin.y = self.loginButton.frame.minY - 38
        self.registerButton.frame.origin.y = self.registerButton.frame.minY - 38
        self.passwordMessage.frame.origin.y = self.passwordMessage.frame.minY - 38
        
        NSLayoutConstraint.deactivate([self.loginButtonTop])
        self.loginButtonTop = NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.passwordField, attribute: .bottom, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activate([self.loginButtonTop])
    }
    
    func appearPhoneOrEmailMessage(str: NSString) {
        
        phoneOrEmailMessage.text = str as String
        UIView.animate(withDuration: 0.5, animations: { self.phoneOrEmailMessage.alpha = 1 })
    }
    
    func disappearPhoneOrEmailMessage() {
        
        UIView.animate(withDuration: 0.5, animations: { self.phoneOrEmailMessage.alpha = 0 }, completion: { success in
            self.phoneOrEmailMessage.text = ""
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
            UIView.animate(withDuration: 0.5, animations: { self.unmoveLoginButton() })
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
    
    /*func validatePassword(passwordStr: NSString) -> Bool {
        
        var check:Bool = false
        
        let myUserDefaults: UserDefaults
        myUserDefaults = UserDefaults.standard
        
        if passwordStr as String == myUserDefaults.object(forKey: kAccountPassword) as? String {
            check = !check
        }
        
        return check
    }*/
    
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

