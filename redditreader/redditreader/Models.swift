//
//  Models.swift
//  redditreader
//
//  Created by Ale Mohamad on 3/10/18.
//  Copyright © 2018 Ale Mohamad. All rights reserved.
//

import Foundation

struct RedditList: Decodable {
    let kind: String
    let data: ListData
}

struct ListData: Decodable {
    let modhash: String
    let children: [DataChildren]
}

struct DataChildren: Decodable {
    let kind: String
    let data: RedditItem
}

struct RedditItem: Decodable {
    let title: String
    let thumbnail: String?
    let author: String
    let num_comments: Int
    let created: Int
    
    func getHoursAgo() -> String {
        let createdDate = Date(timeIntervalSince1970: Double(created))
        
        let interval = Calendar.current.dateComponents([.hour], from: createdDate, to: Date()).hour!
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour ago" : "\(interval)" + " hours ago"
        }
        
        return "Just now"
    }
    
    func getComments() -> String {
        return num_comments == 1 ? "\(num_comments)" + " comment" : "\(num_comments)" + " comments"
    }
}
