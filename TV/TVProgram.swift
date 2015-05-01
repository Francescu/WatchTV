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

enum TVChannel:String {
    case TF1 = "tf1", France2 = "france2", France3 = "france3", CanalPlus = "canalp", France5 = "france5", M6 = "m6", Arte = "arte", Direct8 = "d8", W9 = "w9"
    case TMC = "tmc", NT1 = "nt1", NRJ12 = "nrj12"
    
    func imageName() -> String {
        return self.rawValue
    }
}

class TVProgram {
    let channel:TVChannel
    let beginAt:NSDate
    let name:String
    let content:String?
    
    init (channel:TVChannel, beginAt:NSDate, name:String, content:String? = nil) {
        self.channel = channel
        self.beginAt = beginAt
        self.name = name
        self.content = content
    }
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
