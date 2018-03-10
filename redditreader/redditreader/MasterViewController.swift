//
//  MasterViewController.swift
//  redditreader
//
//  Created by Ale Mohamad on 3/9/18.
//  Copyright © 2018 Ale Mohamad. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: - Variables
    var detailViewController: DetailViewController? = nil
    
    var redditItems = [RedditItem]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        getData()
        
        customizeNavigationBar()
        
        configTableView()
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
                controller.redditItem = redditItems[indexPath.row]
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
        return redditItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        let item = redditItems[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        cell.commentsLabel.text = item.getComments()
        cell.timeLabel.text = item.getHoursAgo()
        
        cell.thumbImageView.image = UIImage()
        
        if let thumb = item.thumbnail {
            if !thumb.isEmpty {
                DispatchQueue.global().async {
                    let url = URL(string: thumb)
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        cell.thumbImageView.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Functions
    
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
                redditItems.append(item.data)
            }
            
            tableView.reloadData()
        }
    }
    
    func customizeNavigationBar() {
        let nb = navigationController?.navigationBar
        nb?.barStyle = UIBarStyle.blackTranslucent
        nb?.tintColor = UIColor.white
    }
    
    func configTableView() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(getNewData), for: .valueChanged)
        refreshControl = refresh
    }
    
    @objc func getNewData() {
        refreshControl?.endRefreshing()
    }
    
}

