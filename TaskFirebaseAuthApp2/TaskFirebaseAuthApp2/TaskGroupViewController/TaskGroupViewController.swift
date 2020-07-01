//
//  TaskGroupViewController.swift
//  TaskFirebaseAuthApp2
//
//  Created by 福島悠樹 on 2020/06/23.
//  Copyright © 2020 福島悠樹. All rights reserved.
//

import UIKit

class TaskGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GroupInfoDelegate {

    @IBOutlet weak var taskGroupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskGroupTableView.delegate = self
        taskGroupTableView.dataSource = self
        GroupInfoManager.sharedInstance.delegate = self
        configureTableViewCell()
        
        // Do any additional setup after loading the view.
        //dataを読み込み
        GroupInfoManager.sharedInstance.loadGroupInfo()
        
        //タイトルを変更
        self.title = "Talk"
    }
    
    /* TableViewCellを読み込む(登録する)関数 */
    func configureTableViewCell(){
        /* nibを作成*/
        let nib = UINib(nibName: "TaskGroupTableViewCell", bundle: nil)
        
        
        /* ID */
        let cellID = "GroupTableViewCell"
        
        /* 登録 */
        taskGroupTableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    /* cellの個数 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupInfoManager.sharedInstance.getGroupInfoCount()
    }
    
    /* cellの高さ */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    /* cellに表示する内容 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath)as!TaskGroupTableViewCell
        
        cell.groupImageView.image = UIImage(named: "SpongeBob")
        cell.groupLabel.text = GroupInfoManager.sharedInstance.getGroupInfo(num: indexPath.row).groupName
        
        return cell
    }
    
    /* 再描画 */
    override func viewWillAppear(_ animated: Bool) {
        taskGroupTableView.reloadData()
    }
    
    /* スワイプ処理 */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        GroupInfoManager.sharedInstance.removeGroupInfo(num: indexPath.row)
        GroupInfoManager.sharedInstance.saveGroupInfo()
        taskGroupTableView.reloadData()
    }
    
    /* タップ時処理 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TaskGroupDetailViewController()
        vc.groupNumber = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        //let vc = TaskDetailViewController()
        //vc.selectIndex = indexPath.row
        //vc.tasks = tasks
        //navigationController?.pushViewController(vc, animated: true)
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
