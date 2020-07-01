//
//  TaskManager.swift
//  TaskFirebaseAuthApp2
//
//  Created by 福島悠樹 on 2020/06/23.
//  Copyright © 2020 福島悠樹. All rights reserved.
//

import Foundation
import FirebaseAuth

//----------------------------------------------------
//  ユーザー管理タスク
//----------------------------------------------------

class UserInfo:Codable{
    var userID:String
    var name:String
    
    init(userID:String, name:String){
        self.userID = userID
        self.name = name
    }
}

protocol UserInfoDelegate:class{
    /* NoAction */
}

class UserInfoManager{
    static let sharedInstance = UserInfoManager()
    
    var userLists:[UserInfo] = [UserInfo(userID:"", name:"")]
    weak var delegate:UserInfoDelegate?
    
    /* ユーザーリストの数を取得 */
    func getUserListsCount() -> Int{
        return self.userLists.count
    }
    
    /* ユーザーリストに追加 */
    func appendUserLists(userInfo:UserInfo){
        self.userLists.append(userInfo)
    }
    
    /* 現在のユーザーIDを見つけて名前を入れる */
    func setNameAtCurrentUserID(name:String){
        for i in 0 ..< UserInfoManager.sharedInstance.getUserListsCount() {
            if UserInfoManager.sharedInstance.userLists[i].userID==String(describing:Auth.auth().currentUser?.uid){
                
                UserInfoManager.sharedInstance.userLists[i].name = name
            }
        }
    }
    
    /* 現在のユーザーIDの名前を返す */
    func getNameAtCurrentUserID()->String{
        var currentName:String = ""
        
        for i in 0 ..< UserInfoManager.sharedInstance.getUserListsCount() {
            if UserInfoManager.sharedInstance.userLists[i].userID==String(describing:Auth.auth().currentUser?.uid){
                
                currentName = UserInfoManager.sharedInstance.userLists[i].name
            }
        }
        return currentName
    }
    
    /* ユーザーリストを保存 */
    func saveUserInfo(){
        UserInfoRepository.saveUserInfoUserDefaults(userInfo:userLists)
    }
    
    /* ユーザーリストを読込 */
    func loadUserInfo(){
        self.userLists = UserInfoRepository.loadUserInfoUserDefaults()
    }
}

//----------------------------------------------------
//  グループ管理タスク
//----------------------------------------------------
class GroupInfo:Codable{
    var groupName:String
    var groupMemberNames:[String]
    var groupMemberTalks:[String]
    
    init(groupName:String, groupMemberNames:[String], groupMemberTalks:[String]){
        self.groupName = groupName
        self.groupMemberNames = groupMemberNames
        self.groupMemberTalks = groupMemberTalks
    }
}

protocol GroupInfoDelegate:class{
    /* NoAction */
}

class GroupInfoManager{
    static let sharedInstance = GroupInfoManager()
    
    var groupInfo:[GroupInfo] = [GroupInfo(groupName:"", groupMemberNames:[""], groupMemberTalks:[""])]
    weak var delegate:GroupInfoDelegate?
    
    /* グループリストの数を取得 */
    func getGroupInfoCount() -> Int{
        return self.groupInfo.count
    }
    
    /* 指定したグループを取得 */
    func getGroupInfo(num:Int)->GroupInfo{
        return self.groupInfo[num]
    }
    
    /* グループを追加 */
    func appendGroupInfo(groupInfo:GroupInfo){
        self.groupInfo.append(groupInfo)
    }
    
    /* 指定したグループのメッセージを追加 */
    func appendGroupInfoTalks(num:Int, message:String){
        self.groupInfo[num].groupMemberTalks.append(message)
    }
    
    /* グループを削除 */
    func removeGroupInfo(num:Int){
        self.groupInfo.remove(at: num)
    }
    
    /* グループリストを保存 */
    func saveGroupInfo(){
        GroupInfoRepository.saveGroupInfoUserDefaults(groupInfo:groupInfo)
    }
    
    /* グループリストを読込 */
    func loadGroupInfo(){
        self.groupInfo = GroupInfoRepository.loadGroupInfoUserDefaults()
    }
}
