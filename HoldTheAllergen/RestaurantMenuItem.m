//
//  MenuItem.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/12/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "RestaurantMenuItem.h"

@implementation RestaurantMenuItem

@synthesize name;
@synthesize menuItemId;
@synthesize dataSource;
@synthesize allergenNames;
@synthesize ingredients;

- (id) initWithMenuItemId:(int)_menuItemId andName:(NSString *) _name                                           andAllergenNames:(NSString *) _allergenNames andDataSource:(NSString *) _dataSource;
{
    self = [self init];
    if (!self) return nil;
    
    self.name=_name;
    self.menuItemId=_menuItemId;
    self.dataSource=_dataSource;
    self.allergenNames=_allergenNames;
    return self;
}

@end
