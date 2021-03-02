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
import CoreLocation

class ViewController: UIViewController{

 
    @IBOutlet weak var searchTextField2: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureLabel2: UILabel!
    @IBOutlet weak var temperatureLabel3: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    let URL = "https://api.openweathermap.org/data/2.5/weather"
    let locationManager = CLLocationManager()
    let weatherModel = WeatherModel()
    
    
    func requestInfo(cityName: String?, lat: Double?, lon: Double?){
        let parameters: [String: String]
        if let city = cityName{
            parameters = [
                "q" : city,
                "appid" : "12a5c699b36d0b4049187e3a1b89b00b",
                "units" : "metric"
            ]
        }else{
            parameters = [
                "lat" : "\(lat!)",
                "lon" : "\(lon!)",
                "appid" : "12a5c699b36d0b4049187e3a1b89b00b",
                "units" : "metric"
            ]
        }
        
        
        
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
                    self.imageView.image = UIImage(systemName: self.weatherModel.getConditionImage(condition: condition))
                     self.temperatureLabel2.text = "°"
                     self.temperatureLabel3.text = "C"
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField2.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
        
    @IBAction func buttonPressed(_ sender: UIButton) {
        requestInfo(cityName: searchTextField2.text!, lat: nil, lon: nil)
        searchTextField2.endEditing(true)
    }
}



//MARK: -UITextFieldDelegate
extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestInfo(cityName: searchTextField2.text!, lat: nil, lon: nil)
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



//Mark: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //print(lat)
            //print(lon)
            requestInfo(cityName: nil, lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
