//
//  TwitterUser.swift
//  Smashtag
//
//  Created by Darius on 6/5/16.
//  Copyright © 2016 DariusPri. All rights reserved.
//

import Foundation
import CoreData


class TwitterUser: NSManagedObject
{

    class func twitterUserWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> TwitterUser?
    {
        let request = NSFetchRequest(entityName: "TwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.user.screenName)
        
        if let twitterUser = (try? context.executeFetchRequest(request))?.first as? TwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObjectForEntityForName("TwitterUser", inManagedObjectContext: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.user.screenName
            twitterUser.name = twitterInfo.user.name
            return twitterUser
            
        }
        return nil
        
    }
    

}
