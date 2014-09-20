//
//  CASSublet.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASSublet.h"

@implementation CASSublet

- (id)copy
{
    CASSublet *sublet = [[CASSublet alloc] init];
    sublet.subletId = self.subletId;
    sublet.price = self.price;
    sublet.address = self.address;
    sublet.startDate = self.startDate;
    sublet.endDate = self.endDate;
    sublet.description = self.description;
    sublet.tags = self.tags;
    return sublet;
}

@end
