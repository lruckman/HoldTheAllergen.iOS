//
//  RestaurantMenuItemIngredients.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/18/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "RestaurantMenuItemIngredient.h"

@implementation RestaurantMenuItemIngredient

@synthesize name;
@synthesize description;
@synthesize allergenNames;

- (id) initWithName:(NSString *) _name
   andAllergenNames:(NSString *) _allergenNames
     andDescription:(NSString *) _description {
    
    self = [self init];
    if (!self) return nil;
    
    self.name=_name;
    self.description=_description;
    self.allergenNames=_allergenNames;
    return self;
}

@end
