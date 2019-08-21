



import UIKit
import CoreData

class AddBirthdayViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    
    let datePicker = UIDatePicker()
    var dateOfBirth:Date!
    
    var callback:(()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfName.delegate = self
        self.showDatePicker()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onAddClick(_ sender: Any) {
        if validate() {
            guard let context = appDel?.persistentContainer.viewContext else {
                return
            }
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Birthdays",in: context) else {
                return
            }
            
            let birthday = Birthdays(entity: entity, insertInto: context)
            
            birthday.name = tfName.text!
            birthday.dob = self.dateOfBirth!
         
            
            do {
                try context.save()
                self.tfName.text = ""
                self.tfDOB.text = ""
                self.dateOfBirth = nil
                self.dismiss(animated: true) {
                    self.callback()
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
        
        tfDOB.inputAccessoryView = toolbar
        tfDOB.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        tfDOB.text = formatter.string(from: datePicker.date)
        dateOfBirth = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func validate() -> Bool {
        if self.tfName.text == "" {
            self.tfName.shake()
            return false
        }
        if self.tfDOB.text == "" || dateOfBirth == nil{
            self.tfDOB.shake()
            return false
        }
        return true
    }
    
    @IBAction func onClockClick(_ sender: Any) {
        self.callback()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
