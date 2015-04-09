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
    let wormhole = MMWormholeClient(applicationGroupIdentifier: sampleGroupIdentifier,
                                        optionalDirectory: sampleWormDirectory)
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(320, 50);
        addMessageListener(sampleEventName)
        initDisplayCounter(sampleEventName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
 
    func addMessageListener(eventName : String){
        self.wormhole.listenForMessageWithIdentifier(eventName, listener:{(messageObject:AnyObject!) -> Void in
            if((messageObject[sampleFieldName]) != nil){
                self.displayCount = messageObject[sampleFieldName] as! Int!
                self.displayCounter()
            }
        })
    }
    
    func initDisplayCounter(eventName:String){
        let savedMessage: AnyObject? = wormhole.messageWithIdentifier(eventName);
        if((savedMessage?[sampleFieldName]) != nil){
            self.displayCount = savedMessage?[sampleFieldName] as! Int!
            self.displayCounter()
        }
    }
    
    func updateCounter(){
        wormhole.passMessageObject([sampleFieldName : displayCount], identifier: sampleEventName)
        displayCounter()
    }
    
    func displayCounter() {
        self.countLabel.text = "Count:" + String(displayCount)
    }
    
    @IBAction func addCountHandler(sender: UIButton) {
        displayCount++;
        updateCounter()
    }
    
    @IBAction func subtractCountHandler(sender: UIButton) {
        displayCount--;
        updateCounter()
    }
    
}
