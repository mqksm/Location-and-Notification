//
//  ViewController.swift
//  Location and Notification
//
//  Created by Maks on 13.03.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    let locationManager: CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatingLoc()
        startMonitoringForRegion()
    }
    
    func startUpdatingLoc(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // set accuracy of localiztion
        locationManager.requestAlwaysAuthorization()
        //        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter  = 10 // Set location update frequency. In this case, 10 meter
        locationManager.pausesLocationUpdatesAutomatically = true // enable to detect the situation where an app doesn’t need location update for battery saving
        locationManager.activityType = .fitness // The type of user activity associated with the location updates
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        //            let coords = [ "latitude": currentLocation.coordinate.latitude, "longitude": currentLocation.coordinate.longitude, "altitude": currentLocation.altitude, "horizontalAccuracy": currentLocation.horizontalAccuracy, "verticalAccuracy": currentLocation.verticalAccuracy]
        latitudeLabel.text = String(format:"%.8f", currentLocation.coordinate.latitude)
        longitudeLabel.text = String(format:"%.8f", currentLocation.coordinate.longitude)
        altitudeLabel.text = String(format:"%.8f", currentLocation.altitude)
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let placemark = placemarks?.last else { return }
            var adrress = ""
            if let country = placemark.country {
                adrress += country + ", "
            }
            if let city = placemark.locality {
                adrress += city + ", "
            }
            if let city2 = placemark.subLocality {
                adrress += city2 + ", "
            }
            if let street = placemark.thoroughfare {
                adrress += street + ", "
            }
            if let house = placemark.subThoroughfare {
                adrress += house
            }
            self.currentAddressLabel.text = adrress
        }
        
    }
    
    func startMonitoringForRegion() {
        locationManager.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 35.1661,
                                            longitude: 33.3145)

        let radius = 100.0
        let identifier = "University-of-Nicosia"
        let region = CLCircularRegion(center: center, radius: radius,
                                      identifier: identifier)
        
        locationManager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        // do something on entry

        self.appDelegate?.createNotification(isEnter: true)
        view.backgroundColor = UIColor.systemIndigo

    }
    
    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {

        self.appDelegate?.createNotification(isEnter: false)
        view.backgroundColor = UIColor.systemBackground

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
        print ("Can't get your location")
    }
    
}


