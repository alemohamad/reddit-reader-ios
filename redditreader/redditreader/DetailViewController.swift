//
//  DetailViewController.swift
//  redditreader
//
//  Created by Ale Mohamad on 3/9/18.
//  Copyright © 2018 Ale Mohamad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    // MARK: - Variables
    
    var redditItem: RedditItem? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        customizeNavigationBar()
    }
    
    // MARK: - Functions
    
    func configureView() {
        if let item = redditItem,
            let authorLabel = authorLabel,
            let titleLabel = titleLabel {
            authorLabel.text = item.author
            titleLabel.text = item.title
            
            if let thumb = item.thumbnail {
                if !thumb.isEmpty {
                    DispatchQueue.global().async {
                        let url = URL(string: thumb)
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.thumbImageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
        }
        else {
            if let authorLabel = authorLabel,
                let titleLabel = titleLabel {
                authorLabel.text = ""
                titleLabel.text = ""
            }
        }
    }
    
    func customizeNavigationBar() {
        let nb = navigationController?.navigationBar
        nb?.barStyle = UIBarStyle.blackTranslucent
        nb?.tintColor = UIColor.white
    }
    
}

