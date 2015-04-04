/**
 * Copyright (c) 2015 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the MIT License
 * Please see the LICENSE included with this distribution for details.
 *
 */

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
- (IBAction)subtractCountHandler:(UIButton *)sender;
- (IBAction)addCountHandler:(UIButton *)sender;
@end
