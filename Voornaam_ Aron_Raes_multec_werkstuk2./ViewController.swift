//
//  ViewController.swift
//  Voornaam_ Aron_Raes_multec_werkstuk2.
//
//  Created by Aron Raes on 30/04/18.
//  Copyright © 2018 Aron Raes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        myMapView.delegate = self
        myMapView.mapType = .standard
        myMapView.isZoomEnabled = true
        myMapView.isScrollEnabled = true
        
        if let coor = myMapView.userLocation.location?.coordinate{
            myMapView.setCenter(coor, animated: true)
        }
        
        
        
        
        
        //url request
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
        let urlRequest = URLRequest(url: url!)
        
        //setup session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        //make request
        let task = session.dataTask(with: urlRequest) {(data, response, error) in// check for errors
            guard error == nil else{
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else{
                print("Error: did not receive data")
                return
            }
            
            do {
                
                //let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
                
                guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                    print("failed JSONSerialization")
                    return
                    
                }
                
                for villo in villoData!{
                    let testString = villo["name"] as! String?
                    let coordinatesJSON = villo["position"] as? [String: Double]
                    let latitude = coordinatesJSON!["lat"]
                    let longitude = coordinatesJSON!["lng"]
                    print(testString, latitude ,longitude)
                    
                }
                
                
                DispatchQueue.main.async{
                    //labels, of annotation data geven
                }
            }
            
        }
        task.resume()
        
        
        
        
        
        
//        for location in locations {
//            let annotation = MKPointAnnotation()
//            annotation.title = location["title"] as? String
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
//            self.myMapView.addAnnotation(annotation)
//            self.myMapView.showAnnotations(self.myMapView.annotations, animated: true)
//        }
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        myMapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        myMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Aron Raes"
        annotation.subtitle = "current location"
        myMapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }


}

