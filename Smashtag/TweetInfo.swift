//
//  TweetInfo.swift
//  Smashtag
//
//  Created by Darius on 6/5/16.
//  Copyright © 2016 DariusPri. All rights reserved.
//

import Foundation
import CoreData


class TweetInfo: NSManagedObject
{
    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> TweetInfo? {
       
        let request = NSFetchRequest(entityName: "TweetInfo")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? TweetInfo {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("TweetInfo", inManagedObjectContext: context) as? TweetInfo {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo, inManagedObjectContext: context)
            return tweet
        }
        return nil
    }
    
    
}
