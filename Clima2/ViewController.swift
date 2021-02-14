//
//  ViewController.swift
//  Clima2
//
//  Created by Жанадил on 2/12/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController{

 
    @IBOutlet weak var searchTextField2: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    let URL = "https://api.openweathermap.org/data/2.5/weather"
    
    
    func requestInfo(cityName: String){
        let parameters: [String: String] = [
            "q" : cityName,
            "appid" : "12a5c699b36d0b4049187e3a1b89b00b",
            "units" : "metric"
        ]
        
        Alamofire.request(URL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Got the info")
                //print(response)
                let weatherJSON: JSON = JSON(response.result.value!)
                let temperature = weatherJSON["main"]["temp"].stringValue
                let condition = weatherJSON["weather"][0]["id"].intValue
                let city = weatherJSON["name"].stringValue
                if let k = Double(temperature){
                     self.temperatureLabel.text = ("\(round(k * 100.0)/100.0)")
                     self.cityLabel.text = city
                    self.imageView.image = UIImage(systemName: self.getConditionImage(condition: condition))
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField2.delegate = self
    }
    
    
    func getConditionImage(condition: Int) -> String{
        switch condition{
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        requestInfo(cityName: searchTextField2.text!)
        searchTextField2.endEditing(true)
    }
}



//MARK: -UITextFieldDelegate
extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestInfo(cityName: searchTextField2.text!)
        searchTextField2.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField2.text = ""
    }
}

