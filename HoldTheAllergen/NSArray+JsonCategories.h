//
//  NSArray+JsonCategories.h
//  HoldTheAllergen
//
//  Created by lruckman on 8/4/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JsonCategories)
+(NSArray*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end
