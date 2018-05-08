//
//  LijstTableViewController.swift
//  Voornaam_ Aron_Raes_multec_werkstuk2.
//
//  Created by Aron Raes on 8/05/18.
//  Copyright © 2018 Aron Raes. All rights reserved.
//

import UIKit
import CoreData

class LijstTableViewController: UITableViewController, UISearchBarDelegate  {
    
    var opgehaaldeVilloStations:[VilloStation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
            
               
                //gegevens uilezen van coredata
                let villoStationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VilloStation")
                do{
                    
                    self.opgehaaldeVilloStations = try managedContext.fetch(villoStationFetch) as! [VilloStation]
                    //print(self.opgehaaldeVilloStations[6].naam!)
                    
                    
                } catch{fatalError("Failedtofetchemployees: \(error)")
                    
                }
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextvc = segue.destination as? DetailTableItemViewController {
            let indexpath = self.tableView.indexPathForSelectedRow!
            nextvc.temp = self.opgehaaldeVilloStations[indexpath.row]
            
        }
        
    }
 

}
