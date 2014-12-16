//
//  main.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/15.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation

println("Hello, World!")
var request = NSURLRequest(URL: NSURL(string: "http://bluepages.ibm.com/BpHttpApisv3/wsapi?bySerial=096826")!)
var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
if data == nil {
    println("No Data Found")
}
else {
    println(data)
  //  var string:NSString!
  //  string = init(data: data,encoding: NSUTF8StringEncoding)
    
 }