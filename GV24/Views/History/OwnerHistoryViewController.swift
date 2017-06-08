//
//  OwnerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class OwnerHistoryViewController: BaseViewController {
    
    var workList:[Work] = []
    var user: User?
    var isFromDateButton = false
    var fromDate: Date?
    var toDate: Date?
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.register(UINib(nibName:"OwnerHistoryViewCell",bundle:nil), forCellReuseIdentifier: "OwnerHistoryCell")
    }

    @IBAction func doActionFromDateButton(_ sender: Any) {
        showPopupView(isFromDate: true)
    }
    @IBAction func doActionToDateButton(_ sender: Any) {
        showPopupView(isFromDate: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Chủ nhà đã làm"
        segment.selectedSegmentIndex = 1
    }
    
    override func setupViewBase() {
        super.setupViewBase()
    }
    
    override func decorate() {
        getWorkerOwnerHistory(fromDate: "", toDate: "")
    }
    
    func getWorkerOwnerHistory(fromDate:String, toDate:String) {
        workList.removeAll()
        user = UserDefaultHelper.currentUser
//        let params = ["process_ID":000000000000000000000005]
        var params:[String:Any] = [:]
        if fromDate != "" {
            params["startAt"] = fromDate
        }
        if toDate != "" {
            params["endAt"] = toDate
        }
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkHistoryWith(url: urlGetAllWorkedOwnerHistory, param: [:], header: headers) { (data, err) in
            if err == nil {
                print("Data: \(data)")
                self.historyTableView.reloadData()
                if let list = data?["data"] {
                    for item in list {
                        print("item : \(item)")
                        if let values = item.1 as? JSON {
                            if let _id = values["process"]["_id"].string {
                                if _id == "000000000000000000000005" {
                                    
                                }
                            }
                        }
                    }
                    self.historyTableView.reloadData()
                }
            }
            else {
                print("Can not get the worker owner done list from History")
            }
        }
    }
    
    func customControl() {
        toDate = Date()
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func showPopupView(isFromDate: Bool) {
        isFromDateButton = isFromDate
        let popup = PopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = self
        present(popup, animated: true, completion: nil)
    }
    
    fileprivate func showAlert(message: String) {
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
            self.showPopupView(isFromDate: true)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension OwnerHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return workList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerHistoryCell", for: indexPath) as! OwnerHistoryViewCell
        
        return cell
    }
}

extension OwnerHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.colorWithRedValue(redValue: 237, greenValue: 236, blueValue: 243, alpha: 1)
        return footerView
    }
}

extension OwnerHistoryViewController: PopupViewControllerDelegate {
    func selectedDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        if isFromDateButton == true {
            fromDate = date
            if fromDate! <= toDate! {
                fromDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                getDoneWorkInHistoryFrom(date: dateFormatter.string(from: fromDate!), toDate: dateFormatter.string(from: toDate!))
            }
            else {
                self.showAlert(message: "Begin date must be less than end date.")
            }
        }
        else {
            toDate = date
            if fromDate != nil {
                if toDate! <= fromDate! {
                    self.showAlert(message: "End date must be larger than begin date.")
                }
                else {
                    toDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                    getDoneWorkInHistoryFrom(date: dateFormatter.string(from: fromDate!), toDate: dateFormatter.string(from: toDate!))
                }
            }
            else {
                toDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                getDoneWorkInHistoryFrom(date: "", toDate: dateFormatter.string(from: toDate!))
            }
        }
        
    }
}
