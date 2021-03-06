//
//  CASUserService.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CASAPIClient;
@class CASUser;

@interface CASUserService : NSObject

@property (nonatomic, strong, readonly) CASUser *loggedInUser;

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient;

- (BFTask *)loginWithEmail:(NSString *)email password:(NSString *)password;
- (BFTask *)logout;

- (BFTask *)signupWithName:(NSString *)name email:(NSString *)email password:(NSString *)password;
- (BFTask *)getUserWithId:(NSNumber *)userId;
- (BFTask *)updateUserWithName:(NSString *)name currentPassword:(NSString *)currentPassword;
- (BFTask *)updateUserWithPassword:(NSString *)password currentPassword:(NSString *)currentPassword;

@end
