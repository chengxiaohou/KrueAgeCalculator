//
//  SideMenuTableViewController.swift
//  KrueAgeCalculator
//
//  Created by Vipin Saini on 11/08/19.
//  Copyright © 2019 AlienBrainz Softwares Pvt. Ltd. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
//        guard let menu = navigationController as? UISideMenuNavigationController, menu.blurEffectStyle == nil else {
//            return
//        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        
//        if let menu = navigationController as? UISideMenuNavigationController {
//            cell.blurEffectStyle = menu.blurEffectStyle
//        }
        
        return cell
    }
    
}
