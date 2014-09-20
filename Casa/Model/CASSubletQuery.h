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
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *radius;
@property (nonatomic, strong) NSNumber *minimumPrice;
@property (nonatomic, strong) NSNumber *maximumPrice;
@property (nonatomic, copy) NSArray *tags;

@end
