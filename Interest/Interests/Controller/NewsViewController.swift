//
//  HomeViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 2/28/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//
/*
import UIKit
import CoreData
// MARK: - NewsViewController
class NewsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
   
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let newsApi = NewsApi()
    var news = [News]()
    var refreshController : UIRefreshControl!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
       // refresh indicator
        refreshController = UIRefreshControl()
        refreshController.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshController)
        
        // check Coredata or uplpad news form api
        if let newsOfCoreData = uploadNewsFromCoreDate() {
            news = newsOfCoreData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(news.count)
            
        } else {
            uploadNewsFromBloomberg()
        }
    }
    
    @objc func refresh(){
        
        print("done")
        refreshController.endRefreshing()
    }
    
    
    // MARK: Functions
    
    func uploadNewsFromCoreDate()->[News]?{
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "News")

        do {
            if let result = try CoreDataStack.shared.context.fetch(fr) as? [News] {
                if result.count > 0 {
                    return result
                  
                }
            }
        } catch {
            print("No News Found")
        }
        
        return nil
    }
    
    func uploadNewsFromBloomberg(){
        newsApi.searchNews { (success, error) in
            if error != nil {
                print("error to downdload data from website")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func deletNews(){
        
        
}
}
extension NewsViewController {
    
    // MARK: TableView
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ArticleTableViewCell
        let news = self.news[indexPath.row]
        cell?.titleNews.text = news.title
        cell?.publishedNews.text = news.published
        cell?.imageNews.image = nil
        
        // upload image
        
        if cell?.imageNews == nil {
        newsApi.uploadImageFromBloomerg(news.imageUrl!) { (image, error) in
            if error != nil {
                print("No image found")
            } else {
                guard let imageData = image , let newImage = UIImage(data: imageData as Data) else {
                    return
                }
                DispatchQueue.main.async {
                    cell?.imageNews.image = UIImage(data: imageData as Data)
                    news.image = imageData as Data
                    CoreDataStack.shared.save()
                }
                
            }
        }
        } else {
            cell?.imageNews.image = UIImage(data: news.image as! Data)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        

    }
}
*/
