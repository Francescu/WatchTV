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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let filePath = NSBundle.mainBundle().pathForResource("sample", ofType: "json")
        
        if let content = parse(filePath!) {
            var result = [TVProgram]()
            for channel in favoritesChan {
                if let programs = content[channel] {
                    let prog = programNow(programs)
                    result.append(prog)
                }
            }
            self.fillData(result)
        }
    }

    func fillData(content:[TVProgram]) {
       self.table.setNumberOfRows(content.count, withRowType: RowType.Program)
        for index in 0..<content.count {
            let program = content[index]
            if let row = self.table.rowControllerAtIndex(index) as? TVProgramRow {
                row.logo.setImageNamed(program.channel.imageName())
                row.beginTimer.setDate(program.beginAt)
                row.beginTimer.start()
                row.programName.setText(program.name)
            }
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
