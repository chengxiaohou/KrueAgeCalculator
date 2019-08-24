



import UIKit
import CoreData

class FindYourAgeViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tfDateOfBirth: UITextField!
    
    @IBOutlet weak var lblAgeYear: UILabel!
    @IBOutlet weak var lblAgeMonths: UILabel!
    @IBOutlet weak var lblAgeDays: UILabel!
    
    @IBOutlet weak var lblNextBirthday: UILabel!
    
    @IBOutlet weak var lblExtraCalculationDays: UILabel!
    @IBOutlet weak var lblExtraCalculationMonths: UILabel!
    @IBOutlet weak var lblExtraCalculationYears: UILabel!
    @IBOutlet weak var lblExtraCalculationWeeks: UILabel!
    @IBOutlet weak var lblExtraCalculationHours: UILabel!
    @IBOutlet weak var lblExtraCalculationMinutes: UILabel!
    @IBOutlet weak var lblExtraCalculationSeconds: UILabel!
    
    //MARK:- variables
    let datePicker = UIDatePicker()
    var dateOfBirth:Date!
    
    //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isFromHistory")
         print("Load viewDidLoad")
        self.showDatePicker()

        EEDetailVC.test(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Load ViewWillAppear")
        let isFromHistory = UserDefaults.standard.object(forKey: "isFromHistory") as! Bool
        
        if isFromHistory {
            UserDefaults.standard.set(false, forKey: "isFromHistory")
            dateOfBirth = UserDefaults.standard.object(forKey: "bday") as? Date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            tfDateOfBirth.text = formatter.string(from: dateOfBirth)
            
            let todayDate = Date()
            let years = todayDate.years(from: dateOfBirth)
            let months = todayDate.months(from: dateOfBirth)
            let days = todayDate.days(from: dateOfBirth)
            let weeks = todayDate.weeks(from: dateOfBirth)
            let hours = todayDate.hours(from: dateOfBirth)
            let minutes = todayDate.minutes(from: dateOfBirth)
            let seconds = todayDate.seconds(from: dateOfBirth)
            
            self.lblAgeYear.text = "\(years)"
            
            var dateComponent1 = DateComponents()
            dateComponent1.setValue(years, for: .year)
            
            let calendar = Calendar(identifier: .gregorian)
            
            if let newDateOfBirthForMonthCal = calendar.date(byAdding: dateComponent1, to: dateOfBirth){
                self.lblAgeMonths.text = "\(todayDate.months(from: newDateOfBirthForMonthCal))"
            }else {
                self.lblAgeMonths.text = "-"
            }
            
            var dateComponent2 = DateComponents()
            dateComponent2.setValue(months, for: .month)
            
            if let newDateOfBirthForDaysCal = calendar.date(byAdding: dateComponent2, to: dateOfBirth){
                self.lblAgeDays.text = "\(todayDate.days(from: newDateOfBirthForDaysCal))"
            }else{
                self.lblAgeDays.text = "-"
            }
            
            var dateComponent3 = DateComponents()
            dateComponent3.setValue(years+1, for: .year)
            
            if let newDateOfBirthForNextBirthdayDays = calendar.date(byAdding: dateComponent3, to: dateOfBirth){
                
                let form = DateComponentsFormatter()
                form.maximumUnitCount = 2
                form.unitsStyle = .full
                form.allowedUnits = [.month, .day]
                if let duration = form.string(from: todayDate, to: newDateOfBirthForNextBirthdayDays) {
                    self.lblNextBirthday.text = duration
                }else{
                    self.lblNextBirthday.text = "-"
                }
            }else {
                self.lblNextBirthday.text = "-"
            }
            
            self.lblExtraCalculationDays.text = "\(days)"
            self.lblExtraCalculationMonths.text = "\(months)"
            self.lblExtraCalculationYears.text = "\(years)"
            self.lblExtraCalculationWeeks.text = "\(weeks)"
            self.lblExtraCalculationHours.text = "\(hours)"
            self.lblExtraCalculationMinutes.text = "\(minutes)"
            self.lblExtraCalculationSeconds.text = "\(seconds)"
        }
        
        
    }
    //MARK:- Date picker methods
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        tfDateOfBirth.inputAccessoryView = toolbar
        tfDateOfBirth.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        tfDateOfBirth.text = formatter.string(from: datePicker.date)
        dateOfBirth = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    //MARK:- IBAction
    @IBAction func onClearClick(_ sender: Any) {
        self.tfDateOfBirth.text = ""
        
        self.dateOfBirth = nil
        
        self.lblAgeYear.text = "00"
        self.lblAgeMonths.text = "00"
        self.lblAgeDays.text = "00"
        
        self.lblNextBirthday.text = "-"
        
        self.lblExtraCalculationDays.text = "00"
        self.lblExtraCalculationMonths.text = "00"
        self.lblExtraCalculationYears.text = "00"
        self.lblExtraCalculationWeeks.text = "00"
        self.lblExtraCalculationHours.text = "00"
        self.lblExtraCalculationMinutes.text = "00"
        self.lblExtraCalculationSeconds.text = "00"
    }
    
    @IBAction func onCalculateClick(_ sender: Any) {
        
        guard let dateOfBirth = self.dateOfBirth else{
            tfDateOfBirth.shake()
            return
        }
        
        let todayDate = Date()
        
        if dateOfBirth > todayDate {
            tfDateOfBirth.shake()
            return
        }
        
        //Save in History
        guard let context = appDel?.persistentContainer.viewContext else {
            return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Historys",in: context) else {
            return
        }
        
        let historys = Historys(entity: entity, insertInto: context)
        historys.bday = self.dateOfBirth!
        //-----Saved
        
        let years = todayDate.years(from: dateOfBirth)
        let months = todayDate.months(from: dateOfBirth)
        let days = todayDate.days(from: dateOfBirth)
        let weeks = todayDate.weeks(from: dateOfBirth)
        let hours = todayDate.hours(from: dateOfBirth)
        let minutes = todayDate.minutes(from: dateOfBirth)
        let seconds = todayDate.seconds(from: dateOfBirth)
        
        self.lblAgeYear.text = "\(years)"
        
        var dateComponent1 = DateComponents()
        dateComponent1.setValue(years, for: .year)
        
        let calendar = Calendar(identifier: .gregorian)
        
        if let newDateOfBirthForMonthCal = calendar.date(byAdding: dateComponent1, to: dateOfBirth){
            self.lblAgeMonths.text = "\(todayDate.months(from: newDateOfBirthForMonthCal))"
        }else {
            self.lblAgeMonths.text = "-"
        }
        
        var dateComponent2 = DateComponents()
        dateComponent2.setValue(months, for: .month)
        
        if let newDateOfBirthForDaysCal = calendar.date(byAdding: dateComponent2, to: dateOfBirth){
            self.lblAgeDays.text = "\(todayDate.days(from: newDateOfBirthForDaysCal))"
        }else{
            self.lblAgeDays.text = "-"
        }
        
        var dateComponent3 = DateComponents()
        dateComponent3.setValue(years+1, for: .year)
        
        if let newDateOfBirthForNextBirthdayDays = calendar.date(byAdding: dateComponent3, to: dateOfBirth){
            
            let form = DateComponentsFormatter()
            form.maximumUnitCount = 2
            form.unitsStyle = .full
            form.allowedUnits = [.month, .day]
            if let duration = form.string(from: todayDate, to: newDateOfBirthForNextBirthdayDays) {
                self.lblNextBirthday.text = duration
            }else{
                self.lblNextBirthday.text = "-"
            }
        }else {
            self.lblNextBirthday.text = "-"
        }
        
        self.lblExtraCalculationDays.text = "\(days)"
        self.lblExtraCalculationMonths.text = "\(months)"
        self.lblExtraCalculationYears.text = "\(years)"
        self.lblExtraCalculationWeeks.text = "\(weeks)"
        self.lblExtraCalculationHours.text = "\(hours)"
        self.lblExtraCalculationMinutes.text = "\(minutes)"
        self.lblExtraCalculationSeconds.text = "\(seconds)"
    }
}
