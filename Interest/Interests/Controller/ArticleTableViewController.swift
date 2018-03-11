//
//  TableViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/14/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import CoreData
// MARK:- ArticleTableViewController
class ArticleTableViewController: UITableViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet var table: UITableView!
    
    // MARK: Properties
    let newsapi  = NewsApi()
    var news = [News]()
    var  titles = [NewsClass]()
    var pics = [NewsClass]()
    var urls = [NewsClass]()
    var newsClass = [NewsClass]()
    var refreshController : UIRefreshControl!
    let internet = Reachability()!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        internet.whenReachable =  { _ in
            
            // check if coreData has news if not upload from api
            if let coreDataNews = self.uploadNewsFromCoreData() {
                print("uploadNewsFromCoreData")
                self.news = coreDataNews
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                //print(news.count)
            } else {
                print(" uploadNewsFromBloomerg()")
                self.uploadNewsFromBloomerg()
            }
            // refresh indicator
            self.refreshController = UIRefreshControl()
            self.refreshController.attributedTitle = NSAttributedString(string: "Upload News")
            self.refreshController.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            self.tableView.addSubview(self.refreshController)
        }
        internet.whenUnreachable = { _ in
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
            }
        }
        
        // method to check internet while useing controller
        NotificationCenter.default.addObserver(self, selector: #selector(checkingInternet), name: .reachabilityChanged, object: internet)
        do{
            try internet.startNotifier()
        } catch {
            print("error")
        }
    }
    
    // MARK: Functions
    
    @objc func refresh(){
        print("done")
        // delete all news in data
        for new in news {
            CoreDataStack.shared.context.delete(new)
        }
        // renew all array to new data
        news = []
        titles = []
        urls = []
        pics = []
        // upload from api again for last news
        uploadNewsFromBloomerg()
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        refreshController.endRefreshing()
    }
    
    
    @objc func checkingInternet(_ notification: Notification){
        let reachInternet = notification.object as! Reachability
        if reachInternet.isReachable {
            print("Internet is on")
        } else {
            DispatchQueue.main.async {
                AlertViewController.alert("Error", "No Internet Connection", in: self)
            }
        }
    }
    private  func uploadNewsFromCoreData()->[News]?{
        let fr = NSFetchRequest<News>(entityName: "News")
        do {
            let result   = try CoreDataStack.shared.context.fetch(fr)
            if result.count > 0 {
                return result
            }
        }
        catch {
            AlertViewController.alert("Error", "No Data Found", in: self)
        }
        return nil
    }
    
    private func uploadNewsFromBloomerg(){
        // this function to save data in Core Data
        newsapi.uploadNewsData()
        // and this one to show it in the screen
        newsapi.searchNews { (titles, links, imagesUrl, error) in
            if error != nil {
                AlertViewController.alert("Error", error as! String, in: self)
                return
            } else {
                if let newTitle = titles , let newLink = links , let newImageUrl = imagesUrl {
                    
                    for newTitles in newTitle {
                        let new = NewsClass()
                        new.title = newTitles
                        for newLinks in newLink {
                            let newUrl = NewsClass()
                            newUrl.url = newLinks
                            self.urls.append(newUrl)
                        }
                        
                        for newImageUrls in newImageUrl {
                            let newImage = NewsClass()
                            newImage.imageUrl = newImageUrls
                            self.pics.append(newImage)
                        }
                        self.titles.append(new)
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // make sure if data come from Core Data or Website Server.
        if titles.count > 0 {
            print("not core data")
            return self.titles.count
        } else {
            print("Core Data Now ")
            return self.news.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        
        // make sure if data come from Core Data or Website Server.
        if  self.titles.count > 0 {
            let newsTitles = self.titles[indexPath.row]
            cell.titleLabel.text = newsTitles.title
            let newPic = self.pics[indexPath.row]
            cell.imageNews.downloadImage(newPic.imageUrl)
            
        } else {
            let newsB = self.news[indexPath.row]
            cell.titleLabel.text = newsB.title
            
            // to avoid crash if the pic doesn't download becase bad internet connection
            if let imageCoreData = newsB.image {
                cell.imageNews.image = UIImage(data: imageCoreData)
            } else {
                cell.imageNews.downloadImage(newsB.imageUrl)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let webVc = self.storyboard?.instantiateViewController(withIdentifier: "webView") as! WebViewViewController
        if self.urls.count > 0 {
            let newUrl = self.urls[indexPath.row]
            webVc.url = newUrl.url
        } else {
            let new = self.news[indexPath.item]
            webVc.url = new.links
        }
        self.present(webVc, animated: true, completion: nil)
    }
}

// MARK:UiimageView

extension UIImageView {
    func downloadImage(_ url:String?){
        let urlRequest = URLRequest(url: URL(string: url!)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error)
                return
            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}
