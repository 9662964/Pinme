//
//  DetailViewController.swift
//  WhereIWas
//
//  Created by iljoo Chae on 8/18/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import SwipeCellKit

class ListViewController: UIViewController {
    
    var placeArray = [Place]()
    var longi: String = ""
    var lati: String = ""
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    @IBOutlet weak var mapkit: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var latitude: UILabel!
//    @IBOutlet weak var longitude: UILabel!
//    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        gettingMap()
        loadPlace()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        print(placeArray.count)
//        titleLabel.text = placeArray.last?.title
//        address.text = placeArray.last?.address
//        longitude.text = placeArray.last?.longitude
//        latitude.text = placeArray.last?.latitude
        
        
       
       
}
    

    

    
    
    func loadPlace() {
        
        let request : NSFetchRequest<Place> = Place.fetchRequest()
        do {
            placeArray = try context.fetch(request)
        }catch{
            print("Error while fetching data from context = \(error.localizedDescription)")
        }
    }
    

    
//
//    func gettingMap(){
//                print(longi)
//                print(lati)
//
//                let temp1 = Double(longi)
//                let temp2 = Double(lati)
//
//
//                guard let t1 = temp1 else {return}
//                guard let t2 = temp2 else {return}
//
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = CLLocationCoordinate2D(latitude: t2, longitude: t1)
//                annotation.title = "Place to remember"
//                annotation.subtitle = "MBM"
//        //        mapKit.addAnnotation(annotation)
//                mapkit.addAnnotation(annotation)
//
//
//                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//        //        MKMapView.setRegion(region, animated: true)
//                mapkit.setRegion(region, animated: true)
//
//            }
}





extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(self.placeArray[indexPath.row])
            self.placeArray.remove(at: indexPath.row)
            ViewController.shared.saveLocation()
            tableView.reloadData()
        }
    }
    

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        cell.textLabel?.text = placeArray[indexPath.row].title
        cell.detailTextLabel?.text = placeArray[indexPath.row].address
        cell.backgroundColor = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        titleLabel?.text = placeArray[indexPath.row].title
//        longitude?.text = placeArray[indexPath.row].longitude
//        latitude?.text = placeArray[indexPath.row].latitude
//        address?.text = placeArray[indexPath.row].address

//        context.delete(placeArray[indexPath.row])
//        placeArray.remove(at: indexPath.row)
//        ViewController.shared.saveLocation()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let nextVC = segue.destination as? DetailViewController {
                var index = tableView.indexPathForSelectedRow?.row
//                nextVC.tempArray = placeArray[index]
                
                guard let magicNumber = index else {return}
                
                print(placeArray[magicNumber] )
//                nextVC.tempIndex = magicNumber
                nextVC.subject = placeArray[magicNumber].title
//                nextVC.date = placeArray[magicNumber].date
                nextVC.address = placeArray[magicNumber].address
                nextVC.longitude = placeArray[magicNumber].longitude
                nextVC.latitude = placeArray[magicNumber].latitude
                
            }
        }
    }
}





