//
//  DetailViewController.swift
//  YouTubeMusicPlayer
//
//  Created by Himaja Motheram on 4/18/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit
import CoreData
import youtube_ios_player_helper


class DetailViewController: UIViewController,YTPlayerViewDelegate{
    
    var videoID: String!
    var thumbnail:String!
    var videoTitle:String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext :NSManagedObjectContext!
   
    @IBOutlet weak var PlayerView: YTPlayerView!
    override func viewDidLoad() {
    
    super.viewDidLoad()
    managedContext = appDelegate.persistentContainer.viewContext

    // Do any additional setup after loading the view.
    self.PlayerView.delegate = self
    print("HERE \(videoID)")
    if (videoID != nil){
    
     PlayerView.load(withVideoId: videoID)
    }

}
    
    func saveVideo( ){
        
        
        if (videoID != nil){
            
            if appDelegate.fetchTask(id: videoID) == false {
                
            
           let  newVideo = NSEntityDescription.insertNewObject(forEntityName: "Video", into: managedContext) as! Video
            newVideo.title =     videoTitle
            newVideo.thumbnail = thumbnail
            newVideo.videoId =   videoID
        
           // Append the desiredPlaylistItemDataDict dictionary to the videos array.
            appDelegate.saveContext()
         }
        }
        
    }


    @IBAction func SavebuttonPressed(_ sender: UIBarButtonItem) {
        
        saveVideo()
    }
    //override func didReceiveMemoryWarning() {
       // super.didReceiveMemoryWarning()
     //   // Dispose of any resources that can be recreated.
   // }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
