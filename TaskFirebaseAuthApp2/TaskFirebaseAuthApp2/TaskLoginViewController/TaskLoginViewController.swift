//
//  TaskLoginViewController.swift
//  TaskFirebaseAuthApp2
//
//  Created by 福島悠樹 on 2020/06/23.
//  Copyright © 2020 福島悠樹. All rights reserved.
//

import UIKit
import FirebaseAuth

class TaskLoginViewController: UIViewController, UserInfoDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UserInfoManager.sharedInstance.delegate = self  //己にセット
        emailTextView.delegate = self
        passwordTextView.delegate = self
        passwordTextView.isSecureTextEntry = true       //pw非表示
    }
    
    //成功時の画面遷移処理
    func presentTaskHomeViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //アラート表示関数
    func showAlert( title:String, message:String? ){
        //UIAlertControllerを関数の引数であるとtitleとmessageを使ってインスタンス化
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //UIAlertActionを追加
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //表示
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //新規登録の際のエラー表示
    func newRegisterErrAlert(error:NSError){
        //引数errorのもつコードを使って、EnumであるAuthErrorCodeを読み出し
        if let errCode = AuthErrorCode(rawValue: error.code){
            var message = ""
            
            switch errCode {
            case .invalidEmail:
                message = "有効なメッセージを入力して下さい"
            case .emailAlreadyInUse:
                message = "既に登録されているEmailアドレスです"
            case .weakPassword:
                message = "パスワードは6文字以上で入力してください"
                
            default:
                message = "エラー：\(error.localizedDescription)"
            }
            
            //アラート表示
            self.showAlert(title: "登録できませんでした", message: message)
        }
    }
    
    //ログインの際のエラー表示
    func logInErrAlert(error:NSError){
        //引数errorのもつコードを使って、EnumであるAuthErrorCodeを読み出し
        if let errCode = AuthErrorCode(rawValue: error.code){
            var message = ""
            
            switch errCode {
            case .userNotFound:
                message = "アカウントが見つかりませんでした"
            case .wrongPassword:
                message = "パスワードを確認してください"
            case .userDisabled:
                message = "アカウントが無効になっています"
            case .invalidEmail:
                message = "Emailが無効な形式です"
            default:
                message = "エラー：\(error.localizedDescription)"
            }
            
            //アラート表示
            self.showAlert(title: "ログインできませんでした", message: message)
        }
    }
    
    //新規登録処理
    func emailNewRegister(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error as NSError?{
                //エラー時の処理
                self.newRegisterErrAlert(error:error)
            }
            else{
                //成功時の処理
                self.actSuccessLogin()
            }
        }
    }
    
    //ログイン処理
    func emailLogin(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error as NSError?{
                //エラー時の処理
                self.logInErrAlert(error:error)
            }
            else{
                //成功時の処理
                self.actSuccessLogin()
            }
        }
    }
    
    //ログイン時の警告表示共通関数
    func commonAlert(email:String, password:String)->Bool{
        var result:Bool = false
        
        if email.isEmpty && password.isEmpty{
            self.showAlert(title:"エラー", message: "メールアドレスとパスワードを入力してください")
        }
        else if email.isEmpty{
            self.showAlert(title:"エラー", message: "メールアドレスを入力してください")
        }
        else if password.isEmpty{
            self.showAlert(title:"エラー", message: "パスワードを入力してください")
        }
        else{
            result = true
        }
        
        return result
    }
    
    //リストへの追加処理関数
    func addUserInfo(){
        let userInfo = UserInfo(userID:String(describing:Auth.auth().currentUser?.uid), name:"")
        
        //リストに追加
        UserInfoManager.sharedInstance.appendUserLists(userInfo:userInfo)
        
        //ユーザーリストを保存
        UserInfoManager.sharedInstance.saveUserInfo()
    }
    //成功時の処理
    func actSuccessLogin(){
        //ユーザーリストに無かったら追加
        if UserInfoManager.sharedInstance.getUserListsCount()==0{
            //リストに追加
            addUserInfo()
            
        }else{
            for i in 0 ..< UserInfoManager.sharedInstance.getUserListsCount() {
                if UserInfoManager.sharedInstance.userLists[i].userID==String(describing:Auth.auth().currentUser?.uid){
                    //既にある
                    break
                }else{
                    //リストに追加
                    addUserInfo()
                }
            }
        }
        
        //Home画面表示
        self.presentTaskHomeViewController()
    }
    
    /* textに答えを入力した時にキーボードを消す(textFieldのprotocolに用意されているメソッド) */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    /* タッチした時にキーボードを消す(UIViewControllerに用意されているメソッド) */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //ログインボタン押下時関数
    @IBAction func tappedLoginBtn(_ sender: Any) {
        guard let email = emailTextView.text, let password = passwordTextView.text else{return}
        
        if commonAlert(email:email, password:password)==true {
            //ログイン処理
            self.emailLogin(email: email, password: password)
        }
    }
    
    //新規登録ボタン押下時関数
    @IBAction func tappedNewRegisterBtn(_ sender: Any) {
        guard let email = emailTextView.text, let password = passwordTextView.text else{return}
        
        if commonAlert(email:email, password:password)==true {
            //新規登録処理
            self.emailNewRegister(email: email, password: password)
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
