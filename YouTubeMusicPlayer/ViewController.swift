//
//  ViewController.swift
//  YouTubeMusicPlayer
//
//  Created by Himaja Motheram on 4/17/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit
import CoreData

//video details - title, thumbnail,videoid
class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext :NSManagedObjectContext!
    
    @IBOutlet weak var SearchButton: UIBarButtonItem!
   
    @IBOutlet weak var MusicSearchBar: UISearchBar!
    
    @IBOutlet weak var MusicTableView: UITableView!
    
    var selectedVideoIndex: Int!
   
    var apiKey = "AIzaSyDzceBY1MEbbyX5i-jDFR_xcysA6EuV5J4"
    
    
    var desiredChannelsArray = ["Apple", "Google", "Microsoft"]
    
    var channelIndex = 0
  
    var videoName: String = ""
    
    var channelsDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       managedContext = appDelegate.persistentContainer.viewContext
    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        MusicTableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("\(MusicTableView.indexPathForSelectedRow)")
      
        if segue.identifier == "segueview"{
           
            if (MusicTableView.indexPathForSelectedRow != nil)
            {
            let destinationVC = segue.destination as! DetailViewController
            let indexPath = MusicTableView.indexPathForSelectedRow!
                
            print ( "\(indexPath.row) <= \(videosArray.count)")
                
            typealias JSONObject = [String:AnyObject]
            let videoDetails = videosArray[selectedVideoIndex] as! JSONObject

                
            destinationVC.videoID = videoDetails["videoID"] as? String
            
            destinationVC.videoTitle  = videoDetails["title"] as? String
            destinationVC.thumbnail  = videoDetails["thumbnail"] as? String
        
            MusicTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        else if segue.identifier == "seguetable" {
         
            let destinationVC =  segue.destination as! TableViewController
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videosArray.count
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            // Show the activity indicator.
            //viewWait.hidden = false
            
          // Remove all existing video details from the videosArray array.
        
          //videosArray.removeAll(keepingCapacity: false)
          selectedVideoIndex = indexPath.row
          print ("  selectedVideoIndex \(selectedVideoIndex)")
          // Fetch the video details for the tapped channel.
          //MusicVideoSearch( )
        
    
    }
    
    
    func MusicVideoSearch( )
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let MusicName = MusicSearchBar.text!
        let type = "video"
        
        // Form the request URL string.
        
       // let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(MusicName)&type=\(type)&key=\(apiKey)"
    
      //  var url : NSString  = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(MusicName)&type=video&videoSyndicated=true&chart=mostPopular&maxResults=5&safeSearch=strict&order=relevance&order=viewCount&type=video&relevanceLanguage=en-US&key=\(apiKey)" as NSString
        
        let urlstr : NSString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(MusicName)&type=\(type)&safeSearch=strict&key=\(apiKey)" as NSString
        let urlString : NSString = urlstr.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
      
        let url = URL(string: urlString as String )
        var request = URLRequest(url: url!)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let recvData = data else {
                print("No Data")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if recvData.count > 0 && error == nil {
                print("Got Data:\(recvData)")
                let dataString = String.init(data: recvData, encoding: .utf8)
                print("Got Data String:\(dataString)")
                self.parseJsonVideos(data: recvData)
            } else {
                print("Got Data of Length 0")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
        
    }

    
    func parseJsonVideos(data: Data) {
        
        do {
            
            typealias JSONObject = [String:AnyObject]
            
            
            let  json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
            let items  = json["items"] as! Array<JSONObject>
            
            
            // Use a loop to go through all video items.
            
            for i in 0 ..< items.count {
                
                let playlistSnippetDict = items[i]["snippet"] as! JSONObject
                print(playlistSnippetDict )
                var desiredPlaylistItemDataDict = JSONObject()
                desiredPlaylistItemDataDict["title"] = playlistSnippetDict["title"]
               
                desiredPlaylistItemDataDict["thumbnail"] = ((playlistSnippetDict["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"]
        
                desiredPlaylistItemDataDict["videoID"] = playlistSnippetDict["id"]
            
                desiredPlaylistItemDataDict["videoID"] = (items[i]["id"] as! JSONObject)["videoId"]
                
                // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                self.videosArray.append(desiredPlaylistItemDataDict as [NSObject : AnyObject])
                
                // Reload the tableview.
                self.MusicTableView.reloadData()
               // print(videosArray)
               
            }
            
            MusicTableView.reloadData()
            
            
        } catch {
            print("JSON Parsing Error")
        }
        MusicTableView.reloadData()
        
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    

    
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       

        
        guard let cell = MusicTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
       
        typealias JSONObject = [String:AnyObject]
        
        let videoDetails = videosArray[indexPath.row] as! JSONObject
        
        cell.videoLabel.text =  videoDetails["title"] as? String
        
        cell.videoImage.image = UIImage(data: NSData(contentsOf: NSURL(string: (videoDetails["thumbnail"] as? String)!)! as URL)! as Data)

        //print ("************HERE2*****************")
        //print(videoDetails)
       return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         
        }
    }

    @IBAction func SearchClick(_ sender: UIBarButtonItem) {
        
        videoName = MusicSearchBar.text!
        
        videosArray.removeAll(keepingCapacity: false)
        MusicTableView.reloadData()
        MusicVideoSearch()
        
    }
    
    func SaveVideoResult(){
        
       typealias JSONObject = [String:AnyObject]
    
       let videoDetails = videosArray[selectedVideoIndex] as! JSONObject
    
        let videoID = videoDetails["videoID"] as! String?
        
        if appDelegate.fetchTask(id: videoID!) == false {

        let newVideo = NSEntityDescription.insertNewObject(forEntityName: "Video", into: managedContext) as! Video
        
       
        newVideo.title =     videoDetails["title"] as! String?
        newVideo.thumbnail = videoDetails["thumbnail"] as? String
        newVideo.videoId =   videoDetails["videoID"] as! String?
        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
        
        appDelegate.saveContext()
        
        }
        

    }
    
    @IBAction func SaveClick(_ sender: UIBarButtonItem) {
        
        if (MusicTableView.indexPathForSelectedRow != nil ) {
       /* let newVideo = NSEntityDescription.insertNewObject(forEntityName: "Video", into: managedContext) as! Video
       
        typealias JSONObject = [String:AnyObject]
            
         let videoDetails = videosArray[selectedVideoIndex] as! JSONObject
         newVideo.title =     videoDetails["title"] as! String?
         newVideo.thumbnail = videoDetails["thumbnail"] as? String
         newVideo.videoId =   videoDetails["videoID"] as! String?
        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
        
        appDelegate.saveContext()*/
            SaveVideoResult()
        }
}
    
}

