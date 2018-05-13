//
//  DetailsViewController.swift
//  Voornaam_ Aron_Raes_multec_werkstuk2.
//
//  Created by Aron Raes on 13/05/18.
//  Copyright © 2018 Aron Raes. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailsViewController: UIViewController {
    
       let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var aantalSlots: UILabel!
    @IBOutlet weak var aantalSlotsBeschikbaar: UILabel!
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var naam: UILabel!
    @IBOutlet weak var aantalBeschikbaar: UILabel!
    
    var Naam = ""
    
    var opgehaaldeVilloStations:[VilloStation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
                //gegevens uilezen van coredata
                let villoStationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
                do{
                    
                    self.opgehaaldeVilloStations = try self.managedContext?.fetch(villoStationFetch) as! [VilloStation]
                    //print(self.opgehaaldeVilloStations[6].naam!)
                    
                    let stations = self.opgehaaldeVilloStations
                    
                    for  station in stations {
                        if (station.naam == Naam ){
                            self.naam.text = station.naam
                            
                            self.aantalBeschikbaar.text = "\((station.aantalSlotsBeschikbaar))"
                            
                            self.aantalSlots.text = "\((station.aantalSlots))"
                            
                            self.aantalSlotsBeschikbaar.text = "\((station.aantalSlotsBeschikbaar))"
                            
                            let annotation = MKPointAnnotation()
                            annotation.title = (station.naam)
                            annotation.coordinate = CLLocationCoordinate2D(latitude: (station.latitiude), longitude: (station.longitude))
                            self.myMapView.addAnnotation(annotation)
                            self.myMapView.showAnnotations(self.myMapView.annotations, animated: true)
                        }
                       
                    }
                } catch{fatalError("Failedtofetchemployees: \(error)")
                    
                }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
