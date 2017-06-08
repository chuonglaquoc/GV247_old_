//
//  FinishedWorkViewController.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class FinishedWorkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var work:Work?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "FinishedWorkCell", bundle: nil), forCellReuseIdentifier: "FinishedWorkCell")
        tableView.register(UINib(nibName: "WorkerViewCell", bundle: nil), forCellReuseIdentifier: "WorkerCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Công việc hoàn thành"
    }
    
    fileprivate func convertISODateToString(isoDateStr: String, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        let newDate = dateFormatter.date(from: isoDateStr)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: newDate!)
    }
    
    fileprivate func convertISODateToDate(isoDateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        let newDate = dateFormatter.date(from: isoDateStr)
        return newDate
    }
    
    fileprivate func convertDateToString(date: Date, withFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        dateFormatter.timeZone = TimeZone.current
        let newDateStr = dateFormatter.string(from: date)
        return newDateStr
    }

}

extension FinishedWorkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedWorkCell", for: indexPath) as! FinishedWorkCell
            
            
            if let imageString = work?.info?.workName?.image {
                let url = URL(string: imageString)
                cell.workerImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.workNameLabel.text = work?.info?.title
            cell.workTypeLabel.text = work?.info?.workName?.name
            cell.contentLabel.text = work?.contentDescription
            cell.salaryNumber.text = String(describing: (work?.price)!) + " VND"

            let startAt = work?.workTime?["startAt"]
            let endAt = work?.workTime!["endAt"]
            let startAtString = String(describing: startAt!)
            let endAtString = String(describing: endAt!)
            
            cell.createAtLabel.text = convertISODateToString(isoDateStr: startAtString, format: "dd/MM/yyyy")
            cell.addressLabel.text = work?.address?.name

            cell.workTimeLabel.text = convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkerViewCell
        
            if let imageString = work?.ownerInfo?.image {
                let url = URL(string: imageString)
                cell.ownerImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.ownerName.text = work?.ownerInfo?.username
            cell.ownerAddress.text = work?.ownerInfo?.address?.name
            
            
            return cell
        }
    }
}

extension FinishedWorkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "NGƯỜI THỰC HIỆN"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: "SF UI Text Light", size: 16)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
