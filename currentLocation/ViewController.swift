//
//  ViewController.swift
//  currentLocation
//
//  Created by Soulchild on 25/01/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.activityIndicator.isHidden = true
    }


    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        retriveCurrentLocation()
    }
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            //locationManager.requestAlwaysAuthorization()
            return
        }
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        // request location data for one-off usage
        locationManager.requestLocation()
        
        // keep requesting location data until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }
}

extension ViewController : CLLocationManagerDelegate {
    // called when the authorization status is changed for the core location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // the last element is the most recent location
        if let location = locations.last {
            self.latitudeLabel.text = "\(location.coordinate.latitude)"
            self.longitudeLabel.text = "\(location.coordinate.longitude)"
        }
        
        for location in locations {
            // do stuff with each location
        }
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
}
