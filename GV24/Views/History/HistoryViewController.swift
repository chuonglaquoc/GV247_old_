//
//  HistoryViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HistoryViewController: BaseViewController {
    
    var user:User?
    var workList: [Work] = []
    var isFromDateButton = false
    var fromDate: Date?
    var toDate: Date?
    
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var fromDateContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.automaticallyAdjustsScrollViewInsets = false
        customControl()
        print("token = \(UserDefaultHelper.getToken())")
    }
    
    override func decorate() {
        getDoneWorkInHistory()
        
    }
    
    override func setupViewBase() {
        
    }
    
    func getDoneWorkInHistory() {
        workList.removeAll()
        user = UserDefaultHelper.currentUser
        let params = ["process_ID":000000000000000000000005]
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkHistoryWith(url: urlGetAllTasksHistory, param: params, header: headers) { (data, err) in
            if err == nil {
                if let list = data?["data"] {
                    for item in list {
                        print("item : \(item)")
                        if let values = item.1 as? JSON {
                            if let _id = values["process"]["_id"].string {
                                if _id == "000000000000000000000005" {
                                    let work = Work(json: item.1)
                                    let history = work.history
                                    let info = work.info
                                    self.workList.append(work)
                                }
                            }
                        }
                    }
                    self.historyTableView.reloadData()
                }
            }
            else {
                print("Can not get the work done list from History")
            }
        }
    }
    
    func getDoneWorkInHistoryFrom(date: String, toDate: String) {
        workList.removeAll()
        user = UserDefaultHelper.currentUser
        var params:[String : Any] = ["page":1,"endAt":toDate]
        if date != "" {
            params["startAt"] = date
        }
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkHistoryWith(url: urlGetHistoryTasks, param: params, header: headers) { (data, err) in
            if err == nil {
                print("data: \(data)")
                if let list = data?["data"] {
                    for item in list {
                        //print("item : \(item)")
                        if let values = item.1 as? JSON {
                            if let _id = values["process"]["_id"].string {
                                if _id == "000000000000000000000005" {
                                    let work = Work(json: item.1)
                                    let history = work.history
                                    let info = work.info
                                    self.workList.append(work)
                                }
                            }
                        }
                    }
                    self.historyTableView.reloadData()
                }
            }
            else {
                print("Can not get the work done list from History")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Lịch sự công việc"
        segmentControl.selectedSegmentIndex = 0
    }
    
//    var currentViewController: UIViewController?
    
    @IBAction func segmentValueChanged(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            print("Do nothing.")
            break;
        case 1:
            let vc = OwnerHistoryViewController()
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            print("")
        }
    }
    
    fileprivate func customControl() {
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: fromDateContainer.frame.size.width, height: 1.0))
        topBorder.backgroundColor = UIColor.lightGray
        topBorder.alpha = 0.3
        let bottomBorder = UIView(frame: CGRect(x: 0, y: segmentContainer.frame.size.height - 1, width: segmentContainer.frame.size.width, height: 1.0))
        bottomBorder.backgroundColor = UIColor.lightGray
        bottomBorder.alpha = 0.3
        fromDateContainer.addSubview(topBorder)
        fromDateContainer.addSubview(bottomBorder)
        
        toDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        toDateButton.setTitle(dateFormatter.string(from: toDate!), for: UIControlState.normal)
        
    }
    
    @IBAction func doActionSelectFromDate(_ sender: UIButton) {
        showPopupView(isFromDate: true)
    }
    
    @IBAction func doActionSelectEndDate(_ sender: Any) {
        showPopupView(isFromDate: false)
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
extension HistoryViewController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryViewCell
        
        let work = workList[indexPath.item]
        cell.workNameLabel.text = work.info?.title
        if let imageString = work.info?.workName?.image {
            let url = URL(string: imageString)
            cell.imageWork.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
       

        var date = work.workTime?["startAt"]
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = 
        
        let startAt:String = String(describing: date!)
        var newDate = dateFormatter.date(from: startAt)
        //dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        var startAtStr: String = dateFormatter.string(from: newDate!)
        print("Start At: \(startAtStr)")
        
        cell.startAt.text = startAtStr
        
        dateFormatter.dateFormat = "HH:mm a"
        let fromHourStr = dateFormatter.string(from: newDate!)
        
        date = work.workTime?["endAt"]
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let endAt: String = String(describing: date!)
        newDate = dateFormatter.date(from: endAt)
        //dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        var endAtStr: String = dateFormatter.string(from: newDate!)
        print("End At: \(endAtStr)")
        
        dateFormatter.dateFormat = "HH:mm a"
        let toHourStr = dateFormatter.string(from: newDate!)
        cell.timeWork.text = "\(fromHourStr) - \(toHourStr)"
        
        let now = Date()
        let executionTime = now.timeIntervalSince(newDate!)
        
        let secondsInHour: Double = 3600
        let hoursBetweenDates = Int(executionTime/secondsInHour)
        let daysBetweenDates = Int(executionTime/86400)
        let minutesBetweenDates = Int(executionTime/60)
        //print("seconds execution time: \(executionTime)")
        //print("hours : \(hoursBetweenDates)")
        //print("minutes: \(minutesBetweenDates)")
        //print("days: \(daysBetweenDates)")
        
        if minutesBetweenDates > 60 {
            cell.estimateTimeFinished.text = "\(daysBetweenDates) ngày \(Int(hoursBetweenDates/24)) tiếng"
        }
        else {
            cell.estimateTimeFinished.text = "\(minutesBetweenDates) phút trước"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = workList[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension HistoryViewController: PopupViewControllerDelegate {
    func selectedDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        if isFromDateButton == true {
            fromDate = date
            if fromDate! <= toDate! {
                fromDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                getDoneWorkInHistoryFrom(date: dateFormatter.string(from: fromDate!), toDate: dateFormatter.string(from: toDate!))
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
                    getDoneWorkInHistoryFrom(date: dateFormatter.string(from: fromDate!), toDate: dateFormatter.string(from: toDate!))
                }
            }
            else {
                toDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                getDoneWorkInHistoryFrom(date: "", toDate: dateFormatter.string(from: toDate!))
            }
        }
        
    }
}
