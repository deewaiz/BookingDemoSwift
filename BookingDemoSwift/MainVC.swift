//
//  MainVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 11.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL_SERVICE = "http://localhost/test.local/service.php"
    var json = [[String:Any]]()
    var count: Int = 0

    struct cellData {
        let type: String
        let name: String
        let cuisine: String
        let bg: UIImage
    }
    
    
    
    let animator = Animator()
    
    var arrayOfCellData = [cellData]()
    var isMenuOpen: Bool = false
    
    var parallaxOffsetSpeed: CGFloat = 50.0
    var cellHeight: CGFloat = 150.0
    var parallaxImageHeight: CGFloat {
        
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * mainTableView.frame.height) - cellHeight) / 2
        
        return maxOffset + self.cellHeight
    }
    
    var selectedCellId: String = ""
    var selectedCellName: String = ""
    var selectedCellType: String = ""
    var selectedCellDesc: String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sidebarView: UIView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        

        //defaultValues.set([[String:Any]](), forKey: "json")
        //print((defaultValues.object(forKey: "json") as! [[String:Any]])[0])
        
        

        
        
        
        
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        /*json
        self.arrayOfCellData = Array()

        for index in 0...fetchedData.count - 1 {
            self.arrayOfCellData.append(cellData(type: "Ресторан", name: fetchedData[index]["name"] as! String, cuisine: "Русская", bg: #imageLiteral(resourceName: "p1")))
        }*/
        
        //UIImage(named: "p1")
        
        /*arrayOfCellData = [cellData(type: "Ресторан", name: "Звезда", cuisine: "Русская", bg:  #imageLiteral(resourceName: "p1")),
                           cellData(type: "Бар", name: "Бавария", cuisine: "", bg: #imageLiteral(resourceName: "p2")),
                           cellData(type: "Ресторан", name: "EENMAAL", cuisine: "Голандская", bg: #imageLiteral(resourceName: "p3")),
                           cellData(type: "Кафе", name: "Assorti", cuisine: "Восточная", bg: #imageLiteral(resourceName: "p4")),
                           cellData(type: "Кафе", name: "Тануки", cuisine: "Японская", bg: #imageLiteral(resourceName: "p5"))]*/
        //print(arrayOfCellData.count, "e")
    }
    
// MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                //print(count)
        
        //print(defaultValues.object(forKey: "json") as! [[String:Any]])
        //print((defaultValues.object(forKey: "json") as! [[String:Any]]).count)
        //print((defaultValues.object(forKey: "json") as! [[String:Any]])[0])
        //print(arrayOfCellData)
        let defaultValues = UserDefaults.standard
        print((defaultValues.object(forKey: "json") as! [[String:Any]]).count, "table")

        return (defaultValues.object(forKey: "json") as! [[String:Any]]).count//arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultValues = UserDefaults.standard
        // Инициализация ячейки
        tableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        
        // Добавление данных в ячейку
        cell.typeLabel.text = "Ресторан"//arrayOfCellData[indexPath.row].type as String
        cell.nameLabel.text = ((defaultValues.object(forKey: "json") as! [[String:Any]])[indexPath.row]["name"] as! String)//arrayOfCellData[indexPath.row].name as String
        cell.addressLabel.text = ((defaultValues.object(forKey: "json") as! [[String:Any]])[indexPath.row]["address"] as! String)//arrayOfCellData[indexPath.row].cuisine as String
        cell.backgroundImage.image = #imageLiteral(resourceName: "p1")//arrayOfCellData[indexPath.row].bg
        
        // Эффект параллакса для картинки в ячейке
        cell.parallaxImageHeight.constant = parallaxImageHeight
        cell.parallaxTopConstraint.constant = parallaxOffset(newOffsetY: mainTableView.contentOffset.y, cell: cell)
        
        return cell
    }
    
    func parallaxOffset(newOffsetY: CGFloat, cell: MainCell) -> CGFloat{
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let offsetY = mainTableView.contentOffset.y
        for cell in mainTableView.visibleCells as! [MainCell] {
            cell.parallaxTopConstraint.constant = parallaxOffset(newOffsetY: mainTableView.contentOffset.y, cell: cell)
        }
    }
    
// MARK: - UITableView actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let defaultValues = UserDefaults.standard
        
        selectedCellId = (defaultValues.object(forKey: "json") as! [[String:Any]])[indexPath.row]["id"] as! String
        selectedCellType = "Ресторан"//arrayOfCellData[indexPath.row].type
        selectedCellName = (defaultValues.object(forKey: "json") as! [[String:Any]])[indexPath.row]["name"] as! String//arrayOfCellData[indexPath.row].name
        selectedCellDesc = (defaultValues.object(forKey: "json") as! [[String:Any]])[indexPath.row]["description"] as! String

        performSegue(withIdentifier: "gotoRest", sender: self)
    }
    
// MARK: - Sidebar
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

// MARK: - Sidebar actions
    @IBAction func actionMenu(_ sender: Any) {
        
        if isMenuOpen == false {
            self .showMenu()
        } else {
            self .hideMenu()
        }
    }
    
    @IBAction func gotoAccount(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = self.view.frame.width
            self.contentView.frame.origin.y = self.view.frame.width / ((self.view.frame.width - 75) / 22)
            self.navigationController?.navigationBar.frame.origin.x = self.view.frame.width
            self.navigationController?.navigationBar.frame.origin.y = self.view.frame.width / ((self.view.frame.width - 75) / 22) + 20
        }, completion: { success in self.performSegue(withIdentifier: "gotoAccount", sender: self) })
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
                                                                width: view.frame.width,height: 44.0)
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

    // MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoRest" {
            let destination: RestVC = segue.destination as! RestVC
            destination.id = selectedCellId as String
            destination.type = selectedCellType as String
            destination.name = selectedCellName as String
            destination.desc = selectedCellDesc as String

            return
        }
        let destination = segue.destination
        destination.transitioningDelegate = animator
    }


}

