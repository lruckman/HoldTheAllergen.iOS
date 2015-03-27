//
//  AppDelegate.h
//  HoldTheAllergen
//
//  Created by lruckman on 7/28/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (NSString *) getUid;
- (BOOL) hasSeenEULA;
- (void)setSeenEULA;

@property (strong, nonatomic) UIWindow *window;

@end
