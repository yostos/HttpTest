//
//  main.swift
//  HttpTest
//
//  Created by Yoshida Toshiyuki on 2014/12/15.
//  Copyright (c) 2014年 Yoshida Toshiyuki. All rights reserved.
//

import Foundation



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

let array:NSArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "¥r"))

var i:Int = 0
for item in array {
    i++
    println(i)
    println(item)
}

println(array[0])
print("Totla record count =")
println (i)


