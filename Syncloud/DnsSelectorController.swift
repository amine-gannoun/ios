import Foundation
import UIKit

class DnsSelectorController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerDns: UIPickerView!
    
    init() {
        super.init(nibName: "DnsSelector", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pickerDomainComponent = 0
    
    var domainsValues: [String] = [String]()
    var domainsTitles: [String] = [String]()
    
    var mainDomain: String = Storage.getMainDomain()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DNS"

        let viewController = self.navigationController!.visibleViewController!
        let btnSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("btnSaveClick:"))
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("btnCancelClick:"))
        viewController.navigationItem.rightBarButtonItem = btnSave
        viewController.navigationItem.leftBarButtonItem = btnCancel
        
        self.domainsValues = ["syncloud.it", "syncloud.info"]
        self.domainsTitles = ["Production: syncloud.it", "Testing: syncloud.info"]

        self.mainDomain = Storage.getMainDomain()

        self.pickerDns.selectRow(domainsValues.indexOf(self.mainDomain)!, inComponent: self.pickerDomainComponent, animated: false)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    func btnSaveClick(sender: UIBarButtonItem) {
        let newMainDomain = self.domainsValues[self.pickerDns.selectedRowInComponent(self.pickerDomainComponent)]
        if newMainDomain != self.mainDomain {
            if Storage.hasCredentials() {
                let alert = UIAlertController(title: "Change DNS", message: "You will need to login again after changing Domain Name Service", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                    action in
                    Storage.setMainDomain(newMainDomain)
                    (self.navigationController as! MainController).startOver()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                Storage.setMainDomain(newMainDomain)
                self.navigationController!.popViewControllerAnimated(true)
            }
        } else {
            self.navigationController!.popViewControllerAnimated(true)
        }
    }

    func btnCancelClick(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.domainsValues.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.domainsTitles[row]
    }
}