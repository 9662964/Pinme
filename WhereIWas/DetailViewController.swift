//
//  DetailViewController.swift
//  WhereIWas
//
//  Created by iljoo Chae on 8/19/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController {
    
    

    
    
//    var tempArray:[] = []
    var subject: String?
    var address: String?
    var longitude: String?
    var latitude: String?
    var date: String?
    
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var geoCodeLabel: UILabel!
    
    
    @IBOutlet weak var addressCopyBtnLabel: UIButton!
    @IBOutlet weak var geocodeCopyBtnLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       updateUI()
       gettingMap()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        guard let navBar = navigationController?.navigationBar else {return}
//        navBar.barTintColor = UIColor(red: 210/255, green: 161/255, blue: 123/255, alpha: 1)
//        view.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 242/255, alpha: 1)
//        titleLabel.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 242/255, alpha: 1)
//        dateLabel.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 242/255, alpha: 1)
//        addressLabel.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 242/255, alpha: 1)
//        geoCodeLabel.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 242/255, alpha: 1)
        setGradientBackground()
        addressCopyBtnLabel.tintColor = .white
        geocodeCopyBtnLabel.tintColor = .white
        
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
    
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        
        shareCaptureScreenImage()
    }
    
    @IBAction func addressCopyBtnTapped(_ sender: UIButton!) {
        UIPasteboard.general.string = addressLabel!.text!
    }
    
    @IBAction func geoCodeCopyBtnTapped(_ sender: UIButton!) {
        UIPasteboard.general.string = geoCodeLabel!.text
    }
    @IBAction func copyBtnTapped(_ sender: Any) {
        UIPasteboard.general.string = "\(titleLabel!.text!)\n\n\(addressLabel!.text!)\n\n\(geoCodeLabel!.text!)"
    }
    
    @IBAction func navigationBtnTapped(_ sender: Any) {
        
        
        let tempLati = (latitude as! NSString).doubleValue
        let tempLong = (longitude as! NSString).doubleValue
        
        let navLatitude: CLLocationDegrees = tempLati
        let navLongitude: CLLocationDegrees = tempLong
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(navLatitude, navLongitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
        let option = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = subject
        mapItem.openInMaps(launchOptions: option)
    }
    
    func updateUI() {
        
     
        
        
        titleLabel.text = subject
        addressLabel.text = address
      
        
        guard let long = longitude else {return}
        guard let lati = latitude else {return}
        
        geoCodeLabel.text = "\(lati) \(long)"
        

        
        
    }
    
    func shareCaptureScreenImage() {
           // Capture the whole screen and share
           let bounds = UIScreen.main.bounds
           UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
           self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
           let img = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
       }
    
    
    func gettingMap(){
        
        guard let longi = longitude else {return}
        guard let lati = latitude else {return}
        
                 print(longi)
                 print(lati)
             
                 let temp1 = Double(longi)
                 let temp2 = Double(lati)
                
                 
                 guard let t1 = temp1 else {return}
                 guard let t2 = temp2 else {return}
                 
                 let annotation = MKPointAnnotation()
                 annotation.coordinate = CLLocationCoordinate2D(latitude: t2, longitude: t1)
                 annotation.title = subject
                 annotation.subtitle = "MBM"
         //        mapKit.addAnnotation(annotation)
                 mapKit.addAnnotation(annotation)
               
                 
                 let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
         //        MKMapView.setRegion(region, animated: true)
                 mapKit.setRegion(region, animated: true)
                 
             }
}
