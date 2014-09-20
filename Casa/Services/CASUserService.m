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

- (void)handleUserJson:(NSDictionary *)userJson
{
    self.loggedInUser = [self userWithJson:userJson];
    [self.loggedInUser saveState];
}

- (CASUser *)userWithJson:(NSDictionary *)userJson
{
    CASUser *user = [[CASUser alloc] init];
    user.name = userJson[CASAPINameKey];
    user.email = userJson[CASAPIEmailKey];
    user.userId = userJson[CASAPIUserIdKey];
    return user;
}

- (BFTask *)parseUserJsonFromTask:(BFTask *)task
{
    return [task continueWithSuccessBlock:^id(BFTask *task) {
        return [self userWithJson:task.result];
    }];
}

- (BFTask *)loginWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *params = @{ CASAPIEmailKey: email,
                              CASAPIPasswordKey: password };
    
    return [[self.apiClient loginWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        [self handleUserJson:task.result[CASAPIUserKey]];
        
        return self.loggedInUser;
    }];
}

- (BFTask *)logout
{
    return [[self.apiClient logout] continueWithSuccessBlock:^id(BFTask *task) {
        self.loggedInUser = nil;
        [CASUser removeState];
        
        return nil;
    }];
}

- (BFTask *)signupWithName:(NSString *)name email:(NSString *)email password:(NSString *)password
{
    NSDictionary *params = @{ CASAPINameKey: name,
                              CASAPIEmailKey: email,
                              CASAPIPasswordKey: password };
    
    return [[self.apiClient signupUserWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        [self handleUserJson:task.result[CASAPIUserKey]];
        
        return self.loggedInUser;
    }];
}

- (BFTask *)getUserWithId:(NSNumber *)userId
{
    return [self parseUserJsonFromTask:[self.apiClient getUserWithId:userId]];
}

- (BFTask *)updateUserWithName:(NSString *)name currentPassword:(NSString *)currentPassword
{
    NSDictionary *params = @{ CASAPICurrentPasswordKey: currentPassword,
                              CASAPIPasswordKey: currentPassword,
                              CASAPINameKey: name,
                              CASAPIEmailKey: self.loggedInUser.email };
    
    return [self parseUserJsonFromTask:[self.apiClient updateUserWithId:self.loggedInUser.userId withParams:params]];
}

- (BFTask *)updateUserWithPassword:(NSString *)password currentPassword:(NSString *)currentPassword
{
    NSDictionary *params = @{ CASAPICurrentPasswordKey: currentPassword,
                              CASAPIPasswordKey: password,
                              CASAPINameKey: self.loggedInUser.name,
                              CASAPIEmailKey: self.loggedInUser.email };
    
    return [self parseUserJsonFromTask:[self.apiClient updateUserWithId:self.loggedInUser.userId withParams:params]];
}

@end
