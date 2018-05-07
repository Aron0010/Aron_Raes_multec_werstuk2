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
import CoreData

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    /* -----------------------------------------------------------  */
    
    
    //globaal definieren van appdelegate en managed context

    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
/* -----------------------------------------------------------  */

    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var opgehaaldeVilloStations:[VilloStation] = []
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refreshdata()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //controleren of gegevens al opgehaald zijn link:https://stackoverflow.com/questions/27208103/detect-first-launch-of-ios-app?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
        let launch = UserDefaults.standard.bool(forKey: "launchbefore")
        if !launch{
            self.haalDataOp()
        }else{
            self.tone()
        }
        
        //locatie services authenticatie
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //standaard fucties map aanzetten
        myMapView.delegate = self
        myMapView.mapType = .standard
        myMapView.isZoomEnabled = true
        myMapView.isScrollEnabled = true
        if let coor = myMapView.userLocation.location?.coordinate{
            myMapView.setCenter(coor, animated: true)
        }
}
    
    
    
     /* -----------------------------------------------------------  */
    
    
    
    
    //refresh de core data
    func refreshdata(){
//        //deleting van alle informatie in een entiti link:https://cocoacasts.com/how-to-delete-every-record-of-a-core-data-entity
        //links delete annotatioins: https://stackoverflow.com/questions/32850094/how-do-i-remove-all-map-annotations-in-swift-2
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
     do {
        let items = try self.managedContext?.fetch(fetchRequest) as! [NSManagedObject]
                                
         for item in items {
            self.managedContext?.delete(item)
            }
        let allAnnotations = self.myMapView.annotations
        self.myMapView.removeAnnotations(allAnnotations)
         // Save Changes
        try self.managedContext?.save()
            } catch {
          // Error Handling
              // ...
          }
         self.haalDataOp()
    }
    
    
       /* -----------------------------------------------------------  */
    
    
    
    func haalDataOp(){
        
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
                guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                    print("failed JSONSerialization")
                    return
                }
                
                for villo in villoData!{
                    //gegeven uitlezen van de json
                    let naam = villo["name"] as! String
                    let aantalSlots = villo["bike_stands"] as! Int
                    let aantalSlotsBeschikbaar = villo["available_bike_stands"] as! Int
                    let aantalFietsen = villo["available_bikes"] as! Int
                    
                    let coordinatesJSON = villo["position"] as? [String: Double]
                    let latitude = coordinatesJSON!["lat"]
                    let longitude = coordinatesJSON!["lng"]
                    /* -----------------------------------------------------------  */
                    //gegevens in coredata zetten
                    let villoStation = NSEntityDescription.insertNewObject(forEntityName: "VilloStation", into: self.managedContext!) as! VilloStation
                    villoStation.naam = naam
                    villoStation.aantalSlots = Int16(aantalSlots)
                    villoStation.aantalSlotsBeschikbaar = Int16(aantalSlotsBeschikbaar)
                    villoStation.aantalFietsen = Int16(aantalFietsen)
                    villoStation.latitiude = latitude!
                    villoStation.longitude = longitude!
                
                    do{
                        try self.managedContext?.save()
                        
                    } catch{
                        fatalError("Failure tosave context: \(error)")
                    }
                }
                self.tone()
            }
            
            }
        task.resume()
        
    }
            
                /* -----------------------------------------------------------  */
    
    
            func tone(){
                 DispatchQueue.main.async{
                //gegevens uilezen van coredata
                let villoStationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
                do{
                    
                    self.opgehaaldeVilloStations = try self.managedContext?.fetch(villoStationFetch) as! [VilloStation]
                    //print(self.opgehaaldeVilloStations[6].naam!)
                    
                    let stations = self.opgehaaldeVilloStations
                    
                    for  station in stations {
                        let annotation = MKPointAnnotation()
                        annotation.title = station.naam
                        annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitiude , longitude: station.longitude )
                        self.myMapView.addAnnotation(annotation)
                    }
                } catch{fatalError("Failedtofetchemployees: \(error)")
                
                    }
                }
            }
                /* -----------------------------------------------------------  */
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //pins met annotation callout link: https://stackoverflow.com/questions/33978455/swift-how-do-i-make-a-pin-annotation-callout-full-steps-please
        
        //eigen locatie op de map plaatsen
      
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
 /* -----------------------------------------------------------  */
    
    
    //Bron: https://stackoverflow.com/questions/15270085/pass-data-between-view-controllers-without-segues
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewControllerId") as! DetailsViewController
            detailViewController.naam = (view.annotation?.title)!
            //detailViewController.fhsdjk = (view.annotation?.title)!
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
        }
    }
    
    
     /* -----------------------------------------------------------  */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




