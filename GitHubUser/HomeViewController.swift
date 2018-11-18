//
//  HomeViewController.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TFSearchName: UITextField!
    var modelUserDetails:NSMutableArray = []
    var userDetails:NSMutableArray = []
    var expandedCells = [Int]()
    var userRepositiories : NSArray = []
    @IBOutlet weak var searchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(self.getUserRepositiories(notification:)), name: Notification.Name(rawValue: "userRepositories"), object: nil)
        nc.addObserver(self, selector: #selector(self.getUserList(notification:)), name: Notification.Name(rawValue: "userList"), object: nil)
        //register NIB
        
        self.navigationController!.navigationBar.topItem!.title = "Username"
        tableView.register(UINib(nibName: "userDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "userDetailCell")
        //self.createHardCodedDictionary()
        WebService.shareInstance.getUserList()
        userDetails = modelUserDetails.mutableCopy() as! NSMutableArray
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func createHardCodedDictionary(){
        modelUserDetails = [["Name":"xyz","Location":"Pune","Created At":"1/1/2018","Bio":"abcddjfghskjg adjfsj sjdgjskvb"],["Name":"def","Location":"Mumbai","Created At":"1/2/2018","Bio":"abcddjfghskjg adjfsj sjdgjskvb"],["Name":"ghi","Location":"Surat","Created At":"1/3/2018","Bio":"abcddjfghskjg adjfsj sjdgjskvb"],["Name":"jkl","Location":"Ahmedabad","Created At":"1/4/2018","Bio":"abcddjfghskjg adjfsj sjdgjskvb"],["Name":"mno","Location":"Junagadh","Created At":"1/5/2018","Bio":"abcddjfghskjg adjfsj sjdgjskvb"]]
       // let sortedArray = modelUserDetails.sort { $0["Name"] as! String < $1["Name"] as! String }
       
        print(modelUserDetails)
    }
    
    // MARK: - TableView Delegate And Data Source Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedCells.contains(indexPath.row) {
            return 145
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : userDetailTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "userDetailCell") as! userDetailTableViewCell
        let details = userDetails.object(at: indexPath.row) as! NSDictionary
        cell.tag = indexPath.row
        cell.BtnExpandCellOutlet.tag = indexPath.row
        cell = self.setUpUserDataInCell(cell, for: details, at: indexPath)
        
        cell.userImageVIew.af_setImage(withURL: URL(string: details.value(forKey: "avatar_url") as! String)!, placeholderImage: UIImage(named: "user_icon"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let userRepositoriesController = self.storyboard?.instantiateViewController(withIdentifier: "UserRepositoriesController") as! UserRepositoriesViewController
//            self.navigationController?.pushViewController(userRepositoriesController, animated: true)
        WebService.shareInstance.getUsersRepositories((userDetails.object(at: indexPath.row)as! NSDictionary).value(forKey: "login") as! String)
    }
    
    // MARK: - TextField Delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.search(byString: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.search(byString: textField.text ?? "")
        return true
    }
    
    //MARK:- Setup Cell Methods
    
    func setUpUserDataInCell(_ cell: userDetailTableViewCell,for user: NSDictionary, at indexPath: IndexPath) -> userDetailTableViewCell{
        cell.LBLUserName.text = (user.value(forKey: "login") as! String)
        cell.LBLUserUrl.text = (user.value(forKey: "url") as! String)
        // cell.userImageVIew.image = WebService.shareInstance.makeApiCallToDownloadImage(details.value(forKey: "avatar_url") as! String)
        if(expandedCells.contains(indexPath.row)){
            cell.LBLUserSubscriptions.isHidden = false
            cell.LBLUserSubscriptionsValue.isHidden = false
            cell.LBLUserorganization.isHidden = false
            cell.LBLUserorganizationValue.isHidden = false
            cell.LBLUserSubscriptionsValue.text = (user.value(forKey: "subscriptions_url") as! String)
            cell.LBLUserorganizationValue.text = (user.value(forKey: "organizations_url") as! String)
            cell.BtnExpandCellOutlet.setImage(UIImage(named: "collapse_arrow"), for: .normal)
        }else{
            cell.LBLUserSubscriptions.isHidden = true
            cell.LBLUserSubscriptionsValue.isHidden = true
            cell.LBLUserorganization.isHidden = true
            cell.LBLUserorganizationValue.isHidden = true
            cell.BtnExpandCellOutlet.setImage(UIImage(named: "expand_arrow"), for: .normal)
        }
        cell.BtnExpandCellOutlet.addTarget(self, action: #selector(self.btnExpandClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: - Button Action
    @objc func btnExpandClicked(_ sender: UIButton){
        if expandedCells.contains(sender.tag) {
            expandedCells = expandedCells.filter({ $0 != sender.tag})
        }
        else {
            expandedCells.append(sender.tag)
        }
        tableView.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .automatic)
        
    }
    
    @IBAction func btnCancelSearchClicked(_ sender: Any) {
        self.expandedCells.removeAll()
        self.TFSearchName.text = ""
        self.searchView.isHidden = true
        userDetails = modelUserDetails.mutableCopy() as! NSMutableArray
        tableView.reloadData()
    }
    
    @IBAction func BtnSearchClicked(_ sender: Any) {
        self.searchView.isHidden = false
    }
    
    // MARK: - Helper Methods
    func search(byString filterString : String) {
        userDetails.removeAllObjects()
        print(modelUserDetails)
        for dict in modelUserDetails{
            if (dict as! NSDictionary).value(forKey: "Name") as! String == filterString {
              userDetails.add(dict as! NSDictionary)
            }
        }
        if(userDetails.count > 0){
            self.expandedCells.removeAll()
            tableView.reloadData()
        }else{
            self.expandedCells.removeAll()
            tableView.reloadData()
            let alertController = UIAlertController(title: "Error", message: "No User Found With \(filterString)", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - API CallBack Methods
    @objc func getUserRepositiories(notification: Notification){
        if(notification.object != nil){
            let userRepositoriesController = self.storyboard?.instantiateViewController(withIdentifier: "UserRepositoriesController") as! UserRepositoriesViewController
            userRepositoriesController.userRepositiories = notification.object as! NSArray
            self.navigationController?.pushViewController(userRepositoriesController, animated: true)
        }else{
            let alertController = UIAlertController(title: "Error", message: "User has No Repositiories", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func getUserList(notification: Notification){
        if(notification.object != nil){
            userDetails = (notification.object as! NSArray).mutableCopy() as! NSMutableArray
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "login", ascending: true)
            modelUserDetails = (modelUserDetails.sortedArray(using: [descriptor]) as NSArray).mutableCopy() as! NSMutableArray
            tableView.reloadData()
        }else{
            let alertController = UIAlertController(title: "Error", message: "No User list Found", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
