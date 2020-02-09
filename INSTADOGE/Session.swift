//
//  Session.swift
//  INSTADOGE
//
//  Created by Einar Flobak on 07.11.2017.
//  Copyright © 2017 Dogetek. All rights reserved.
//

import Foundation


class Session {
    static let sharedInstance = Session()
    private init() {}
    
    var SessionId = String()
    var userInfo = NSDictionary()
    var currentChnId = String()
    var currentChnName = String()
    
    func getSession() -> String {
        return SessionId
    }
    
    func setSession(id : String) {
        SessionId = id
    }
    
    func getUserInfo() -> NSDictionary {
        return userInfo
    }
    
    func setUserInfo(details : NSDictionary) {
        userInfo = details
    }
    
    func getCurrentChnName() -> String {
        return currentChnName
    }
    
    func setCurrentChnName(name : String) {
        currentChnName = name
    }
    func getCurrentChnId() -> String {
        return currentChnId
    }
    
    func setCurrentChnId(id : String) {
        currentChnId = id
    }
    

}
