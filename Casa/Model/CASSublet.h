//
//  CASSublet.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SubletTagNoPets = 1
} SubletTag;

@interface CASSublet : NSObject

@property (nonatomic, strong) NSNumber *subletId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSArray *tags;

@end
