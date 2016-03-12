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
    @IBOutlet weak var imageView: revealImageView!
    @IBOutlet weak var timeInputView: timeInput!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var timeChooseButton: UIButton!

    var ticker: wTicker!
    var tickschosen = 0 // @@@ TODO: Let timeInputView keep track! @@@
    var tickaccum = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ticker = wTicker()
        ticker.tickCallback = tickCB
        // ticker.tickStart()
        timeInputView.chooseCallback = timeChosenCB;
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

    // There are three states:
    //   Ready: time can be chosen, no timer is currently counting or paused
    //   Running: Timer is running, time cannot be chosen
    //   Paused: Timer is not running, time cannot be changed
    func setReadyState() {
        enterTimeLabel.text = "Ready!"
        goButton.setTitle("Start", forState: .Normal)
        timeChooseButton.enabled = true
        timeChooseButton.userInteractionEnabled = true
        timeInputView.enableInput()
        self.imageView.coverPercent(0.00)
    }

    func setDoneState() {
        enterTimeLabel.text = "Done!"
        goButton.setTitle("---", forState: .Normal)
        timeChooseButton.enabled = true
        timeChooseButton.userInteractionEnabled = true
        timeInputView.enableInput()
    }

    func setRunningState() {
        enterTimeLabel.text = "Running!"
        goButton.setTitle("Pause", forState: .Normal)
        timeChooseButton.enabled = false
        timeChooseButton.userInteractionEnabled = false
        timeInputView.disableInput()
    }

    func setPausedState() {
        enterTimeLabel.text = "Paused"
        goButton.setTitle("Continue", forState: .Normal)
        timeChooseButton.enabled = false
        timeChooseButton.userInteractionEnabled = false
        print("timechoosebuttin.enabled is \(timeChooseButton.enabled)")
        timeInputView.disableInput()
    }

    func setpicker() {
        let ticksleft = tickschosen - tickaccum
        let lowtick = ticksleft % 60
        let hightick = ticksleft / 60
        print("ticks remaining: ", ticksleft, " (\(tickschosen) - \(tickaccum)) ", String(format: "(%d:%02d)", hightick, lowtick))
        timeInputView.setwheels(hightick, secs: lowtick)
    }

    func setpickerto(min: Int, sec: Int) {
        print("setpickerto \(min) \(sec)");
        timeInputView.setwheels(min, secs: sec)
    }
    func setpickerto(ticks: Int) {
        let min = ticks / 60
        let sec = ticks % 60
        print("setpickerto \(ticks) ticks = \(min):\(sec)");
        timeInputView.setwheels(min, secs: sec)
    }

    func tickCB(ticks: Int) -> Bool {
        print("Tock! (", ticks, ") ", curtime());
        tickaccum += ticks
        print("Accumulated \(tickaccum) of \(tickschosen)")
        self.setpicker()
        self.imageView.coverPercent(100.0 * Float(tickaccum) / Float(tickschosen))
        if (tickaccum >= tickschosen) {
            // We're done!
            tickaccum = 0;
            setDoneState()
            return false
        }
        return true
    }

    func timeChosenCB() -> Bool {
        let nticks = timeInputView.ticksecs();
        print("New time chosen \(nticks) replaces \(tickschosen)");
        tickschosen = nticks;
        setpickerto(tickschosen / 60, sec: tickschosen % 60)
        tickaccum = 0
        setReadyState()
        return true;
    }

    // MARK: Scene navigation
    @IBAction func cancelToMainViewController(segue:UIStoryboardSegue) {
        print("Cancel time set - segue ", segue.identifier)
    }

    @IBAction func saveTime(segue:UIStoryboardSegue) {
        print("Set time - segue ", segue.identifier)
        if let choosetime  = segue.sourceViewController as? chooseTimeTableViewController {
            print("segue source: ", choosetime)
            let timechosen = choosetime.getChosenTime()
            print("chosen time: ", timechosen)
            if (0 < timechosen) {
                setpickerto(timechosen / 60, sec: timechosen % 60)
                print("Set ready state")
                setReadyState()
            }
        }
    }

    // MARK: Actions

    @IBAction func goButtonPressed(sender: UIButton) {
        if (timeInputView.ticksecs() == 0) {
            print("NO counting to do!");
            return
        }
        print("Go: Ticknow: ", curtime())
        if (!ticker.tickRunning) {
            ticker.tickStart()
            // Don't pick from there! Just use timeinputview as the tick keeper, dump tickschosen/tickaccum
            if (0 == tickaccum) {
                tickschosen = timeInputView.ticksecs()
                timeInputView.disableInput()
                // Hack
                // tickaccum = 0
                print("Counting from ", tickschosen);
            }
            enterTimeLabel.text = "Running!"
            sender.setTitle("Pause", forState: .Normal)
        } else {
            ticker.tickStop()
            enterTimeLabel.text = "Paused"
            sender.setTitle("Resume", forState: .Normal)
        }
    }
    @IBAction func resetButtonPressed(sender: AnyObject) {
        if ticker.tickRunning { ticker.tickStop() }
        tickaccum = 0
        setpickerto(tickschosen / 60, sec: tickschosen % 60)
        setReadyState()
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

