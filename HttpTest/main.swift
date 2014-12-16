//
//  main.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/15.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//
// Modified by Sumi

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


var request = NSURLRequest(URL: NSURL(string: "http://bluepages.ibm.com/BpHttpApisv3/wsapi?bySerial=096826")!)
let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

let string:NSString = NSString(data: data!,encoding: NSUTF8StringEncoding)!

//let array:NSArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "¥r"))
let array:NSArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())


var employeeList:[Employee] = []

var i:Int = 0
var employee: Employee = Employee()

for item in array {
    i++
    var array2:NSArray = item.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    if array2[0] as NSString == "CNUM:" {
        
        if i>1 {
            employeeList.append(employee)
        }
        
        employee = Employee()
        if array2.count == 2 {
            employee.serial = array2[1] as NSString
        }
        else {
            employee.serial = ""
        }
    }
    
    println(array2[0])
    if array2.count == 2 {
        println(array2[1])
    }
    
}

println(array[0])
print("Totla record count =")
println (i)


