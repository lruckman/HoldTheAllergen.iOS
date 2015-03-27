//
//  Restaurant.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/5/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

@synthesize name;
@synthesize logo;
@synthesize logoIcon;
@synthesize menuDataSource;
@synthesize allergyFreeMenuDataSource;
@synthesize restaurantId;
@synthesize menu;

- (id) initWithRestaurantId:(int)_restaurantId andLogo:(NSString *) _logo                                           andMenuDataSource:(NSString *)_menuDataSource andAllergyFreeMenuDataSource:(NSString *) _allergyFreeMenuDataSource andName:(NSString *) _name
{
    self = [self init];
    if (!self) return nil;
    
    self.name=_name;
    self.logo=_logo;
    self.menuDataSource=_menuDataSource;
    self.allergyFreeMenuDataSource=_allergyFreeMenuDataSource;
    self.restaurantId=_restaurantId;
    return self;
}

@end
