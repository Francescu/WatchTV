//
//  JSONParser.swift
//  TV
//
//  Created by Francescu on 01/05/2015.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import Foundation

typealias JSONContentType = Dictionary<String,Array<Dictionary<String,String>>>
typealias FormatedContentType = Dictionary<String,Array<TVProgram>>

func parse (path:String) -> FormatedContentType? {
    
    if let data = NSData(contentsOfFile: path) {
        let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //        println(str)
        var error:NSError?
        
        
        if let obj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? JSONContentType {
            
//            println(obj)
            var res = FormatedContentType()
            
            let now = NSDate()
            
            for (channelString, content) in obj {
                if let channel = TVChannel(rawValue: channelString) {
                    res[channel.rawValue] = [TVProgram]()
                    for programJSON in content {
                        if let name = programJSON["name"],
                            let beginAtString = programJSON["beginAt"] {
                                let comp = split(beginAtString) { $0 == ":" }
                                let beginAt = now.change(year: nil, month: nil, day: nil, hour: (comp[0] as NSString).integerValue, minute:(comp[1] as NSString).integerValue, second: Int(arc4random_uniform(60)))
                                res[channel.rawValue]?.append(TVProgram(channel: channel.rawValue, beginAt: beginAt, endAt:nil, name: name, content: nil))
                        }
                    }
                }
            }
            return res
        }
        else {
            println("json error \(error)")
        }
    }
    return nil
}