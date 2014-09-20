//
//  CASUser.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASUser.h"

static NSString * const CASUserIdKey = @"CASUserIdKey";
static NSString * const CASNameKey = @"CASNameKey";
static NSString * const CASEmailKey = @"CASEmailKey";

@implementation CASUser

+ (instancetype)loadState
{
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:CASUserIdKey];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:CASNameKey];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:CASEmailKey];
    
    if (userId && name && email) {
        CASUser *user = [[CASUser alloc] init];
        user.userId = userId;
        user.name = name;
        user.email = email;
        return user;
    }
    
    return nil;
}

+ (void)removeState
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CASUserIdKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CASNameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CASEmailKey];
}

- (void)saveState
{
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:CASUserIdKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:CASNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:CASEmailKey];
}

@end
