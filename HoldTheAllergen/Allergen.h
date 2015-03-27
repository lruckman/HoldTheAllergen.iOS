//
//  Allergen.h
//  HoldTheAllergen
//
//  Created by lruckman on 9/2/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Allergen : NSObject
{
    int allergenId;
    NSString * name;
    BOOL selected;
    NSString * selectAction;
}

@property (nonatomic) int allergenId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* selectAction;
@property (nonatomic) BOOL selected;

- (id) initWithAllergenId:(int)_allergenId andName:(NSString *) _name                                           andSelected:(BOOL) _selected andSelectAction:(NSString *) _selectAction;

@end

