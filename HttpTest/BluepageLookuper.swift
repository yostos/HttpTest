//
//  BluepageLookuper.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/16.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation
class BluepageLookuper : NSObject {
  
        
    func lookup(lookupCondition:BluepageLookupCondition) -> [Employee] {
        // TODO: BluepageLookupConditionからURLを生成するロジック
        
        // 通信してデータを取得
        var request = NSURLRequest(URL: NSURL(string: "http://bluepages.ibm.com/BpHttpApisv3/wsapi?bySerial=096826")!)
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

        //Stringに変換して、配列に格納
        let employeeStreamString:NSString = NSString(data: data!,encoding: NSUTF8StringEncoding)!
        let employeeRecords:NSArray = employeeStreamString.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        var employeeList:[Employee] = []
        var no_of_emp : Int = 0
       
        var employee: Employee = Employee()
        for item in employeeRecords {
            //コロン":"をDelimitorとして、各レコードの項目名と項目情報を分離する。
            let employeeData:NSArray = item.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:":"))
           
            if employeeData.count == 2 {
                if employeeData[0] as NSString == "CNUM" {
                    // 最初のレコードは空なので配列には入れない。
                    if no_of_emp != 0 {
                        employeeList.append(employee)
                    }
                    
                    employee = Employee()
                    no_of_emp++
                    employee.cnum = employeeData[1] as NSString
                }
                else if (employeeData[0] as NSString == "EMPNUM") {
                    employee.empno = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "NAME") {
                    employee.name = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "BLDG") {
                    employee.building = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "DEPT") {
                    employee.dept = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "EMPTYPE") {
                    employee.emptype = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "MGR") {
                    employee.flagManager = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "TIE") {
                    employee.tie = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "XPHONE") {
                    employee.xphone = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "FAX") {
                    employee.fax = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "IMAD"){
                    employee.imad = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "FLOOR") {
                    employee.floor = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "USERID") {
                    employee.userid = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "EMPCC") {
                    employee.empcc = employeeData[1] as NSString
                }else{
                    //do nothing
                }
                
            }
            
        }
        // add last record
     employeeList.append(employee)
        return employeeList
    }
    
}
