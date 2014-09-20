//
//  CASAuthenticationService.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CASAPIClient;

@interface CASAuthenticationService : NSObject

+ (instancetype)authenticationServiceWithApiClient:(id<CASAPIClient>)apiClient;
- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient;

- (BFTask *)loginWithEmail:(NSString *)email password:(NSString *)password;
- (BFTask *)logout;

@end
