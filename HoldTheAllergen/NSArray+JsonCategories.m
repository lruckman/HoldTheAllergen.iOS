//
//  NSArray+JsonCategories.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/4/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "NSArray+JsonCategories.h"

@implementation NSArray (JsonCategories)
+(NSArray*)dictionaryWithContentsOfJSONURLString:
(NSURL*)urlAddress
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlAddress];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-Length"];
    
    __autoreleasing NSError* error = nil;
    NSURLResponse *response =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error != nil) return nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
