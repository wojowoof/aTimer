//
//  wTicker.swift
//  aTimer
//
//  Created by Jack Woychowski on 1/17/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class wTicker: NSObject {

    var tickCallback: (() -> Bool)?
    var tickRunning = false

    override init() {
        super.init()
    }

    func tickStart() {
        print("Start");
        tickRunning = true
        tickRun()
    }

    func tickRun() {
        print("Run");
        let delaytime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
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
        let result = (self.tickCallback != nil) && self.tickCallback!()
        print("ticked: cb ", self.tickCallback, " result ", result);
        if (tickRunning && result) {
            print("continue!");
            tickRun();
        }
    }
}
