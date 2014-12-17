//
//  BluepageLookuper.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/16.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation
class BluepageLookuper : NSObject {
    
    var slaphApiUrl:NSString = ""
    let API_LOCATOR_URL = "http://bluepages.ibm.com/BpHttpApisv3/apilocator"
    
    // Constructor
    override init() {
        super.init()
        slaphApiUrl = initApiUrl(API_LOCATOR_URL)
    }
    
    
    // Initialize SLAPHAPI URL using API locator
    func initApiUrl(apiLocatorUrl: NSString) -> NSString {
        
        // BluepageLookupConditionからURLを生成するロジック
        // 通信してAPILocator情報（URL）を取得
        var requestApi = NSURLRequest(URL: NSURL(string: API_LOCATOR_URL)!)
        let dataApi = NSURLConnection.sendSynchronousRequest(requestApi, returningResponse: nil, error: nil)
        
        //Stringに変換して、配列に格納
        let bpApiStreamString:NSString = NSString(data: dataApi!,encoding: NSUTF8StringEncoding)!
        let bpApiRecords:NSArray = bpApiStreamString.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        var flg_slaphapi : Bool = false
        var api_url : NSString = ""
        
        //SLAPHAPIのURLを取得
        for url in bpApiRecords {
            //コロン":"をDelimitorとして、各レコードの項目名と項目情報を分離する。
            let bpApiData:NSArray = url.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:":"))
            var key : NSString = bpApiData[0] as NSString
            var value : NSString = bpApiData[1] as NSString
            if (bpApiData.count == 2){
                if( key == "NAME"){
                    if (value == " SLAPHAPI"){
                        NSLog("PASS")
                        flg_slaphapi = true
                    }
                }
            }else if(bpApiData.count == 3){
                var urlbody : NSString = bpApiData[2] as NSString
                if(key == "URL") && (flg_slaphapi == true){
                    api_url = "http:" + urlbody
                    break;
                }
            }
        }
        return api_url
    }
    
    // Look up person information from BluePages
    func lookup(lookupCondition:BluepageLookupCondition) -> [Employee] {
        
        var condition: BluepageLookupCondition = BluepageLookupCondition()
        let SLAPHAPI_URL : String = slaphApiUrl as String
        let OBJ : NSString = "ibmperson/"
        let str1 : NSString = "(&"
        let str2 : NSString = ").list,printable/bytext"
        let str3 : NSString = "?serialnumber&cn&ibmserialnumber&dept&buildingname&employeetype&ismanager&telephonenumber&internalmaildrop&floor&mail&primaryuserid&manager&managerserialnumber&employeecountrycode&nativeFirstName&nativeLastName"
        var SEARCH_PARAMATER : String = ""
        var allURL : String = ""
        
        //検索条件定義
        let name : String = "(cn=*"
        let dept : NSString = "(dept=*"
        let serialnumber : NSString = "(ibmserialnumber=*"
        let building : NSString = "(buildingname="
        let notesid : NSString = "(mail=*"
        let notesshort : NSString = "(primaryuserid=*"
        let telephone : NSString = "(telephonenumber=*"
        let ismgr : NSString = "(ismanager="
        let country : NSString = "(employeecountrycode=*"
        
        //検索条件のをURLエンコードして結合
        //Todo 検索項目にスペースが入力された場合のハンドリング
        if (lookupCondition.name? != nil) {
            NSLog("Passssssssss")
            let nameString : String = lookupCondition.name as String
            let encodedName = nameString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += name
            SEARCH_PARAMATER += encodedName! + ")"
        }
        if (lookupCondition.dept? != nil) {
            let deptString : String = lookupCondition.dept as String
            let encodedDept = deptString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += dept
            SEARCH_PARAMATER += encodedDept! + ")"
        }
        if (lookupCondition.building? != nil) {
            let buildingString : String = lookupCondition.building as String
            let encodedBuilding = buildingString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += building
            SEARCH_PARAMATER += encodedBuilding! + ")"
        }
        if (lookupCondition.empno? != nil) {
            let empnoString : String = lookupCondition.empno as String
            let encodedEmpno = empnoString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += serialnumber
            SEARCH_PARAMATER += encodedEmpno! + ")"
        }
        if (lookupCondition.noteId? != nil) {
            let notesidString : String = lookupCondition.noteId as String
            let encodedNotesid = notesidString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += notesid
            SEARCH_PARAMATER += encodedNotesid! + ")"
        }
        if (lookupCondition.shortName? != nil) {
            let shortnameString : String = lookupCondition.shortName as String
            let encodedShortName = shortnameString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += notesshort
            SEARCH_PARAMATER += encodedShortName! + ")"
        }
        if (lookupCondition.tel? != nil) {
            let telString : String = lookupCondition.tel as String
            let encodedTel = telString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += telephone
            SEARCH_PARAMATER += encodedTel! + ")"
        }
        if (lookupCondition.IsManager? != nil) {
            if (lookupCondition.IsManager? == true) {
                SEARCH_PARAMATER += ismgr
                SEARCH_PARAMATER += "Y" + ")"
            }
        }
        
        if (SEARCH_PARAMATER.isEmpty){
            // Todo 検索条件を入力してください
        } else {
            allURL += "\(SLAPHAPI_URL)\(OBJ)\(str1)\(SEARCH_PARAMATER)\(str2)\(str3)"
        }
        
        NSLog(allURL + "---------")
        
        // 通信してデータを取得
        var request = NSURLRequest(URL: NSURL(string: allURL)!)
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
                if employeeData[0] as NSString == "dn" {
                    // 最初のレコードは空なので配列には入れない。
                    if no_of_emp != 0 {
                        employeeList.append(employee)
                    }
                    
                    employee = Employee()
                    no_of_emp++
                    
                }
                else if (employeeData[0] as NSString == "serialnumber"){
                    employee.cnum = employeeData[1] as NSString
                }
                else if (employeeData[0] as NSString == "ibmserialnumber") {
                    employee.ibmserialnumber = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "cn") {
                    employee.cn = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "buildingname") {
                    employee.building = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "dept") {
                    employee.dept = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "employeetype") {
                    employee.emptype = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "ismanager") {
                    employee.flagManager = employeeData[1] as NSString
                    //}else if(employeeData[0] as NSString == "TIE") {
                    //    employee.tie = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "telephonenumber") {
                    employee.phone = employeeData[1] as NSString
                    //}else if(employeeData[0] as NSString == "FAX") {
                    //    employee.fax = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "internalmaildrop"){
                    employee.imad = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "floor") {
                    employee.floor = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "mail") {
                    employee.userid = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "employeecountrycode") {
                    employee.empcc = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "primaryuserid") {
                    employee.priuserid = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "managerserialnumber") {
                    employee.mgrcnum = employeeData[1] as NSString
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
