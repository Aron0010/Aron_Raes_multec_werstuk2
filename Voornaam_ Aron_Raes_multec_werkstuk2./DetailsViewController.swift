//
//  DetailsViewController.swift
//  Voornaam_ Aron_Raes_multec_werkstuk2.
//
//  Created by Aron Raes on 7/05/18.
//  Copyright © 2018 Aron Raes. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var naam: String?
    var aantalFietsen: Int?
    var aantalVrijPlaatsen: Int?
    var maxAantalFietsen: Int?
    var latitude: Double?
    var longitude: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(naam!)
        // Do any additional setup after loading the view.
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
