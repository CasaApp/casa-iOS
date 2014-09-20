//
//  CASAuthenticationService.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASAuthenticationService.h"
#import "CASAPIClient.h"

@interface CASAuthenticationService ()

@property (nonatomic, strong) id<CASAPIClient> apiClient;

@end

@implementation CASAuthenticationService

+ (instancetype)authenticationServiceWithApiClient:(id<CASAPIClient>)apiClient
{
    return [[self alloc] initWithApiClient:apiClient];
}

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient
{
    if (self = [super init]) {
        _apiClient = apiClient;
    }
    return self;
}

- (BFTask *)loginWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *params = @{ CASAPIEmailKey: email,
                              CASAPIPasswordKey: password };
    
    return [self.apiClient loginWithParams:params];
}

- (BFTask *)logout
{
    return [self.apiClient logout];
}

@end
