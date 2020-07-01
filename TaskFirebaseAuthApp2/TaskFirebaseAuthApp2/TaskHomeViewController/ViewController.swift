//
//  ViewController.swift
//  TaskFirebaseAuthApp2
//
//  Created by 福島悠樹 on 2020/06/23.
//  Copyright © 2020 福島悠樹. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UserInfoDelegate {
    
    @IBOutlet weak var nameTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UserInfoManager.sharedInstance.delegate = self
        
        //ユーザーリストを読み込み
        UserInfoManager.sharedInstance.loadUserInfo()
        
        //ログインチェック
        if self.isLogin() == false{
            // ログインビューコントローラを表示
            self.presentLoginViewController()
        }
        
        //ナビゲーションバーの設定
        setupNavigationBar()
    }
    
    //再描画時処理
    override func viewWillAppear(_ animated: Bool) {
        //ユーザーリストを読み込み
        UserInfoManager.sharedInstance.loadUserInfo()
        
        //名前の表示
        let currentUserName = UserInfoManager.sharedInstance.getNameAtCurrentUserID()
        print("!!!")
        print(currentUserName)
        if currentUserName==""{
            nameTextField.text = "NoName"
        }else{
            nameTextField.text = currentUserName
        }
        
        /* ForDebug*
        print("\(String(describing:Auth.auth().currentUser?.uid)):ログインユーザーのユーザーID")
        print("\(String(describing:Auth.auth().currentUser?.email)):ログインユーザーのemail")
        
        for i in 0 ..< UserInfoManager.sharedInstance.getUserListsCount() {
            var idName:String = ""
            var idUserName:String = ""
            idName = UserInfoManager.sharedInstance.userLists[i].userID
            idUserName = UserInfoManager.sharedInstance.userLists[i].name
            print("はこ："+idName)
            print("なまえ："+idUserName)
        }
        * EndForDebug*/
    }
    //ログイン画面の表示関数
    func presentLoginViewController(){
        let loginVC = TaskLoginViewController()
        
        //モーダルスタイルを指定
        loginVC.modalPresentationStyle = .fullScreen
        
        //表示
        self.present(loginVC, animated: true, completion: nil)
    }
    
    //ログイン認証されているかどうかの判定関数
    func isLogin() -> Bool{
        //ログインしているユーザーがいるかどうかを判別
        if Auth.auth().currentUser != nil{
            return true
        }else{
            return false
        }
    }
    
    // navigation barの設定
    private func setupNavigationBar() {
        //右に+ボタンを配置
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMakeGroupView))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        //画面上部のナビゲーションバーの左側にログアウトボタンを設置し、押されたらログアウト関数がcallされるようにする
        let leftButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = leftButtonItem
        
        //タイトルを変更
        self.title = "HOME"
    }
    
    // +ボタンをタップしたときの動作
    @objc func showMakeGroupView() {
        let vc = TaskMakeTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // ログアウトボタンをタップしたときの動作
    @objc func logout() {
        do{
            try Auth.auth().signOut()
            
            //ログアウトに成功したら、ログイン画面を表示
            self.presentLoginViewController()
            
        }catch let signOutError as NSError{
            print("サインアウトエラー:\(signOutError)")
        }
    }
    
    //名前の編集を押下時の処理を記載
    @IBAction func tappedRenameBtn(_ sender: Any) {
        let vc = TaskEditUserInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    //QRCodeボタン押下時関数
    @IBAction func tappedQRCodeBtn(_ sender: Any) {
        /* ForDebug*
        // UserDefaultsのオールクリア
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        GroupInfoManager.sharedInstance.saveGroupInfo()
        * EndForDebug */
        
        let vc = TaskQRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //QRCode読み取りボタン押下時関数
    @IBAction func tappedReadQRCodeBtn(_ sender: Any) {
        let vc = ReadQRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

