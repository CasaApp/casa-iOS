//
//  CASServiceLocator.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CASSubletService;
@class CASUserService;

@interface CASServiceLocator : NSObject

@property (nonatomic, strong) CASSubletService *subletService;
@property (nonatomic, strong) CASUserService *userService;

+ (instancetype)sharedInstance;

@end
