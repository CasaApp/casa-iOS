//
//  CASSubletQuery.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASSubletQuery : NSObject

@property (nonatomic, strong) NSNumber *offset;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *radius;
@property (nonatomic, strong) NSNumber *roomsAvailable;
@property (nonatomic, strong) NSNumber *totalRooms;
@property (nonatomic, strong) NSNumber *minimumPrice;
@property (nonatomic, strong) NSNumber *maximumPrice;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSArray *tags;

@end
