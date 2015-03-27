//
//  AllergiesViewController.h
//  HoldTheAllergen
//
//  Created by lruckman on 9/2/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllergiesViewController : UIViewController<UITableViewDelegate,
UIScrollViewDelegate, UITableViewDataSource> {    
    IBOutlet UITableView *allergyTableView;
    IBOutlet UIView *titleView;
    NSMutableArray *allergens;
}

@property (nonatomic, retain) UITableView *allergyTableView;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, strong) NSMutableArray *allergens;

-(IBAction)setAllergiesButton:(id)sender;

@end
