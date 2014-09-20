//
//  CASServiceLocator.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASServiceLocator.h"

@implementation CASServiceLocator

+ (instancetype)sharedInstance
{
    static CASServiceLocator *s_locator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_locator = [[CASServiceLocator alloc] init];
    });
    return s_locator;
}

@end
