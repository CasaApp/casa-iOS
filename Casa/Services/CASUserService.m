//
//  CASUserService.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASUserService.h"
#import "CASAPIClient.h"
#import "CASUser.h"

@interface CASUserService ()

@property (nonatomic, strong) CASUser *loggedInUser;
@property (nonatomic, strong) id<CASAPIClient> apiClient;

@end

@implementation CASUserService

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient
{
    if (self = [super init]) {
        _apiClient = apiClient;
        
        self.loggedInUser = [CASUser loadState];
    }
    return self;
}

- (BFTask *)loginWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *params = @{ CASAPIEmailKey: email,
                              CASAPIPasswordKey: password };
    
    return [[self.apiClient loginWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        NSDictionary *userJson = task.result[CASAPIUserKey];
        CASUser *user = [[CASUser alloc] init];
        user.name = userJson[CASAPINameKey];
        user.email = userJson[CASAPIEmailKey];
        user.userId = userJson[CASAPIUserIdKey];
        [user saveState];
        
        return nil;
    }];
}

- (BFTask *)logout
{
    return [[self.apiClient logout] continueWithSuccessBlock:^id(BFTask *task) {
        [CASUser removeState];
        
        return nil;
    }];
}

@end
