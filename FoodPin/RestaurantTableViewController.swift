//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by STANLEY TSENG on 2019/10/10.
//  Copyright © 2019 StanleyAppWorld. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats And Deli", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkeerestaurant", "posatelier", "bourkestreetbakery", "haighschocolate", "palominoespresso", "upstate", "traif", "grahamavenuemeats", "wafflewolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "caskpubkitchen"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    var restaurantIsVisited = Array(repeating: false, count: 21)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        // as! RestaurantTableViewCell 在Swift中，我們使用as!關鍵字來執行強迫轉型
        
        // Configure the cell 設定cell...
        
        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
        cell.locationLabel.text = restaurantLocations[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]
        
//        if restaurantIsVisited[indexPath.row] {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        // 也可以使用三元運算子（？：）來進一步簡化上述的if條件為一行程式碼：
        // cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark " .none
        
        // Solution to Exercise #2
        cell.heartImageView.isHidden = restaurantIsVisited[indexPath.row] ? false : true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create an option menu as an action sheet 建立一個選單作為動作清單
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
                if let popoverController = optionMenu.popoverPresentationController {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        popoverController.sourceView = cell
                        popoverController.sourceRect = cell.bounds
                    }
                }
        
        // Add action to menu 加入動作至選單中
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Add call action 加入打電話動作
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        
        // solution to exercise #1
        let checkActionTitle = (restaurantIsVisited[indexPath.row]) ? "Undo Check in" : "Check in"
        
        // Check-in action 打卡動作
        let checkInAction = UIAlertAction(title: checkActionTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            self.restaurantIsVisited[indexPath.row] = (self.restaurantIsVisited[indexPath.row]) ? false : true
            
            // Solution to exercise #1
            // cell.accessoryType = (self.restaurantIsVisited[indexPath.row]) ? .none : .checkmark
            
            // Solution to exercise #2
            cell.heartImageView.isHidden = self.restaurantIsVisited[indexPath.row] ? false : true
        })
        
        optionMenu.addAction(checkInAction)
        
        // Display the menu 呈現選單
        present(optionMenu, animated: true, completion: nil)
        
        // Deselect the row 取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    
        }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // 從資料來源刪除列
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantLocations.remove(at: indexPath.row )
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)
            self.restaurantImages.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 呼叫完成處理器來取消動作按鈕
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            
            let defaultText = "Just checking in at " + self.restaurantNames[indexPath.row]
            
            let activityController: UIActivityViewController
            
            if let imageToShare = UIImage(named:self.restaurantImages[indexPath.row]) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    // 向右滑動 加入打卡動作
    // 向右滑動Cell之後，會有一個心形圖示，打勾圖示會被返回圖示所取代
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
    let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
            
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        self.restaurantIsVisited[indexPath.row] = (self.restaurantIsVisited[indexPath.row]) ? false : true
        cell.heartImageView.isHidden = self.restaurantIsVisited[indexPath.row] ? false : true
        
        completionHandler(true)
        
        }
        
        let checkInIcon = restaurantIsVisited[indexPath.row] ? "undo" : "tick"
        checkInAction.backgroundColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        checkInAction.image = UIImage(named: checkInIcon)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeConfiguration
    }

    /* 原本刪除一列的舊方法
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 從資料源刪除列
            restaurantNames.remove(at: indexPath.row)
            restaurantLocations.remove(at: indexPath.row)
            restaurantTypes.remove(at: indexPath.row)
            restaurantIsVisited.remove(at: indexPath.row)
            restaurantImages.remove(at: indexPath.row)
        }
        
        // tableView.reloadData() 原本刪除一列的方式，下面方式更好
        tableView.deleteRows(at: [indexPath], with: .left)
        
        print("Total item: \(restaurantNames.count)")
            for name in restaurantNames {
            print(name)
        }
     }
   */
// 隱藏狀態列
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
