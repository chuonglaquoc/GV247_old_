//
//  PopupViewController.swift
//  GV24
//
//  Created by admin on 6/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

protocol PopupViewControllerDelegate {
    func selectedDate(date: Date)
}

class PopupViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: PopupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.date = Date()
        datePicker.timeZone = TimeZone.current
    }

    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
    }

    @IBAction func doActionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doActionSelectDate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.selectedDate(date: datePicker.date)
        
    }
    
}
