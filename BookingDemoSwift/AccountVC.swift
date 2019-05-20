//
//  AccountVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 12.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    let animator = Animator()
    
    var isMenuOpen: Bool = false
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sidebarView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var pop: UIView!
    @IBOutlet weak var popTitle: UILabel!
    
    let kAccountName = "name"
    let kAccountPhone = "phone"
    let kAccountEmail = "eMail"
    let kAccountPlace = "place"
    //let kAccountPassword = "password"
    
////////////////////////////////////////////////////////////    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        pop.alpha = 0
        pop.frame.origin.x = view.frame.width
        pop.frame.origin.y = 200
        
        let myUserDefaults: UserDefaults
        
        myUserDefaults = UserDefaults.standard
        
        //myUserDefaults.set("", forKey: kAccountName); myUserDefaults.set("", forKey: kAccountPlace)
        
        if myUserDefaults.object(forKey: kAccountName) as? String != "" {
            nameLabel.text = myUserDefaults.object(forKey: kAccountName) as? String
        }
        if myUserDefaults.object(forKey: kAccountPhone) as? String != "" {
            phoneLabel.text = myUserDefaults.object(forKey: kAccountPhone) as? String
        }
        if myUserDefaults.object(forKey: kAccountEmail) as? String != "" {
            eMailLabel.text = myUserDefaults.object(forKey: kAccountEmail) as? String
        }
        if myUserDefaults.object(forKey: kAccountPlace) as? String != "" {
            placeLabel.text = myUserDefaults.object(forKey: kAccountPlace) as? String
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        destination.transitioningDelegate = animator
    }
    
    func showMenu() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = self.view.frame.width - 75
            self.contentView.frame.origin.y = 22
            self.navigationController?.navigationBar.frame.origin.x = self.view.frame.width - 75
            self.navigationController?.navigationBar.frame.origin.y = 42
        }, completion: { success in self.isMenuOpen = true })
    }
    
    func hideMenu() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = 0
            self.contentView.frame.origin.y = 0
            self.navigationController?.navigationBar.frame.origin.x = 0
            self.navigationController?.navigationBar.frame.origin.y = 20
        }, completion: { success in self.isMenuOpen = false })
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        if isMenuOpen == false {
            self .showMenu()
        } else {
            self .hideMenu()
        }
    }
    
    @IBAction func gotoMain(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = self.view.frame.width
            self.contentView.frame.origin.y = self.view.frame.width / ((self.view.frame.width - 75) / 22)
            self.navigationController?.navigationBar.frame.origin.x = self.view.frame.width
            self.navigationController?.navigationBar.frame.origin.y = self.view.frame.width / ((self.view.frame.width - 75) / 22) + 20
        }, completion: { success in self.performSegue(withIdentifier: "gotoMain", sender: self) })
    }
    
    @IBAction func actionSwipe(_ sender: UIScreenEdgePanGestureRecognizer) { // Свайп с левой грани (открытие меню)
        
        let contentView = sender.view
        let point = sender.translation(in: view)
        
        if point.x < 0 { // Чтобы не двигалась за границу налево
            hideMenu()
            return
        }
        
        if sender.state == UIGestureRecognizerState.ended { // Если убрали палец
            
            if point.x < view.frame.width / 2 { // Если палец слева от центра, то прячем меню
                hideMenu()
                return
            } else { // Если палец справа от центра, то показываем меню
                showMenu()
                return
            }
        }
        
        // Задаем траекторию движения
        contentView!.center = CGPoint(x: view.center.x + point.x,
                                      y: view.frame.height / 2 + point.x / ((view.frame.width - 75) / 22))
        
        self.navigationController?.navigationBar.frame = CGRect(x: point.x,
                                                                y: ((navigationController?.navigationBar.frame.height)!) / 2 + point.x / (((navigationController?.navigationBar.frame.width)! - 75) / 22) - 2,
                                                                width: view.frame.width, height: 44.0);
    }

    @IBAction func actionSwipeBack(_ sender: UIPanGestureRecognizer) { // Свайп с правой грани (закрытие меню)
        
        let contentView = sender.view
        let point = sender.translation(in: view)
        
        if isMenuOpen == false { // Если меню закрыто, то не обрабатываем свайп справа
            return
        }
        
        if (point.x + (contentView?.frame.width)! - 75) < 0 { // Чтобы не двигалась за границу налево
            hideMenu()
            return
        }
        
        if sender.state == UIGestureRecognizerState.ended { // Если убрали палец, то прячем менюху
            hideMenu()
            return
        }
        
        // Задаем траекторию движения
        contentView!.center = CGPoint(x: view.center.x + point.x + (contentView?.frame.width)! - 75,
                                      y: view.frame.height / 2 + point.x / ((view.frame.width - 75) / 22) + 22)
        
        self.navigationController?.navigationBar.frame = CGRect(x: point.x + (contentView?.frame.width)! - 75,
                                                                y: ((navigationController?.navigationBar.frame.height)!) / 2 + point.x / (((navigationController?.navigationBar.frame.width)! - 75) / 22) + 20,
                                                                width: view.frame.width, height: 44.0);
    }
    
    @IBAction func actionShowNamePop(_ sender: Any) {
        
        preparePop(title: "Введите ваше имя")
    }
    
    @IBAction func actionShowPhonePop(_ sender: Any) {
        
        preparePop(title: "Введите ваш телефон")
    }
    
    @IBAction func actionShowEmailPop(_ sender: Any) {
        
        preparePop(title: "Введите ваш E-Mail")
    }
    
    @IBAction func actionShowPlacePop(_ sender: Any) {
        
        preparePop(title: "Укажите ваш город")
    }
    
    @IBAction func closePop(_ sender: Any) {
        
        pop.alpha = 0
        pop.frame.origin.x = view.frame.width
        pop.frame.origin.y = 200
        
        
    }
    
    func preparePop(title: NSString) {
        popTitle.text = title as String
        
        pop.alpha = 1
        pop.frame.origin.x = 40
        pop.frame.origin.y = 200
    }
    
}
