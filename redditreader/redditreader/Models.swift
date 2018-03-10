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
}
