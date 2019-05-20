//
//  PickersVC.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 12.05.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit

class PickersVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var personPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    struct personPickerData {
        let count: String
        let person: String
    }
    
    struct datePickerData {
        let day: String
        let number: String
        let month: String
    }
    
    var arrayOfPersonPickerData = [personPickerData]()
    var arrayOfDatePickerData = [datePickerData]()
    var arrayOfTime:Array<String> = []
    
    let pickerWidth: CGFloat = 100
    let pickerHeight1: CGFloat = 70
    let pickerHeight2: CGFloat = 105
    let pickerHeight3: CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let weekday = calendar.component(.weekday, from: date)
        //print("date = \(day):\(month):\(year) ", getDay(number: weekday), calendar.date(byAdding: .day, value: 1, to: date)!)
        var tenDaysfromNow: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
        }
        print(calendar.component(.weekday, from: tenDaysfromNow))
        
        arrayOfPersonPickerData = [personPickerData(count: "1", person: "персона"),
                                   personPickerData(count: "2", person: "персоны"),
                                   personPickerData(count: "3", person: "персоны"),
                                   personPickerData(count: "4", person: "персоны"),
                                   personPickerData(count: "5", person: "персон"),
                                   personPickerData(count: "6", person: "персон"),
                                   personPickerData(count: "7", person: "персон"),
                                   personPickerData(count: "8", person: "персон"),
                                   personPickerData(count: "9", person: "персон"),
                                   personPickerData(count: "10", person: "персон")]
        arrayOfDatePickerData = [
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -5, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -5, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -5, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -4, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -4, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -4, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -3, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -3, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: -3, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to: Date(), options: [])!))),
            
            datePickerData(day: getDay(number: calendar.component(.weekday, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 6, to: Date(), options: [])!)),
                           number: String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 6, to: Date(), options: [])!)),
                           month: getMonth(number: calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: 6, to: Date(), options: [])!)))]
        arrayOfTime = ["12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00"]
        
        
        
        var y = personPicker.frame.origin.y
        
        personPicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        personPicker.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: pickerHeight1)
        personPicker.delegate = self
        personPicker.dataSource = self
        personPicker.selectRow(1, inComponent: 0, animated: true)
        
        y = personPicker.frame.origin.y + personPicker.frame.height
        datePicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        datePicker.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: pickerHeight2)
        datePicker.delegate = self
        datePicker.dataSource = self
        
        y = datePicker.frame.origin.y + datePicker.frame.height
        timePicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        timePicker.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: pickerHeight3)
        timePicker.delegate = self
        timePicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView .isEqual(personPicker) {
            return arrayOfPersonPickerData.count
        } else if pickerView .isEqual(datePicker) {
            return arrayOfDatePickerData.count
        } else {
            return arrayOfTime.count
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
        
        let calendar = Calendar.current
        let defaultValues = UserDefaults.standard
        let day = String(calendar.component(.day, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: datePicker.selectedRow(inComponent: 0), to: Date(), options: [])!))
        let month = String(calendar.component(.month, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: datePicker.selectedRow(inComponent: 0), to: Date(), options: [])!))
        let year = String(calendar.component(.year, from: (Calendar.current as NSCalendar).date(byAdding: .day, value: datePicker.selectedRow(inComponent: 0), to: Date(), options: [])!))
        //print(day + "/" + month + "/" + year)
        defaultValues.set(day + "/" + month + "/" + year, forKey: "reservDate")
        print(defaultValues.object(forKey: "reservDate") as! String)
        defaultValues.set(personPicker.selectedRow(inComponent: 0) + 1, forKey: "reservPerson")
        print(String(defaultValues.object(forKey: "reservPerson") as! Int))
        defaultValues.synchronize()

    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView .isEqual(personPicker) {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight1))
        
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight1 / 2))
            topLabel.text = arrayOfPersonPickerData[row].count
            topLabel.textAlignment = .center
            //topLabel.backgroundColor = UIColor.gray
            view.addSubview(topLabel)
        
            let bottomLabel = UILabel(frame: CGRect(x: 0, y: pickerHeight1 / 2, width: pickerWidth, height: pickerHeight1 / 2))
            bottomLabel.text = arrayOfPersonPickerData[row].person
            bottomLabel.textAlignment = .center
            //bottomLabel.backgroundColor = UIColor.darkGray
            view.addSubview(bottomLabel)
            
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
            return view
        } else if pickerView .isEqual(datePicker) {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight2))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight2 / 3))
            topLabel.text = arrayOfDatePickerData[row].day
            topLabel.textAlignment = .center
            //topLabel.backgroundColor = UIColor.gray
            view.addSubview(topLabel)
            
            let middleLabel = UILabel(frame: CGRect(x: 0, y: pickerHeight2 / 3, width: pickerWidth, height: pickerHeight2 / 3))
            middleLabel.text = arrayOfDatePickerData[row].number
            middleLabel.textAlignment = .center
            //middleLabel.backgroundColor = UIColor.green
            view.addSubview(middleLabel)
            
            let bottomLabel = UILabel(frame: CGRect(x: 0, y: pickerHeight2 / 3 * 2, width: pickerWidth, height: pickerHeight2 / 3))
            bottomLabel.text = arrayOfDatePickerData[row].month
            bottomLabel.textAlignment = .center
            //bottomLabel.backgroundColor = UIColor.darkGray
            view.addSubview(bottomLabel)
            
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
            
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight3))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight3))
            topLabel.text = arrayOfTime[row]
            topLabel.textAlignment = .center
            //topLabel.backgroundColor = UIColor.gray
            view.addSubview(topLabel)
            
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
            
            return view
        }
    }
    
    func getDay(number: Int) -> String{
        
        switch number{
            
        case 1:
            return "Вc"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return ""
        }
    }
    
    func getMonth(number: Int) -> String{
        
        switch number{
            
        case 1:
            return "Января"
        case 2:
            return "Февраля"
        case 3:
            return "Марта"
        case 4:
            return "Апреля"
        case 5:
            return "Мая"
        case 6:
            return "Июня"
        case 7:
            return "Июля"
        case 8:
            return "Августа"
        case 9:
            return "Сентября"
        case 10:
            return "Октября"
        case 11:
            return "Ноября"
        case 12:
            return "Декабря"
        default:
            return ""
        }
    }
}
