//
//  CompleteReservationTVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 16.05.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit
import Alamofire

class CompleteReservationTVC: UITableViewController {
    
    @IBOutlet weak var testText: UITextView!
    
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 64, y: self.view.frame.height - 100), size: CGSize(width: 140, height: 25)))
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Забронировать",for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        let defaultValues = UserDefaults.standard

        person.text = (String(defaultValues.object(forKey: "reservPerson") as! Int))
        date.text = (defaultValues.object(forKey: "reservDate") as! String)
        time.text = (defaultValues.object(forKey: "reservTime") as! String)

        //print(json[0]["name"]!)

        //print(json)

    }
    
    
    func buttonAction(sender: UIButton!) {

        let defaultValues = UserDefaults.standard

        let parameters: Parameters = [
            "resv_date": date.text!,
            "resv_time": time.text!,
            "user_id": (defaultValues.object(forKey: "ID")) as! Int,
            "shop_id": Int(id)!
         ]
        print(parameters["resv_date"]!)
        Alamofire.request("http://localhost/test/v1/booking.php", method: .post, parameters: parameters).responseString {
            response in
            var myString = response.result.value
            myString?.remove(at: (myString?.startIndex)!)
            if let result = myString {
                let jsonData = self.convertToDictionary(text: result)! as NSDictionary
                if (!(jsonData.value(forKey: "error") as! Bool)) {
                    print("Успех!")
                    let alert = UIAlertController(title: "Grats", message: "Успех", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Ошибка!")
                    let alert = UIAlertController(title: "Опа!", message: "Ошибка на сервере", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Океюшки", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                print("Нет соединения")
                let alert = UIAlertController(title: "Опа!", message: "Ошибка соединения", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Океюшки", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 100
            
        } else if indexPath.row == 1 {
            return 150
            
        } else {
            return view.frame.height
        }
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
