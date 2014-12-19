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
    
    var name : [NSString]
    var building : NSString?
    var dept : NSString?
    var empno : NSString?
//    var noteId : NSString?
    var notesCN : NSString?
    var notesOU : [NSString]
    var notesO : NSString?
    var shortName : NSString?
    var tel : NSString?
    var IsManager : Bool?
    
    
    override init() {

        self.name = [NSString] (count : 2, repeatedValue : "" )
        self.building = nil
        self.dept = nil
        self.empno = nil
        //self.noteId  = nil
        self.notesCN = nil
        self.notesOU =  [NSString] (count : 2, repeatedValue : "" )
        self.notesO = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = nil
        super.init()
    }
    
    func clear() {
        self.name = [NSString] (count : 2, repeatedValue : "" )
        self.building = nil
        self.dept = nil
        self.empno = nil
        //self.noteId  = nil
        self.notesCN = nil
        self.notesOU =  [NSString] (count : 2, repeatedValue : "" )
        self.notesO = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = nil
    }
    
    func setName(name1: NSString, name2: NSString){
        name[0] = name1
        name[1] = name2
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
    
//    func setNoteid(anoteid : NSString){
//        self.noteId = anoteid
//    }

    func setNotescn(anotescn : NSString){
        self.notesCN = anotescn
    }
    
    func setNotesOU(anotesou1 : NSString, anotesou2 : NSString){
        self.notesOU[0] = anotesou1
        self.notesOU[1] = anotesou2
    }
    
    func setNotesO(anotesO : NSString){
        self.notesO = anotesO
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