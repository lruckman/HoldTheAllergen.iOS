//
//  RestaurantMenuItemViewController.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/18/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "RestaurantMenuItem.h"

@interface RestaurantMenuItemViewController : UIViewController<UITableViewDelegate,
UIScrollViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* ingredientTableView;
    IBOutlet UIImageView* logoImageView;
    IBOutlet UILabel* restaurantNameLabel;
    IBOutlet UILabel* menuItemNameLabel;
}

@property (nonatomic, retain) UIImageView* logoImageView;
@property (nonatomic, retain) UILabel* restaurantNameLabel;
@property (nonatomic, retain) UILabel* menuItemNameLabel;
@property (nonatomic, retain) UITableView* ingredientTableView;
@property (nonatomic, strong) Restaurant* restaurant;
@property (nonatomic, strong) RestaurantMenuItem* restaurantMenuItem;

@end
