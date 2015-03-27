//
//  RestaurantMenuViewController.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/12/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantMenuViewController : UIViewController<UITableViewDelegate,
UIScrollViewDelegate, UITableViewDataSource, UITabBarDelegate> {
    IBOutlet UITableView *menuTableView;
    IBOutlet UITabBar *menuTabBar;
}

@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, retain) NSArray *sortedKeys;
@property (nonatomic, retain) UITabBar *menuTabBar;

@end
