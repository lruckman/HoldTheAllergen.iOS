//
//  RootViewController.h
//  HoldTheAllergen
//
//  Created by lruckman on 7/28/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "AppDelegate.h"

@interface RootViewController : UIViewController<IconDownloaderDelegate,UIAlertViewDelegate> {
    NSMutableArray *restaurants;
    AppDelegate *appDelegate;
    int selectedIndex;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic) int selectedIndex;

- (void)appImageDidLoad:(int)itemIndex;

@end
