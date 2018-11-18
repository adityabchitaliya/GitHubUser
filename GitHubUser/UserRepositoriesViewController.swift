//
//  UserRepositoriesViewController.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import UIKit

class UserRepositoriesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userRepositiories: NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserRepositioresTableViewCell", bundle: nil), forCellReuseIdentifier: "UserRepositioresCell")
        self.navigationController!.navigationBar.topItem!.title = "Username"
        let logoutButton = UIButton.init(type: .custom)
        logoutButton.addTarget(self, action: #selector(self.btnLogoutClicked(_:)), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "logout.png"), for: .normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barBtn = UIBarButtonItem(customView:logoutButton)
        self.navigationItem.setRightBarButton(barBtn, animated: true)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TableView Delegate And Data Source Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepositiories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserRepositioresTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "UserRepositioresCell") as! UserRepositioresTableViewCell
        cell.LBLRepoName.text = (userRepositiories.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        cell.LBLRepoDescription.text = (userRepositiories.object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as? String ?? "No Description"
        return cell
    }
    
    // MARK: - Button Click Action
    @objc func btnLogoutClicked(_ sender: UIButton){
        UserDefaults.standard.set(false, forKey: "isRememberMeEnabled")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginVC
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
