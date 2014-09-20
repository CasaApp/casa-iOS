//
//  CASAPIClient.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const CASAPILimitKey = @"limit";
NSString * const CASAPIOffsetKey = @"offset";

NSString * const CASAPILatitudeKey = @"latitude";
NSString * const CASAPILongitudeKey = @"longitude";
NSString * const CASAPIRadiusKey = @"radius";
NSString * const CASAPIMinPriceKey = @"minimum_price";
NSString * const CASAPIMaxPriceKey = @"maximum_price";
NSString * const CASAPITagsKey = @"tags";
NSString * const CASAPIAddressKey = @"address";

NSString * const CASAPIEmailKey = @"email";
NSString * const CASAPIPasswordKey = @"password";

NSString * const CASAPITokenKey = @"token";
NSString * const CASAPIExpiresInKey = @"expires_in";

NSString * const CASAPISubletIdKey = @"sublet_id";

@class CASToken;

@protocol CASAPIClient <NSObject>

@property (nonatomic, strong, readonly) CASToken *token;

/**
 * Sublets
 */
- (BFTask *)getSubletsWithParams:(NSDictionary *)params;
- (BFTask *)createSubletWithParams:(NSDictionary *)params;
- (BFTask *)getSubletWithId:(NSNumber *)subletId;
- (BFTask *)updateSubletWithId:(NSNumber *)subletId withParams:(NSDictionary *)params;
- (BFTask *)deleteSubletWithId:(NSNumber *)subletId;

/**
 * Authentication
 */
- (BFTask *)loginWithParams:(NSDictionary *)params;
- (BFTask *)logout;

/**
 * User
 */
- (BFTask *)signupUserWithParams:(NSDictionary *)params;
- (BFTask *)getUserWithId:(NSNumber *)userId;
- (BFTask *)updateUserWithId:(NSNumber *)userId withParams:(NSDictionary *)params;

/**
 * Bookmarks
 */
- (BFTask *)getBookmarksForUserWithId:(NSNumber *)userId params:(NSDictionary *)params;
- (BFTask *)createBookmarkForUserWithId:(NSNumber *)userId subletId:(NSNumber *)subletId;
- (BFTask *)deleteBookmarkForUserWithId:(NSNumber *)userId subletId:(NSNumber *)subletId;

@end
