//
//  HistoryViewController.swift
//  KrueAgeCalculator
//
//  Created by Vipin Saini on 12/08/19.
//  Copyright © 2019 AlienBrainz Softwares Pvt. Ltd. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "historysCell"
    
    var historys = [Historys]()
    
    var emptyText = "loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onAddClick)), animated: true)
        //        tableView.delegate = self
        //        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getDataAndUpdateUI()
    }
    
    func getDataAndUpdateUI(){
        if let historysList = appDel.getHistorysList(){
            self.emptyText = "No History Found!!"
            self.historys = historysList
            self.tableView.reloadData()
        }else{
            self.emptyText = "No History Found!!"
            self.tableView.reloadData()
        }
    }
    
    @objc func onAddClick() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBirthdayViewController") as! AddBirthdayViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback = {
            self.getDataAndUpdateUI()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historys.isEmpty ? 1 : historys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.historys.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "emotyCell")
            cell.textLabel?.text = emptyText
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = #colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.8745098039, alpha: 1)
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryTableViewCell
        cell.history = self.historys[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FindYourAgeViewController") as! FindYourAgeViewController
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
        let historysBady:Historys = self.historys[indexPath.row]
        
        UserDefaults.standard.set(historysBady.bday, forKey:"bday")
        UserDefaults.standard.set(true, forKey: "isFromHistory")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteHistory(history: self.historys[indexPath.row], index: indexPath.row)
    }
    
    func deleteHistory(history:Historys, index:Int){
        let optionMenu = self.getAlertController(title: nil, message: "Are you sure !")
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let context = appDel!.persistentContainer.viewContext
            
            context.delete(history)
            
            do {
                try context.save()
                self.historys.remove(at: index)
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

class HistoryTableViewCell:UITableViewCell {
    
//    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    
//    @IBOutlet weak var imgPartyHat:UIImageView!
    
//    override func awakeFromNib() {
//        imgPartyHat.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
//    }
    
    var history:Historys! {
        didSet {
          
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            self.lblBirthday.text = formatter.string(from: history.bday!)
        }
    }
    
}

