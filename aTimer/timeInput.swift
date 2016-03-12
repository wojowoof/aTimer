//
//  timeInput.swift
//  aTimer
//
//  Created by Jack Woychowski on 1/14/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class timeInput: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: Properties
    var pickers = [UIPickerView]()
    var minutes = 1
    var seconds = 0
    let titleattrs = [NSFontAttributeName:UIFont(name: "Chalkduster", size: 40.0)!, NSForegroundColorAttributeName:UIColor.redColor()]
    var chooseCallback: (() -> Bool)?

    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

//        let btn = UIButton(frame: CGRect(x:0, y:0, width:240, height:44))
//        btn.backgroundColor = UIColor.greenColor()
//        btn.addTarget(self, action: "subButtonPressed:", forControlEvents: .TouchDown)
//        addSubview(btn)
//        self.backgroundColor = UIColor.redColor()

        let pck_m = UIPickerView(frame: CGRect(x:0, y:0, width:60, height:44))

        //pck_m.backgroundColor = UIColor.blueColor()
        pck_m.dataSource = self
        pck_m.delegate = self
        pickers += [pck_m]
        pck_m.selectRow(minutes, inComponent: 0, animated: false)

        let pck_s = UIPickerView(frame: CGRect(x: 2 + pck_m.frame.size.width, y:0, width:38, height:44))
        //pck_s.backgroundColor = UIColor.greenColor()
        pck_s.dataSource = self
        pck_s.delegate = self
        pickers += [pck_s]
        pck_s.selectRow(seconds, inComponent: 0, animated: false)

        addSubview(pck_m)
        addSubview(pck_s)
    }

    override func layoutSubviews() {
        var pframe = CGRect(x:0, y:0, width:60, height:44)
        for (index, pkr) in pickers.enumerate() {
            pframe.origin.x = CGFloat(index * (60 + 5))
            pkr.frame = pframe
        }
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 200, height: 100)
    }

    func disableInput() {
        pickers[0].userInteractionEnabled = false
        pickers[1].userInteractionEnabled = false
    }

    func enableInput() {
        pickers[0].userInteractionEnabled = true
        pickers[1].userInteractionEnabled = true

    }

    func ticksecs() -> Int {
        let tickspicked = (pickers[0].selectedRowInComponent(0) * 60) + pickers[1].selectedRowInComponent(0)
        return tickspicked
    }

    func setwheels(mins: Int, secs: Int) {
        print(String(format: "set wheels to %d:%02d", mins, secs))
        pickers[0].selectRow(mins, inComponent: 0, animated: true)
        pickers[1].selectRow(secs, inComponent: 0, animated: true)
    }

    // MARK: Pickerview Datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == pickers[0]) {
            return 2;
        }
        print("1 component for ", pickerView);
        return 1
    }

    func pickerView(picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (picker != pickers[0] && picker != pickers[1]) {
            print("Invalid picker ", picker);
            return -1;
        } else if (0 != component) {
            print("Invalid component ", component, " in picker ", picker);
            return -2;
        }
        print("60 rows");
        return 60
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        // print("Row ", row);
        if (pickerView == pickers[0]) {
            // return String(row)
            return NSAttributedString(string: String(format:"%d", row), attributes: titleattrs)
                // attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!, NSForegroundColorAttributeName:UIColor.redColor()])
        }
        //return String(format: "%02d", row);
        return NSAttributedString(string: String(format:"%02d", row), attributes: titleattrs)
            // attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!, NSForegroundColorAttributeName:UIColor.redColor()])
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected row ", row);
        if (nil != chooseCallback) {
            self.chooseCallback!()
        }
    }

    // MARK: Button Action
    func subButtonPressed(button: UIButton) {
        print("Button pressed 👍")
    }
}
