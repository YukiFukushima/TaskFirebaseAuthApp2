//
//  TaskGroupDetailViewController.swift
//  TaskFirebaseAuthApp2
//
//  Created by 福島悠樹 on 2020/06/26.
//  Copyright © 2020 福島悠樹. All rights reserved.
//

import UIKit

class TaskGroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GroupInfoDelegate, UITextViewDelegate {
    
    @IBOutlet weak var taskGroupDetailTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextView!
    
    var groupNumber:Int = 0                         // 選択したグループ番号
    let notification = NotificationCenter.default   // KeyboardAction取得用変数(後々の勉強の為)
    var isActiveKeyboard:Bool = false               // keyboard表示状態管理変数(後々の勉強の為)
    var keyboardHeight:CGFloat = 0                  // ketboardの高さ(後々の勉強の為)
    var cellSum:CGFloat = 0                         // cellの高さの合計(後々の勉強の為)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskGroupDetailTableView.delegate = self
        taskGroupDetailTableView.dataSource = self
        GroupInfoManager.sharedInstance.delegate = self
        inputTextField.delegate = self
        configureTableViewCell()
        
        // Do any additional setup after loading the view.
        //dataを読み込み
        GroupInfoManager.sharedInstance.loadGroupInfo()
        
        //タイトル設定
        self.title = GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupName
        
        //背景画像設定
        cofigureBackgroundImage()
        
        //キーボード表示時アクション関数登録(後々の勉強の為)
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        //キーボード消灯時アクション関数登録(後々の勉強の為)
        notification.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //インプットのテキストビューを可変にする("Scrolling Enable"のチェックを外すこと!)
        inputTextField.autoresizingMask = .flexibleHeight
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // キーボードが登場する通知を受けた時に実行されるメソッド
    @objc func keyboardWillShow(_ notification: Notification) {
        /* 後々の勉強のために残しておく
        print("keyboardWillShow")
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeightValue = keyboardRectangle.height
        let cellSumHeight = taskGroupDetailTableView.contentSize.height
        let viewHeight = self.view.frame.size.height
        
        keyboardHeight = keyboardHeightValue
        isActiveKeyboard = true
        
        if cellSumHeight+keyboardHeight<viewHeight{
            self.taskGroupDetailTableView.contentOffset.y = -keyboardHeight
        }
        //dispTableViewFromBottom()
        */
    }
    
    // キーボードが退場した通知を受けた時に実行されるメソッド
    @objc func keyboardDidHide(_ notification: Notification) {
        /* 後々の勉強のために残しておく
        print("keyboardDidHide")
        
        keyboardHeight = 0
        isActiveKeyboard = false
        
        self.taskGroupDetailTableView.contentOffset.y = 0
        //dispTableViewFromBottom()
        */
    }
    
    /* 背景画像設定 */
    func cofigureBackgroundImage(){
        let image = UIImage(named: "SunnySky")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.taskGroupDetailTableView.frame.width, height: self.taskGroupDetailTableView.frame.height))
        
        imageView.image = image
        taskGroupDetailTableView.backgroundView = imageView
    }
    
    /* TableViewCellを読み込む(登録する)関数 */
    func configureTableViewCell(){
        /* nibを作成*/
        let nib = UINib(nibName: "TaskGroupDetailTableViewCell", bundle: nil)
        
        
        /* ID */
        let cellID = "GroupDetailTableViewCell"
        
        /* 登録 */
        taskGroupDetailTableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    /* cellの個数 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks.count
    }
    
    /* cellに表示する内容 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailTableViewCell", for: indexPath)as!TaskGroupDetailTableViewCell
        
        /* 最初が空配列の場合、keyboard調整なので何も表示しないようにする */
        if GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks[indexPath.row]==""{
            cell.groupDetailTextView.text = ""
            cell.groupDetailTextView.backgroundColor = .clear
            cell.GroupDetailImageView.image = nil
        }else{
            cell.groupDetailTextView.textColor = .black
            cell.groupDetailTextView.backgroundColor = .white
            cell.groupDetailTextView.text = GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks[indexPath.row]
            cell.groupDetailTextView.font = .monospacedSystemFont(ofSize: 16, weight: .thin)
            cell.GroupDetailImageView.image = UIImage(named: "SpongeBob")
        }
        
        return cell
    }
    
    /* cellの高さ */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        taskGroupDetailTableView.estimatedRowHeight = 20    //最低限のセルの高さ設定
        return UITableView.automaticDimension               //セルの高さを可変にする
    }
    
    /* テーブルビューを一番後ろから表示させる関数 */
    func dispTableViewFromBottom(){
        let count:Int = GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks.count
        
        if count==0{    //何も入っていなければ(最初の会話の時)
            return
        }else{          //何か入っていたら(会話が開始していれば)
            taskGroupDetailTableView.scrollToRow(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
        }
        
        /* 後々の勉強のために残しておく
        let count:Int = GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks.count
        let cellSumHeight = taskGroupDetailTableView.contentSize.height
        let viewHeight = self.view.frame.size.height
        
        print("セルの高さ：")
        print(cellSumHeight)
        print("viewの高さ：")
        print(viewHeight)
        print("Keyboardの高さ：")
        print(keyboardHeight)
        
        if count==0{
            return
        }else{
            if isActiveKeyboard==true{
                if cellSumHeight+keyboardHeight>viewHeight{
                    self.taskGroupDetailTableView.contentOffset.y = 0
                    taskGroupDetailTableView.scrollToRow(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
                }/*else if cellSumHeight<=keyboardHeight
                    &&       count==1{
                    self.taskGroupDetailTableView.contentOffset.y = -keyboardHeight
                }*/
                else{
                    self.taskGroupDetailTableView.contentOffset.y = -keyboardHeight
                }
            }else{
                taskGroupDetailTableView.scrollToRow(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
            }
        }
        */
    }
    
    /* テーブルview表示後にコールされる関数 */
    override func viewDidAppear(_ animated: Bool) {
        dispTableViewFromBottom()
    }
    
    /* メッセージ送信ボタン */
    @IBAction func commitBtn(_ sender: Any) {
        guard let message=inputTextField.text else{ return }
        
        /* 最初に空配列を入れてKeyboardが押し上げた時に隠れないようにする */
        if GroupInfoManager.sharedInstance.getGroupInfo(num: groupNumber).groupMemberTalks.count==0{
            for _ in 0 ..< 5 {
                GroupInfoManager.sharedInstance.appendGroupInfoTalks(num: groupNumber, message: "")
            }
        }
        GroupInfoManager.sharedInstance.appendGroupInfoTalks(num: groupNumber, message: message)    //追加
        GroupInfoManager.sharedInstance.saveGroupInfo()                                             //保存
        taskGroupDetailTableView.reloadData()                                                       //再描画
        dispTableViewFromBottom()                                                                   // tableViewを後ろから表示
        inputTextField.text = ""                                                                    //空文字
    }
    
    /*
    /* textに答えを入力した時にキーボードを消す(textViewのprotocolに用意されているメソッド) */
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.resignFirstResponder()
    }
    
    /* タッチした時にキーボードを消す(UIViewControllerに用意されているメソッド) */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /* タッチした時にキーボードを消す */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    */
}
