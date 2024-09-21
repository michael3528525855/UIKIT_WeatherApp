//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//fea3e0a9a9774fd60b1f37833013bbcd


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManeger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManeger.delegate = self
        locationManeger.requestWhenInUseAuthorization()
        // you need to add discription in privacy "Info"file
        locationManeger.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    @IBAction func getlocatio(_ sender: UIButton) {
        locationManeger.requestLocation()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // desmiss keyboard
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // desmiss keyboard
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
           return true
        }
        else{
            textField.placeholder = "type something her"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            
        }
        //cityLabel.text = weather.name
        searchTextField.text = ""
    }
}
//MARK: - WeatherManagerdelegate

extension WeatherViewController : WeatherManagerdelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}
//MARK: -CLLocationManagerDelegate

extension WeatherViewController :CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // write didupdatelocation
        if let location = locations.last{
            locationManeger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat,longitude : lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {//didFailWithError
        print(error)
    }
}


