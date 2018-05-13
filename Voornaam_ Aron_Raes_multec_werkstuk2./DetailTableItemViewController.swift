//
//  DetailTableItemViewController.swift
//  Voornaam_ Aron_Raes_multec_werkstuk2.
//
//  Created by Aron Raes on 8/05/18.
//  Copyright © 2018 Aron Raes. All rights reserved.
//

import UIKit
import MapKit

class DetailTableItemViewController: UIViewController {
    
    var temp:VilloStation?
    
    @IBOutlet weak var lblNaam: UILabel!
    @IBOutlet weak var lblAantalFietsenBeschikbaar: UILabel!
    @IBOutlet weak var lblAantalSlots: UILabel!
    @IBOutlet weak var lblAantalSlotsBeschikbaar: UILabel!
    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNaam.text = "\((temp?.naam)!)"
        self.lblAantalFietsenBeschikbaar.text = "\((temp?.aantalFietsen)!)"
        self.lblAantalSlots.text = "\((temp?.aantalSlots)!)"
        self.lblAantalSlotsBeschikbaar.text = "\((temp?.aantalSlotsBeschikbaar)!)"
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
            let annotation = MKPointAnnotation()
            annotation.title = (temp?.naam)
            annotation.coordinate = CLLocationCoordinate2D(latitude: (temp?.latitiude)!, longitude: (temp?.longitude)!)
            self.myMapView.addAnnotation(annotation)
        self.myMapView.showAnnotations(self.myMapView.annotations, animated: true)
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
