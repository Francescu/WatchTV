//
//  TVProgram.swift
//  TV
//
//  Created by Francescu on 01/05/2015.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import Foundation
extension NSDate
{
    func isAfter(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isBefore(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    func isSame(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}

enum DataState {
    case Data(FormatedContentType, String)
    case NotYet
    
    static func dateString() -> String {
        return NSDate().stringFromFormat("YYYY-MM-DD")
    }
    
    func data() -> FormatedContentType? {
        switch self {
        case let .Data(data, dateString) where dateString == DataState.dateString():
            return data
        default:
            return nil
        }
    }
}
enum TVChannel:String {
    case TF1 = "tf1", France2 = "france2", France3 = "france3", CanalPlus = "canalp", France5 = "france5", M6 = "m6", Arte = "arte", Direct8 = "d8", W9 = "w9"
    case TMC = "tmc", NT1 = "nt1", NRJ12 = "nrj12"
    
    func imageName() -> String {
        return self.rawValue
    }
}

@objc(TVProgram)
class TVProgram:NSObject, NSCoding {
    let channel:String
    let beginAt:NSDate
    let endAt:NSDate?
    let name:String
    let content:String?
    
    @objc init (channel:String, beginAt:NSDate, endAt:NSDate?, name:String, content:String? = nil) {
        self.channel = channel
        self.beginAt = beginAt
        self.endAt = endAt
        self.name = name
        self.content = content
    }
    
    required init(coder aDecoder: NSCoder) {
        self.channel = aDecoder.decodeObjectForKey("channel") as! String
        self.beginAt = aDecoder.decodeObjectForKey("beginAt") as! NSDate
        self.endAt = aDecoder.decodeObjectForKey("endAt") as? NSDate
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.content = aDecoder.decodeObjectForKey("content") as? String
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.channel, forKey: "channel")
        aCoder.encodeObject(self.beginAt, forKey: "beginAt")
        aCoder.encodeObject(self.endAt, forKey: "endAt")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.content, forKey: "content")
    }
//    
//    func programWithEndDate(endAt:NSDate) -> TVProgram {
//        return TVProgram(channel: channel, beginAt: beginAt, endAt: endAt, name: name, content: content)
//    }
}

func programNow(programs:[TVProgram]) -> TVProgram {
    let now = NSDate()
    return programs.reduce(programs[0]) {
        buffer, element in
        if element.beginAt.isAfter(now) {
            return buffer
        }
        if element.beginAt.isAfter(buffer.beginAt) {
            return element
        }
        return buffer
    }
}
