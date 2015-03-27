//
//  Restaurant.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/5/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//
@interface Restaurant : NSObject
{
}

@property (nonatomic) int restaurantId;
@property (nonatomic, retain) UIImage* logoIcon;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* logo;
@property (nonatomic, retain) NSString* menuDataSource;
@property (nonatomic, retain) NSString* allergyFreeMenuDataSource;
@property (nonatomic, retain) NSMutableDictionary* menu;

- (id) initWithRestaurantId:(int)_restaurantId andLogo:(NSString *) _logo                                           andMenuDataSource:(NSString *) _menuDataSource andAllergyFreeMenuDataSource:(NSString *) _allergyFreeMenuDataSource andName:(NSString *) _name;

@end
