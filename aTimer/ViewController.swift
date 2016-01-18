//
//  ViewController.swift
//  aTimer
//
//  Created by Jack Woychowski on 1/11/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var enterTimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeInputView: timeInput!
    var ticker: wTicker!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ticker = wTicker()
        ticker.tickCallback = tickCB
        // ticker.tickStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func curtime() -> String {
        let now = NSDate()
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // fmt.timeStyle = .ShortStyle
        return fmt.stringFromDate(now);
    }

    func tickCB() -> Bool {
        print("Tock! ", curtime()
        );
        return true
    }

    // MARK: Actions

    @IBAction func goButtonPressed(sender: UIButton) {
        enterTimeLabel.text = "Running!"
        print("Ticknow: ", curtime())
        if (!ticker.tickRunning) {
            ticker.tickStart()
        } else {
            ticker.tickStop()
        }
    }

    @IBAction func selectImageFromLibrary(sender: UILongPressGestureRecognizer) {
        enterTimeLabel.resignFirstResponder()
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.sourceType = .PhotoLibrary
        imagePickerCtrl.delegate = self
        presentViewController(imagePickerCtrl, animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        return true
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
}

