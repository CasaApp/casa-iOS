//
//  CASToken.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASToken.h"

static NSString * const CASTokenKey = @"CASToken";
static NSString * const CASExpiryDateKey = @"CASExpiryDate";

@implementation CASToken

+ (instancetype)loadState
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:CASTokenKey];
    NSDate *expiryDate = [[NSUserDefaults standardUserDefaults] objectForKey:CASExpiryDateKey];
    
    if (token && expiryDate) {
        CASToken *tokenObj = [[CASToken alloc] init];
        tokenObj.token = token;
        tokenObj.expiryDate = expiryDate;
        return tokenObj;
    }
    
    return nil;
}

+ (void)removeState
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CASTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CASExpiryDateKey];
}

- (void)saveState
{
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:CASTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.expiryDate forKey:CASExpiryDateKey];
}

@end
