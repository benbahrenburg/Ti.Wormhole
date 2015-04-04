/**
 * Copyright (c) 2015 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the MIT License
 * Please see the LICENSE included with this distribution for details.
 *
 */

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MMWormholeClient.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) MMWormholeClient *wormhole;
@property (nonatomic, strong) NSNumber *displayCount;

extern NSString * const SampleGroupIdentifier;
extern NSString * const SampleEventName;
extern NSString * const SampleWormDirectory;
extern NSString * const SampleFieldName;

@end

@implementation TodayViewController

NSString * const SampleGroupIdentifier = @"group.appworkbench.TodayExtenionWormhole";
NSString * const SampleEventName = @"wormEvent";
NSString * const SampleWormDirectory = @"tiwormhole";
NSString * const SampleFieldName = @"displayNumber";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 50);
    self.wormhole = [[MMWormholeClient alloc] initWithApplicationGroupIdentifier:SampleGroupIdentifier
                                                               optionalDirectory:SampleWormDirectory];
    [self initDisplayCounter:SampleEventName];
    [self addMessageListener:SampleEventName];
}

-(void) initDisplayCounter:(NSString*) eventName
{
    _displayCount = [NSNumber numberWithInt:0];
    id messageObject = [self.wormhole messageWithIdentifier:eventName];
    if([messageObject objectForKey:SampleFieldName]){
        _displayCount = [messageObject valueForKey:SampleFieldName];
    }
    [self displayCounter];
}

-(void) displayCounter
{
    self.countLabel.text = [NSString stringWithFormat:@"Count: %li", (long)[_displayCount integerValue]];
}

-(void) updateCounter
{
    NSLog(@"[INFO] Posting event %@ from your extension",SampleEventName);
    [self.wormhole passMessageObject:@{SampleFieldName : _displayCount} identifier:SampleEventName];
    [self displayCounter];
}

-(void) addMessageListener:(NSString*) eventName
{
    // Become a listener for changes to the wormhole for the button message
    [self.wormhole listenForMessageWithIdentifier:eventName listener:^(id messageObject) {
        NSLog(@"[INFO] Event %@ in your extension %@",eventName,messageObject);
        // The number is identified with the displayNumber key in the message object
        _displayCount = [messageObject valueForKey:SampleFieldName];
        // Next we need to update the display counter
        [self displayCounter];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)subtractCountHandler:(UIButton *)sender
{
    _displayCount = [NSNumber numberWithInt:(int)[_displayCount integerValue] -1];
    [self updateCounter];
}

- (IBAction)addCountHandler:(UIButton *)sender
{
    _displayCount = [NSNumber numberWithInt:(int)[_displayCount integerValue] + 1];
    [self updateCounter];
}

@end
