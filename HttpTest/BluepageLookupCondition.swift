//
//  BluepageLookupCondition.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/16.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation
class BluepageLookupCondition : NSObject {
    
    // These fields are key for looking up Bluepages
    // 'nil' means that the key is not speciflied.
    
    var name : NSString?
    var building : NSString?
    var dept : NSString?
    var empno : NSString?
    var noteId : NSString?
    var shortName : NSString?
    var tel : NSString?
    var IsManager : Bool?
    
    
    override init() {

        self.name = nil
        self.building = nil
        self.dept = nil
        self.empno = nil
        self.noteId  = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = nil
        super.init()
    }
    
    func clear() {
                self.name = nil
        self.building = nil
        self.dept = nil
        self.empno = nil
        self.noteId  = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = nil
    }
    
    func setName(aname : NSString){
        self.name = aname
    }

    func setBuilding(abuilding : NSString){
        self.building = abuilding
    }

    func setDept(adept : NSString){
        self.dept = adept
    }
    
    func setEmpno(aempno : NSString){
        self.empno = aempno
    }
    func setNoteid(anoteid : NSString){
        self.noteId = anoteid
    }
    
    func setShortname(ashortname : NSString){
        self.shortName = ashortname
    }
    
    func setTel(atel : NSString){
        self.tel = atel
    }
    
    func setMgrflg(amfrflg : Bool){
        self.IsManager = true
    }
}