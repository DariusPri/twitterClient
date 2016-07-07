//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Darius on 6/2/16.
//  Copyright © 2016 DariusPri. All rights reserved.
//

import UIKit
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText where !query.isEmpty {
            return TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue(), {
                    if request === weakSelf?.lastTwitterRequest! {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0) // pradzioj lenteles
                            weakSelf?.updateDatabase(newTweets)
                        }
                    }
                })
            }
        }
    }
    
    private func updateDatabase(newTweets: [Tweet]) { // Twitter.tweet
        managedObjectContext?.performBlock {
            for twitterInfo in newTweets {
                // craete a new, unique Tweet in ... 
                _ = TweetInfo.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            do{
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error : \(error)")
            }
        }
        printDatabaseStatistics()
        print("Done printing db statistics")
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.performBlock {
            if let results = try? self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results.count) Twitter Users")
            }
            
            let tweetCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "TweetInfo"), error: nil)
            print("\(tweetCount) Tweets")
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
       // searchText = "#stanford"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweetersTVC = segue.destinationViewController as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }
    }
    
    
    
    
    @IBAction func refreshTweets(sender: UIRefreshControl!) {
        searchForTweets()
        sender.endRefreshing()
    }


    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }


    @IBOutlet weak var searchTextField: UITextField! {
        didSet{
        searchTextField.delegate = self
        searchTextField.text = searchText
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
