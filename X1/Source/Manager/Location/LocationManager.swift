//
//  LocationManager.swift
//  indeclap
//
//  Created by Huulke on 02/15/18.
//  Copyright © 2018 Huulke. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locationFetched: ((CLLocationDegrees, CLLocationDegrees)->Void)?
    var permission: ((Bool)->Void)?
    
    /**
     
     Fetches the current location and use closures to notify for events.
     
     - Parameter fetched: Called when location updates are received.
     
     - Parameter grant:   Called when permission granted by user or denied.
     */
    func currentLocation(location fetched:
        @escaping (CLLocationDegrees, CLLocationDegrees)->Void, permission
        grant:@escaping(Bool)->Void) {
        self.locationFetched            = fetched
        self.permission                 = grant
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate        = self
        locationManager.distanceFilter  = 100 // In meter
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var granted = false
        switch status {
        case .authorizedAlways:
            granted = true
        case .authorizedWhenInUse:
            granted = true
        case .notDetermined:
            return
        default:
            granted = false
        }
        
        // callback with permission
        if let permission = self.permission {
            permission(granted)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Got current location
        if let callback = self.locationFetched {
            let location:CLLocationCoordinate2D = manager.location!.coordinate
            callback(location.latitude, location.longitude)
        }
    }
    
    func stopLocationUpdate() {
        // Stop location update
        locationManager.stopUpdatingLocation()
    }
    
    func reverseGeocode(latitude:CLLocationDegrees, longitude:CLLocationDegrees, completion:@escaping (_ address:Address) -> Void) {
        // Get the physical location from latitude and longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if let locationDetail = placemarks?.first {
                let address = Address.init(placemark: locationDetail)
                completion(address)
            }
        })
    }
}

struct Address {
    var addressLine:String?
    var city:String?
    var state:String?
    var zip:String?
    var country:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?

    init(placemark: CLPlacemark) {
        country     = placemark.country
        state       = placemark.administrativeArea ?? placemark.subAdministrativeArea
        city        = placemark.locality ?? placemark.subLocality
        zip         = placemark.postalCode
        addressLine = (placemark.name ?? placemark.thoroughfare) ?? placemark.subThoroughfare
        latitude    = placemark.location?.coordinate.latitude
        longitude    = placemark.location?.coordinate.longitude
    }
}

