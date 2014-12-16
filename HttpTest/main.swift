//
//  main.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/15.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation


let arr = [
    0xe3, 0x81, 0x82,
    0xe3, 0x81, 0x84,
    0xe3, 0x81, 0x86,
    0xe3, 0x81, 0x88,
    0xe3, 0x81, 0x8a
    ] as [CUnsignedChar]

let datax = NSData(bytes: arr, length: 15)
let str = NSString(data:datax, encoding:NSUTF8StringEncoding)

println(str)

var bluepageLookuper:BluepageLookuper=BluepageLookuper()
var bluepageLookupCondition:BluepageLookupCondition = BluepageLookupCondition()

let employeeList:[Employee] = bluepageLookuper.lookup(bluepageLookupCondition)


NSLog("\(employeeList.count)")

var i:Int = 0
for emp in employeeList {
    i++
    println("\(i):\(emp.cnum) \(emp.name)\t\(emp.building)\t\(emp.dept)\t\(emp.tie)")

}


