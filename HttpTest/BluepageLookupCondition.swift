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
    var IsManager : Bool
    
    
    override init() {

        self.IsManager = false
        self.name = nil
        self.building = nil
        self.dept = nil
        self.empno = nil
        self.noteId  = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = false
        super.init()
    }
    
    func clear() {
        self.IsManager = false
        self.name = nil
        self.building = nil
        self.dept = nil
        self.empno = nil
        self.noteId  = nil
        self.shortName  = nil
        self.tel  = nil
        self.IsManager = false
    }
}