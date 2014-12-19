//
//  main.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/15.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation


var bluepageLookuper:BluepageLookuper=BluepageLookuper()
var bluepageLookupCondition:BluepageLookupCondition = BluepageLookupCondition()

// test
//bluepageLookupCondition.setName("Wataru", name2: "Minamimura")
//bluepageLookupCondition.setDept("7A500")
//bluepageLookupCondition.setTel("")
//bluepageLookupCondition.setBuilding("HZ")
//bluepageLookupCondition.setEmpno("351395")
//bluepageLookupCondition.setNoteid("CN=Natsuka Sumi/OU=Japan/O=IBM@IBMJP")
//bluepageLookupCondition.setShortname("NATSU74")
//bluepageLookupCondition.setMgrflg()
bluepageLookupCondition.setNotescn("Natsuka Sumi")
bluepageLookupCondition.setNotesOU("Japan", anotesou2: "")
bluepageLookupCondition.setNotesO("IBM@IBMJP")

let employeeList:[Employee] = bluepageLookuper.lookup(bluepageLookupCondition)


var i:Int = 0
for emp in employeeList {
    i++
    println("\(i):\(emp.cnum) \(emp.cn)\t\(emp.building)\t\(emp.dept)\t\(emp.userid)\t\(emp.tie)\t\(emp.nativeFirstName)\t\(emp.nativeLastName)")

}


