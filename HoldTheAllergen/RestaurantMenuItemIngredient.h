//
//  RestaurantMenuItemIngredients.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/18/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantMenuItemIngredient : NSObject {
    NSString* description;
    NSString* allergenNames;
    NSString* name;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *allergenNames;
@property (nonatomic, retain) NSString *description;

- (id) initWithName:(NSString *) _name andAllergenNames:(NSString *) _allergenNames andDescription:(NSString *) _description;

@end


//{"Key":"2 Items you can have","Value":[{"AllergenNames":"","Description":"Water, Canola Oil, Modified Corn Starch, Cheddar Cheese (milk, cheese cultures, salt, enzymes), Maltodextrin, Contains 2% or less of the following: Salt, Sodium Phosphate, Nonfat Dry Milk, Sodium Citrate, Yeast Extract, Acetic Acid, Sodium Stearoyl lactylate, Sodium Hexametaphosphate, \u000d\u000aMono and Diglycerides, Annatto Color, Citric Acid, Cream, Natural Flavors, Paprika Color, Carotenal Color, Yellow 6.","Name":"Cheddar Cheese Sauce"}