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

//通信してデータを取得
var request = NSURLRequest(URL: NSURL(string: "http://bluepages.ibm.com/BpHttpApisv3/wsapi?bySerial=096826")!)
let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

//Stringに変換して、配列に格納
let string:NSString = NSString(data: data!,encoding: NSUTF8StringEncoding)!
let array:NSArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())


var employeeList:[Employee] = []

var i:Int = 0
var no_of_emp : Int = 0
var employee: Employee = Employee()

for item in array {
    i++
    
    //spaceごとに配列に格納
    // var array2:NSArray = item.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    var array2:NSArray = item.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:":"))
    
    if array2.count == 2 {
        if array2[0] as NSString == "CNUM" {
            
            if i>1 {
                no_of_emp++
                employeeList.append(employee)
            }
            
            employee = Employee()
            employee.cnum = array2[1] as NSString
        }
            
        else if (array2[0] as NSString == "EMPNUM") {
            employee.empno = array2[1] as NSString
        }else if(array2[0] as NSString == "NAME") {
            NSLog("Name")
            employee.name = array2[1] as NSString
        }else if(array2[0] as NSString == "BLDG") {
            employee.building = array2[1] as NSString
        }else if(array2[0] as NSString == "DEPT") {
            employee.dept = array2[1] as NSString
        }else if(array2[0] as NSString == "EMPTYPE") {
            employee.emptype = array2[1] as NSString
        }else if(array2[0] as NSString == "MGR") {
            employee.flagManager = array2[1] as NSString
        }else if(array2[0] as NSString == "TIE") {
            employee.tie = array2[1] as NSString
        }else if(array2[0] as NSString == "XPHONE") {
            employee.xphone = array2[1] as NSString
        }else if(array2[0] as NSString == "FAX") {
            employee.fax = array2[1] as NSString
        }else if(array2[0] as NSString == "IMAD"){
            employee.imad = array2[1] as NSString
        }else if(array2[0] as NSString == "FLOOR") {
            employee.floor = array2[1] as NSString
        }else if(array2[0] as NSString == "USERID") {
            employee.userid = array2[1] as NSString
        }else if(array2[0] as NSString == "EMPCC") {
            employee.empcc = array2[1] as NSString
        }else{
            //do nothing
        }
        
    }
    
}
no_of_emp++
employeeList.append(employee)

for emp in employeeList {
    println("\(emp.cnum) \(emp.name)\t\(emp.building)\t\(emp.dept)\t\(emp.tie)")

}
    print("Totla record count =")
    println (i)
    print("Number of employees ")
    println(no_of_emp)


