/**
* Copyright (c) 2015 by Benjamin Bahrenburg. All Rights Reserved.
* Licensed under the terms of the MIT License
* Please see the LICENSE included with this distribution for details.
*
*/

import UIKit
import NotificationCenter
import Foundation

let sampleGroupIdentifier = "group.appworkbench.TodayExtenionWormhole";
let sampleWormDirectory = "tiwormhole";
let sampleEventName = "wormEvent";
let sampleFieldName = "displayNumber";

class TodayViewController: UIViewController, NCWidgetProviding {
 
    var displayCount = 0;
    let wormhole = MMWormhole(applicationGroupIdentifier: sampleGroupIdentifier,
                                        optionalDirectory: sampleWormDirectory)
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 50);
        addMessageListener(sampleEventName)
        initDisplayCounter(sampleEventName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(NCUpdateResult.newData)
        
    }
 
    func addMessageListener(_ eventName : String) {
        self.wormhole.listenForMessage(withIdentifier: eventName, listener: { (messageObject) -> Void in
            let message = messageObject as! Dictionary<String, Any>
            if let fieldCount: AnyObject = message[sampleFieldName] as AnyObject? {
                self.displayCount = fieldCount as! Int
                self.displayCounter()
            }
        })
    }
    
    func initDisplayCounter(_ eventName:String){
        let savedMessage: Dictionary? = wormhole.message(withIdentifier:eventName) as! Dictionary<String, Any>?

         if let fieldCount: Any?  = savedMessage?[sampleFieldName] as Any?? {
            self.displayCount = fieldCount as! Int!
            self.displayCounter()
        }
    }
    
    func updateCounter() {
        wormhole.passMessageObject([sampleFieldName : displayCount] as NSCoding?, identifier: sampleEventName)
        displayCounter()
    }
    
    func displayCounter() {
        self.countLabel.text = "Count:" + String(displayCount)
    }
    
    @IBAction func addCountHandler(_ sender: UIButton) {
        displayCount += 1;
        updateCounter()
    }
    
    @IBAction func subtractCountHandler(_ sender: UIButton) {
        displayCount -= 1;
        updateCounter()
    }
    
}
