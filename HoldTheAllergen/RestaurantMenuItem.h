//
//  MenuItem.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/12/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantMenuItem : NSObject {
    NSString* dataSource;
    NSString* allergenNames;
    int menuItemId;
    NSString* name;
    NSMutableDictionary* ingredients;
}

@property (nonatomic) int menuItemId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *allergenNames;
@property (nonatomic, retain) NSString *dataSource;
@property (nonatomic, retain) NSMutableDictionary *ingredients;

- (id) initWithMenuItemId:(int)_menuItemId andName:(NSString *) _name                                           andAllergenNames:(NSString *) _allergenNames andDataSource:(NSString *) _dataSource;

@end

//CategoryName":"Arby's® Roast Beef Sandwiches"
//"Items":[{
//    "Action":"http:\/\/api.holdtheallergen.com\/3e6e15b9-89aa-4ee1-8141-93764e766f69\/menuitem\/970\/ingredients",
//      "AllergenNames":"Soybean Oil",
//      "Id":970,
//      "Name":"Arby’S Sauce®",
//      "StarAction":"http:\/\/api.holdtheallergen.com\/3e6e15b9-89aa-4ee1-8141-93764e766f69\/menuitem\/970\/star",
//      "Starred":false
