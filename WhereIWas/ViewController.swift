//
//  ViewController.swift
//  WhereIWas
//
//  Created by ILJOO CHAE on 8/18/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData




class ViewController: UIViewController {
    
    static let shared = ViewController()
    
    @IBOutlet weak var mapKit: MKMapView!
    
//    var place = [Place]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var num1 = 0.0
    var num2 = 0.0
    
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false
    var lastLocationError: Error?
    
    //Geocoder
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var isPerformingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    @IBOutlet weak var addBtnLabel: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mapKit.isHidden = true
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        setGradientBackground()
        
        
//        print(paths[0])
        
        //Getting path for data
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.barTintColor = UIColor(red: 125/255.0, green: 137/255.0, blue: 147/255.0, alpha: 1.0)
    }
    
    func getMapLocation() {
        
        guard let lati = latitudeLabel.text else {return}
        guard let long = longitudeLabel.text else {return}
        
        guard let temp1 = Double(lati) else {return}
        guard let temp2 = Double(long) else {return}
        
        
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: temp1, longitude: temp2)
        annotation.title = "You are here"
        annotation.subtitle = ""
        //        mapKit.addAnnotation(annotation)
        mapKit.addAnnotation(annotation)
        
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        //        MKMapView.setRegion(region, animated: true)
        mapKit.setRegion(region, animated: true)
        mapKit.isHidden = false
    }
    
    
    
    func updateUI() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            statusLabel.text = "New Location Detected"
//            addBtnLabel.setBackgroundImage(UIImage(named: "found"), for: UIControl.State.normal)
            //we have placemark then go to below
            if let placemark = placemark {
                addressLabel.text = getAddress(from: placemark)
            }else if isPerformingReverseGeocoding{
                addressLabel.text = "Searching for address"
            }else if lastGeocodingError != nil {
                addressLabel.text = "Error finding a valid address"
            }else{
                addressLabel.text = "Not found"
            }
            
        }else{
            statusLabel.text = "Tap To Find Where You Are"
            latitudeLabel.text = "-"
            longitudeLabel.text = "-"
            addressLabel.text = "-"
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func transitionToOther() {
        let newVC = storyboard?.instantiateViewController(identifier: "ListVC") as? ListViewController
      
      view.window?.rootViewController = newVC
      view.window?.makeKeyAndVisible()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Location", message: "Please enter how you want to remember", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what should happen when user tapped add button
//            let newCategory  = Place(context: self.context)
//            newCategory.name = textField.text!
//            newCategory.color = UIColor.randomFlat().hexValue()
//            self.categories.append(newCategory)
//            self.saveCategories()
            
//            let newPlace = Place()
            let newPlace = Place(context: self.context)
            newPlace.latitude = self.latitudeLabel.text
            newPlace.longitude = self.longitudeLabel.text
            newPlace.address = self.addressLabel.text
            newPlace.title = textField.text
            newPlace.date = Date()
            self.saveLocation()
//            self.transitionToOther()
        }
            alert.addAction(action)

        //Cancel Button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
   
        alert.addTextField { (field) in
            textField = field
            
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveLocation() {
         do {
             try context.save()
//             performSegue(withIdentifier: "toDetailView", sender: nil)
//            present(DetailViewController, animated: true, completion: nil)
//            self.performSegue(withIdentifier: "toDetailVC", sender: nil)
         }catch{
             print("Error saving context")
         }
     }
    
    
    func getAddress(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let street1 = placemark.subThoroughfare {
            line1 += street1 + "   "
        }
        if let street2 = placemark.thoroughfare {
            line1 += street2
        }
        var line2 = ""
        if let city = placemark.locality {
            line2 += city + ",  "
        }
        
        if let stateOrProvine = placemark.administrativeArea {
            line2 += stateOrProvine + "  "
        }
        if let postalCode = placemark.postalCode {
            line2 += postalCode
        }
        
        var line3 = ""
        if let country = placemark.country {
            line3 += country
        }
        
        return line1 + "\n" + line2 + "\n" + line3
    }
    
    
    @IBAction func findBtnTapped(_ sender: Any) {
        
        //1. get the users' permission to use location services
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        //2. report to user if permission is denied
        //A. user accidently refused
        //B. The devie is restricted
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            reportLocationServicesDeniedError()
            return
        }
        
        //Start&Stop finding location
        if isUpdatingLocation {
            stopLocationManager()
            
        }else{
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
            
        }
        getMapLocation()
        mapKit.isHidden = false
        updateUI()
    }
    
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func reportLocationServicesDeniedError() {
        let alert = UIAlertController(title: "Oops! Loation Sevice Disabled", message: "Please go to setting  > Privacy to enable location services for this app", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? ListViewController else {return}
            let dataToTransfer = addressLabel.text
            destinationVC.longi = longitudeLabel.text ?? ""
            destinationVC.lati = latitudeLabel.text ?? ""
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error! - \(error.localizedDescription) --\(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateUI()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        print("Got it-- \(location)")
        stopLocationManager()
        updateUI()
        
        if location != nil {
            if !isPerformingReverseGeocoding {
                print("*** we are start performing Geocoding")
                isPerformingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
                    self.lastGeocodingError = error
                    if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                        self.placemark = placemarks.last!
                    }else{
                        self.placemark = nil
                    }
                    self.isPerformingReverseGeocoding = false
                    self.updateUI()
                }
            }
        }
    }
}





