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
    
    //------------------------------------------------------------------------------------------------------
    // Initialize SLAPHAPI URL using API locator
    //------------------------------------------------------------------------------------------------------
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
        for line in bpApiRecords {
            let r : NSRange = line.rangeOfString(":")
            let loc = r.location
            if (loc != NSNotFound) {
                //文字列の位置を取得して、前後に分割
                let key : NSString = (line as NSString).substringToIndex(loc)           // :前の文字列
                let value : NSString = (line as NSString).substringFromIndex(loc + 2)   // :以降の文字列
                if( key == "NAME"){
                    if (value == "SLAPHAPI"){
                        flg_slaphapi = true
                    }
                }else if (key == "URL") && (flg_slaphapi == true){
                    api_url = value
                    break;
                }
            }
        }
        return api_url
    }
    
    //------------------------------------------------------------------------------------------------------
    // Look up person information from BluePages
    //------------------------------------------------------------------------------------------------------
    func lookup(lookupCondition:BluepageLookupCondition) -> [Employee] {
        
        // 検索用URL　String部品
        var condition: BluepageLookupCondition = BluepageLookupCondition()
        let SLAPHAPI_URL : String = slaphApiUrl as String
        let OBJ : NSString = "ibmperson/"
        let str1 : NSString = "(&"
        let str2 : NSString = ").list,printable/bytext"
        let str3 : NSString = "?serialnumber&cn&ibmserialnumber&dept&buildingname&employeetype&ismanager&telephonenumber&internalmaildrop&floor&mail&primaryuserid&manager&managerserialnumber&employeecountrycode&nativeFirstName&nativeLastName&mobile&tieline&notesemail"    // 検索項目
        var SEARCH_PARAMATER : String = ""
        var allURL : String = ""
        
        //検索条件定義
        var e : Bool = lookupCondition.name.isEmpty
        var name = ""
        let dept : NSString = "(dept=*"
        let serialnumber : NSString = "(ibmserialnumber="
        let building : NSString = "(buildingname="
        let notesid : NSString = "(notesemail="
        let notesshort : NSString = "(primaryuserid="
        let telephone : NSString = "(telephonenumber="
        let ismgr : NSString = "(ismanager="
        let country : NSString = "(employeecountrycode="
        
        //検索条件のをURLエンコードして結合
        if (false == e && (lookupCondition.name[0] != "" && lookupCondition.name[1] != "")) {
            
            let name1String : String = lookupCondition.name[0] as String
            let name2String : String = lookupCondition.name[1] as String
            
            if (name1String != "" && name2String != ""){
                name = "(|(cn=" + name1String + " " + name2String + ")(cn=" + name2String + " " + name1String + ")"
            }else if (name1String != "" && name2String == ""){
                name = "(|(cn=*" + " " + name1String + ")(cn=" + name1String + " *)"
            }else if (name1String == "" && name2String != ""){
                name = "(|(cn=*" + " " + name2String + ")(cn=" + name2String + " *)"
            }
            
            let encodedName = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += encodedName!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.dept? != nil) {
            let deptString : String = lookupCondition.dept as String
            let encodedDept = deptString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += dept
            SEARCH_PARAMATER += encodedDept!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.building? != nil) {
            let buildingString : String = lookupCondition.building as String
            let encodedBuilding = buildingString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += building
            SEARCH_PARAMATER += encodedBuilding!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.empno? != nil) {
            let empnoString : String = lookupCondition.empno as String
            let encodedEmpno = empnoString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += serialnumber
            SEARCH_PARAMATER += encodedEmpno!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.notesCN? != nil) {
            let notesCNString : String = lookupCondition.notesCN!
            let notesOString : String = lookupCondition.notesO!
            let notesOUString1 : String = lookupCondition.notesOU[0]
            var notesOUString2 : String = ""
            var notesidString : String = ""
            
            var ouSecFlg : Bool = false
            
            if (lookupCondition.notesOU[1] != "") {
                notesOUString2 = lookupCondition.notesOU[1]
                ouSecFlg = true
            }
            
            // OUが二つ設定されている人用にも作成する
            if (!ouSecFlg) {
                notesidString = "CN=" + notesCNString + "/OU=" + notesOUString1 + "/O=" + notesOString
            }else {
                notesidString = "CN=" + notesCNString + "/OU=" + notesOUString1 + "/OU=" + notesOUString2 + "/O=" + notesOString
            }
            let encodedNotesid = notesidString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += notesid
            SEARCH_PARAMATER += encodedNotesid!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.shortName? != nil) {
            let shortnameString : String = lookupCondition.shortName as String
            let encodedShortName = shortnameString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += notesshort
            SEARCH_PARAMATER += encodedShortName!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.tel? != nil) {
            let telString : String = lookupCondition.tel as String
            let encodedTel = telString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            SEARCH_PARAMATER += telephone
            SEARCH_PARAMATER += encodedTel!
            SEARCH_PARAMATER += ")"
        }
        if (lookupCondition.IsManager? != nil) {
            if (lookupCondition.IsManager? == true) {
                SEARCH_PARAMATER += ismgr
                SEARCH_PARAMATER += "Y"
                SEARCH_PARAMATER += ")"
            }
        }
        
        if (SEARCH_PARAMATER.isEmpty){
            // Todo 検索条件を入力してください　；　UIで実装
        } else {
            allURL += "\(SLAPHAPI_URL)\(OBJ)\(str1)\(SEARCH_PARAMATER)\(str2)\(str3)"
        }
        
        
        // 通信してデータを取得
        var request = NSURLRequest(URL: NSURL(string: allURL)!)
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        //Stringに変換して、配列に格納
        let employeeStreamString:NSString = NSString(data: data!,encoding: NSUTF8StringEncoding)!
        let employeeRecords:NSArray = employeeStreamString.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        //検索結果の取得
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
                }else if (employeeData[0] as NSString == "ibmserialnumber") {
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
                }else if(employeeData[0] as NSString == "telephonenumber") {
                    employee.phone = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "FAX") {
                    employee.fax = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "internalmaildrop"){
                    employee.imad = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "floor") {
                    employee.floor = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "notesemail") {
                    employee.userid = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "employeecountrycode") {
                    employee.empcc = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "primaryuserid") {
                    employee.priuserid = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "managerserialnumber") {
                    employee.mgrcnum = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "mobile") {
                    employee.mobile = employeeData[1] as NSString
                }else if(employeeData[0] as NSString == "tieline") {
                    employee.tie = employeeData[1] as NSString
                }else{
                    //do nothing
                }
                //ネイティブ言語だけ、":"が一つ多いので配列が３つになる
            }else if (employeeData.count == 3) {
                if(employeeData[0] as NSString == "nativeFirstName") {
                    
                    
                }else if (employeeData[0] as NSString == "nativeLastName") {
                    // Todo nil問題が解決しません。。
                    //                    var base64LN = employeeData[2] as NSString
                    //                    var dataLN = NSData(base64EncodedString: base64LN, options: .allZeros)
                    //                    var encodedLN = NSString(data: dataLN!, encoding: NSUTF8StringEncoding)
                    //                    NSLog(encodedLN!)
                }
            }
            
        }
        // add last record
        employeeList.append(employee)
        return employeeList
    }
    
    
}

