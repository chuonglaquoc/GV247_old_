//
//  WorkAround.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire

class WorkAroundController: BaseViewController {
    @IBOutlet weak var arWork: WorkAround!
    var cellHeight: CGFloat?
    var  user:User?
    var logtitude:Double?
    var lattitude:Double?
    var work = [WorkName]()
    @IBOutlet weak var aroundTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aroundTableView.register(UINib(nibName:"WorkTableViewCell",bundle: nil), forCellReuseIdentifier: "workCell")
        aroundTableView.addSubview(handleRefresh)
        arWork.setupView()
        setup()
        
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    override func setupViewBase() {
        if UserDefaultHelper.getSlider() != "" {
            if UserDefaultHelper.getSlider() == nil {
                return
            }
            arWork.sliderMax.text = "\(UserDefaultHelper.getSlider()!)"
            arWork.slider.setValue(Float(UserDefaultHelper.getSlider()!)!, animated: true)
        }
    }
    lazy var handleRefresh:UIRefreshControl = {
    let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(WorkAroundController.handleRef), for: .valueChanged)
        return refresh
    }()
    
    func handleRef() {
        loadData()
    }
    func setup(){
        
        arWork.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Công việc quanh đây"
        self.customBarLeftButton()
    }
    func customBarLeftButton(){
        let image = Ionicons.checkmark.image(12).maskWithColor(color: UIColor.colorWithRedValue(redValue: 24, greenValue: 179, blueValue: 110, alpha: 1))
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(WorkAroundController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    func selectButton() {
           navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    func loadData() {
        var param:[String:Any]?
        let headers: HTTPHeaders = [
            "hbbgvauth": "\(UserDefaultHelper.getToken()!)",
            "Accept": "application/json"
        ]
        //10.76721,106.6855493
        //10.7677238,106.6882557
        user = UserDefaultHelper.currentUser
        let apiClient = APIService.shared
        param = ["lat": 10.7677238,"lng": 106.6882557]
        handleRefresh.endRefreshing()
        apiClient.postURL(url: urlDisplayHome, method: .post, parameters: param!, encoding: JSONEncoding.default, header: headers) { (data,idString,value,owner,error) in
            if let error = error{
                print(error)
            }else{
                if let data = data{
                    self.work = data
                    self.aroundTableView.reloadData()
                }
                if owner != nil{
                    for i in owner!{
                        UserDefaultHelper.setUserOwner(user: i)
                    }
                }
            }
        }
    } 
}
extension WorkAroundController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return work.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: WorkTableViewCell = (aroundTableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as? WorkTableViewCell)!
            DispatchQueue.main.async {
            cell.lbWork.text = self.work[indexPath.row].name
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            navigationController?.pushViewController(HistoryViewController(), animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}
extension WorkAroundController:changeSliderDelegate{
    func change(slider: UISlider) {
        if slider.isContinuous == true {
            arWork.sliderMax.text = String(stringInterpolation: "\(slider.value)")
            UserDefaultHelper.setSlider(slider: "\(slider.value)")
        }
    }
}


