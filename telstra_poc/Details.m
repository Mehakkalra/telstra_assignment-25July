//
//  Details.m
//  telstra_poc
//
//  Created by Mehak Kalra on 25/07/17.
//  Copyright © 2017 Mehak Kalra. All rights reserved.
//

#import "Details.h"

@implementation Details


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self==nil) {
        return nil;
    }
    else
    {
        _detailTitle = dictionary[@"title"];
        _detailURL = dictionary[@"imageHref"];
        _detailDescription = dictionary[@"description"];
    }
    return self;
}


@end
