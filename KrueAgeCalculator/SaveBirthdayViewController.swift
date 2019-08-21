




import UIKit

class SaveBirthdayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cellId = "birthdayCell"
    
    var birthdays = [Birthdays]()
    
    var emptyText = "loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onAddClick)), animated: true)
//        tableView.delegate = self
//        tableView.dataSource = self
         self.activityIndicator.color = #colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.8745098039, alpha: 1)
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getDataAndUpdateUI()
    }
    
    func getDataAndUpdateUI(){
        if let birthdayList = appDel.getBirthdayList() {
            self.emptyText = "No Birthday Found!!"
            self.birthdays = birthdayList
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }else{
            self.emptyText = "No Birthday Found!!"
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
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

extension SaveBirthdayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.isEmpty ? 1 : birthdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.birthdays.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "emotyCell")
            cell.textLabel?.text = emptyText
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = #colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.8745098039, alpha: 1)
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BirthdayTableViewCell
        cell.birthday = self.birthdays[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteBirthday(birthday: self.birthdays[indexPath.row], index: indexPath.row)
    }
    
    func deleteBirthday(birthday:Birthdays, index:Int){
        let optionMenu = self.getAlertController(title: nil, message: "Are you sure !")
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let context = appDel!.persistentContainer.viewContext
            
            context.delete(birthday)
            
            do {
                try context.save()
                self.birthdays.remove(at: index)
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

class BirthdayTableViewCell:UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    
    @IBOutlet weak var imgPartyHat:UIImageView!
    
    override func awakeFromNib() {
        imgPartyHat.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
    }
    
    var birthday:Birthdays! {
        didSet {
            self.lblName.text = birthday.name
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            self.lblBirthday.text = formatter.string(from: birthday.dob!)
        }
    }
    
}
