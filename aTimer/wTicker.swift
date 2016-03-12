//
//  wTicker.swift
//  aTimer
//
//  Created by Jack Woychowski on 1/17/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class wTicker: NSObject {

    var tickCallback: ((Int) -> Bool)?
    var tickRunning = false
    var tickstime : NSDate!

    override init() {
        super.init()
    }

    func tickStart() {
        print("Start");
        tickRunning = true
        tickRun()
    }

    func timestr(date: NSDate?) -> String {
        var adate = date
        if nil == adate {
            adate = NSDate()
        }
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt.stringFromDate(adate!);
    }

    func tickRun() {
        print("Run");
        let delaytime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        tickstime = NSDate()
        print("Run: at ", timestr(tickstime))
        dispatch_after(delaytime, dispatch_get_main_queue(), onTick)
    }

    func tickStop() {
        print("Stop!");
        tickRunning = false;
    }

    func onTick() {
        if (!tickRunning) {
            print("Stopped, don't CB")
            return
        }
        let now = NSDate()
        var timediff = Int(now.timeIntervalSinceDate(tickstime!))
        if (1 > timediff) { timediff = 1 }
        print("Time diff (", timestr(tickstime), " and ", timestr(now), ") = ", timediff)

        // @@@ BUG: Ticker stops if there's no callback !!!
        let result = (self.tickCallback != nil) && self.tickCallback!(timediff)

        print("ticked: cb ", self.tickCallback, " result ", result);
        if (tickRunning && result) {
            print("continue!");
            tickRun();
        } else {
            print("Stop! (from cb)");
            tickRunning = false;
        }
    }
}
