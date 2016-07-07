//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Darius on 6/2/16.
//  Copyright © 2016 DariusPri. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {


    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
        
    }
    
    private func updateUI()
    {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            
        }
        tweetScreenNameLabel?.text = "\(tweet?.user)"
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = NSData(contentsOfURL: profileImageURL){
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        }
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate((tweet?.created)!) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        }else{
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        
        tweetCreatedLabel?.text = formatter.stringFromDate((tweet?.created)!)
        
    }



}