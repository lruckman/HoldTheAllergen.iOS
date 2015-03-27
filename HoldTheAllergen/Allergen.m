//
//  Allergen.m
//  HoldTheAllergen
//
//  Created by lruckman on 9/2/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "Allergen.h"

@implementation Allergen

@synthesize allergenId;
@synthesize name;
@synthesize selectAction;
@synthesize selected;

- (id) initWithAllergenId:(int)_allergenId andName:(NSString *) _name                                           andSelected:(BOOL) _selected andSelectAction:(NSString *) _selectAction
{
    self = [self init];
    if (!self) return nil;
    
    self.name=_name;
    self.allergenId=_allergenId;
    self.selected=_selected;
    self.selectAction=_selectAction;
    return self;
}

@end
