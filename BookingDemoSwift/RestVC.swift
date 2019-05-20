//
//  RestVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 09.05.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit
import Alamofire

class RestVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //let URL_BOOKING = "http://localhost/test/v1/login.php"
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    var id: String = ""
    var type: String = ""
    var name: String = ""
    var desc: String = ""

    let strArray = ["12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        
        title = name
        
        if type == "Кафе" {
            type = "Каф"
        }
        
        print(desc)
        
        descText.text = desc
    }
    
// MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCell
        
        
        cell.timeButton.setTitle(strArray[indexPath.row], for: UIControlState.normal)
        return cell
    }

// MARK: - UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 150.0
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            return "О " + type + "е " + name
        }
        
        if section == 3 {
            return "Доп информация"
        }
        return ""
    }

// MARK: - UITableView actions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "gotoPickers", sender: self)
        }
    }
    
    @IBAction func reserv(_ sender: UIButton) {
        
        let defaultValues = UserDefaults.standard
        defaultValues.set(sender.title(for: .normal)!, forKey: "reservTime")
        print(sender.title(for: .normal)!)
        print(defaultValues.object(forKey: "reservTime")!)
        performSegue(withIdentifier: "gotoCompleteReservation", sender: self)
               
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoCompleteReservation" {
            let destination: CompleteReservationTVC = segue.destination as! CompleteReservationTVC
            destination.id = id as String
            
            
            return
        }
    }
    
    
    
    
}
