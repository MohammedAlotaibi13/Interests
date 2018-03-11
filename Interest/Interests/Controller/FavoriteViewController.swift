//
//  FavoriteViewController.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/2/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import UIKit
import CoreData

// MARK: - FavoriteViewController
class FavoriteViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: Properties
    
    var favorite = [LikeResult]()
    var selectedItem = [LikeResult]()
    
    // MARK: - Life Cycle :
    override func viewDidLoad() {
        super.viewDidLoad()
        // handle table view
        tableView.dataSource = self
        tableView.delegate = self
        
        if let coreDataFavorite = uploadIFavoriteFromCoreData() {
            favorite = coreDataFavorite
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noDataLabelOff()
            }
        } else {
            self.noDataLabelOn()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if favorite.isEmpty {
            self.noDataLabelOn()
        }
    }
    
    // MARK: Function
    
    public func uploadIFavoriteFromCoreData()->[LikeResult]?{
        
        let fr = NSFetchRequest<LikeResult>(entityName: "LikeResult")
        do {
            let result = try CoreDataStack.shared.context.fetch(fr)
            if result.count > 0 {
                return result
            }
        } catch {
            print("No data found")
        }
        return nil 
    }
    
    
    func noDataLabelOn(){
        self.secondView.isHidden = false
        self.noDataLabel.isHidden = false
    }
    
    func noDataLabelOff(){
        self.secondView.isHidden = true
        self.noDataLabel.isHidden = true
    }
    
    
    
    // MARK: Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoritTableViewCell
        let favoriteItems = self.favorite[indexPath.row]
        
        cell.bankName.text =  favoriteItems.bankName
        cell.duration.text = String(favoriteItems.duration)
        cell.instalment.text = String(favoriteItems.instalment)
        cell.interesteRate.text = String(favoriteItems.interestRate)
        cell.totalLoan.text = String(favoriteItems.totalLoan)
        cell.amount.text = String(favoriteItems.amount)
        cell.bankImage.image = UIImage(data: favoriteItems.bankImage as Data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bankData = favorite[indexPath.row]
            favorite.remove(at:favorite.index(of: bankData)!)
            CoreDataStack.shared.context.delete(bankData)
        }
        CoreDataStack.shared.save()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.favorite.isEmpty{
                self.noDataLabelOn()
            }
            
        }
    }
}
