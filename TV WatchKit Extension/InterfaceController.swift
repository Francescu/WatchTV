//
//  InterfaceController.swift
//  TV WatchKit Extension
//
//  Created by Francescu on 01/05/2015.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import WatchKit
import Foundation

struct RowType {
    static let Program = "RowTypeClassic"
    
}

//TODO: Handle favorites channels in iPhone app through NSUserDefault + group
let favoritesChan:[TVChannel] = [ .TF1, .France2, .France3 , .CanalPlus , .France5 , .M6 , .Arte , .Direct8 , .W9, .TMC, .NT1, .NRJ12 ]

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var state = DataState.NotYet
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    func formatAndFill(data:FormatedContentType) {
        var result = [TVProgram]()
        for channel in favoritesChan {
            if let programs = data[channel.rawValue] {
                let prog = programNow(programs)
                result.append(prog)
            }
        }
        self.fillData(result)
    }
    
    func fillData(content:[TVProgram]) {
       self.table.setNumberOfRows(content.count, withRowType: RowType.Program)
        for index in 0..<content.count {
            let program = content[index]
            if let row = self.table.rowControllerAtIndex(index) as? TVProgramRow {
                row.logo.setImageNamed(TVChannel(rawValue:program.channel)!.imageName())
                row.beginTimer.setDate(program.beginAt)
                row.beginTimer.start()
                row.programName.setText(program.name)
            }
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let data = self.state.data() {
           self.formatAndFill(data)
        } else {
            WKInterfaceController.openParentApplication([NSObject:AnyObject](), reply: { (result, error) -> Void in
                if let d = result?["result"] as? NSData {
                    if let r = NSKeyedUnarchiver.unarchiveObjectWithData(d) as? FormatedContentType {
                        self.state = DataState.Data(r, DataState.dateString())
                        self.formatAndFill(r)
                    }
                }
            })
        }
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
