//
//  MasterViewController.swift
//  redditreader
//
//  Created by Ale Mohamad on 3/9/18.
//  Copyright © 2018 Ale Mohamad. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var places = ["Los Angeles", "New York", "San Francisco"]


    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = places[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = places[indexPath.row]

        return cell
    }
    
    func readJson() -> RedditList? {
        if let path = Bundle.main.path(forResource: "top", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                let reddit = try JSONDecoder().decode(RedditList.self, from: data)
                return reddit
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
        }
        return nil
    }
    
    func getData() {
        if let reddit = readJson() {
            for item in reddit.data.children {
                print(item.data)
            }
        }
    }
    
}

