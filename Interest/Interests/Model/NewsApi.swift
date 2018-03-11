//
//  NewsApi.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/2/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import CoreData

class NewsApi: NSObject {
    
    func searchNews( completionHandlerForSearchNews: @escaping (_ titles:[String]?,_ links:[String]?,_ images:[String]?, _ error: String?)->Void){
        let methodNews = [
            Constants.ParametrKeys.source : Constants.ParametrValue.source ,
            Constants.ParametrKeys.apiKey : Constants.ParametrValue.apiKey
        ]
        uploadNews(methodNews as [String:AnyObject]) { (titles, links,images, error) in
            if error != nil {
                completionHandlerForSearchNews(nil, nil,nil, error)
            } else {
                completionHandlerForSearchNews(titles, links, images, nil)
            }
        }
    }
    
    func uploadNews(_ parameters: [String:AnyObject], completionhandlerForUploadNews: @escaping (_ titles:[String]?,_ links:[String]?,_ imageString:[String]?, _ error: String?)->Void){
        
        let request = URLRequest(url: formateParameter(parameters))
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There is an error with your request")
                completionhandlerForUploadNews(nil, nil,nil,"No internet Connection" )
                return
            }
            guard let statuesCode = (response as? HTTPURLResponse)?.statusCode , statuesCode >= 200 && statuesCode <= 299 else {
                print("No internet Connection")
                completionhandlerForUploadNews(nil, nil, nil, "No internet Connection")
                return
            }
            guard let data = data else {
                print("No data Found , Try again")
                completionhandlerForUploadNews(nil, nil, nil, "No data Found , Try again")
                return
            }
            
            let parseResult : [String:AnyObject]!
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
               // print(parseResult)
            } catch {
                print("No data Found , Try again")
                completionhandlerForUploadNews(nil, nil, nil, "No data Found , Try again")
                return
            }
            guard let sat = parseResult[Constants.ResponseKey.statue] as? String ,
                sat == Constants.ResponseValue.statue else {
                    print("There is problem with server")
                    completionhandlerForUploadNews(nil, nil, nil, "There is problem with server")
                    return
            }
            guard let articleDictionary = parseResult[Constants.ResponseKey.article] as? [[String:AnyObject]]  else  {
                print("No atricles Found")
                completionhandlerForUploadNews(nil, nil, nil, "No Articles Found")
                return
            }
            
        // collect title by for loop in article
            var titles = [String]()
            var link  = [String]()
            var images = [String]()
            
            for title   in articleDictionary {
                if let headlines = title[Constants.ResponseKey.title] as? String,
                let links = title[Constants.ResponseKey.url] as? String, let imageNews = title[Constants.ResponseKey.image] as? String{
                    // add the value to array
                    
                    titles.append(headlines)
                    link.append(links)
                    images.append(imageNews)
                }
            }
           completionhandlerForUploadNews(titles, link, images, nil)
        }
        task.resume()
    }
    // This function to save news in core data
    func uploadNewsData() {
        let request = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=bloomberg&apiKey=f8c65cfeea364fdb99bb9ecadc5bbd07")!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There is an error with your request")
                return
            }
            guard let statuesCode = (response as? HTTPURLResponse)?.statusCode , statuesCode >= 200 && statuesCode <= 299 else {
                print("No Internet Connection")
                return
            }
            guard let data = data else {
                print("No data Found , Try again")
                return
            }
            
            let parseResult : [String:AnyObject]!
            
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                // print(parseResult)
            } catch {
                print("There is problem with parse data")
                return
            }
            guard let sat = parseResult[Constants.ResponseKey.statue] as? String ,
                sat == Constants.ResponseValue.statue else {
                    print("There is problem with server")
                    return
            }
            guard let articleDictionary = parseResult[Constants.ResponseKey.article] as? [[String:AnyObject]]  else  {
                print("There is problem with articles")
                return
            }
           
            for title   in articleDictionary {
                if let headlines = title[Constants.ResponseKey.title] as? String,
                    let links = title[Constants.ResponseKey.url] as? String, let imageNews = title[Constants.ResponseKey.image] as? String{
                    let new = News(context: CoreDataStack.shared.context)
                    new.title = headlines
                    new.imageUrl = imageNews
                    new.links = links
                    
                    CoreDataStack.shared.save()
                    
                    self.downloadImage(new.imageUrl!) { (imageData, error) in
                        if error != nil {
                            print(error)
                        } else {
                            guard let imageD = imageData , let newImage = UIImage(data: imageD as Data) else {
                                return
                            }
                            new.image = imageD as Data
                            CoreDataStack.shared.save()
                        }
                    }
                    
                }
                
            }
    }
    task.resume()
    }

    func formateParameter(_ parameter: [String:AnyObject])->URL {
        var componets = URLComponents()
        componets.scheme = Constants.Bloomberg.ApiScheme
        componets.host = Constants.Bloomberg.ApiHost
        componets.path = Constants.Bloomberg.apiPath
        componets.queryItems = [URLQueryItem]()
        
        for (key , value) in parameter {
            let queryitem = URLQueryItem(name: key, value: "\(value)")
            componets.queryItems?.append(queryitem)
            
        }
        return componets.url!
    }
    func downloadImage(_ url: String , comletionHandler: @escaping(_ imageData: NSData? ,_ error: NSError?)->Void ) {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            comletionHandler(data as! NSData, nil)
            
        }
        task.resume()
    }
}
