//
//  TableViewController.swift
//  YouTubeMusicPlayer
//
//  Created by Himaja Motheram on 4/22/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext :NSManagedObjectContext!
    @IBOutlet weak var MusicTableView: UITableView!
    
    var intvideosArray = [Video]()


    override func viewDidLoad() {
        super.viewDidLoad()

        managedContext = appDelegate.persistentContainer.viewContext

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        intvideosArray = appDelegate.fetchAllTasks()
      //  print ("************HERE*****************")
        //print("Count \(intvideosArray.count)")
        MusicTableView.reloadData()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         intvideosArray = appDelegate.fetchAllTasks()
        // print("Count \(intvideosArray.count)")
       // print ("************HERE--1*****************")
        //print("Count \(intvideosArray.count)")
        MusicTableView.reloadData()
    }
    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override*/ func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return intvideosArray.count

    }

    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicTableView.dequeueReusableCell(withIdentifier: "MusicViewCell", for: indexPath)

        // Configure the cell...
        
       print("here")
       let videoDetails = intvideosArray[indexPath.row] as Video
       cell.textLabel?.text =  intvideosArray[indexPath.row].title //videoDetails["title"] as? String
      // print ("************HERE*****************")
       print(videoDetails)
    
       return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
   /* override*/ func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
                let taskToDelete = intvideosArray[indexPath.row]
                 managedContext.delete(taskToDelete)
                 appDelegate.saveContext()
                 intvideosArray = appDelegate.fetchAllTasks()
                 MusicTableView.deleteRows(at: [indexPath], with: .automatic)
                 MusicTableView.isEditing = false
            

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("\(MusicTableView.indexPathForSelectedRow)")
        // if (MusicTableView.indexPathForSelectedRow != nil){
        if segue.identifier == "savesegueshow"{
            
            if (MusicTableView.indexPathForSelectedRow != nil)
            {
                let destinationVC = segue.destination as! DetailViewController
                let indexPath = MusicTableView.indexPathForSelectedRow!
                //print("HERRE***** \(intvideosArray[indexPath.row].title), \(videosArray[indexPath.row]) *******")
                destinationVC.videoID = intvideosArray[indexPath.row].videoId
                destinationVC.videoTitle  = intvideosArray[indexPath.row].title
                destinationVC.thumbnail  = intvideosArray[indexPath.row].thumbnail
              //  print ( "\(indexPath.row) <= \(videosArray.count)")
                MusicTableView.deselectRow(at: indexPath, animated: true)
            }
        }

    }
 

    @IBAction func RemoveAllButtonPressed(_ sender: UIBarButtonItem) {
        
        deleteallVideos()
    }
    
     func deleteallVideos()
     {
        
        intvideosArray = appDelegate.fetchAllTasks()
        print ("************HERE*****************")
        print("Count \(intvideosArray.count)")
        MusicTableView.reloadData()
        for video in intvideosArray{
            managedContext.delete(video)
            
        }
        appDelegate.saveContext()
        intvideosArray = appDelegate.fetchAllTasks()
        MusicTableView.reloadData()

        print ("************HERE2*****************")
        print("Count \(intvideosArray.count)")

    }
}
