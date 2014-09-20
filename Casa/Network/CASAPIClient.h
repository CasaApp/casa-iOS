//
//  CASAPIClient.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CASAPILimitKey;
extern NSString * const CASAPIOffsetKey;

extern NSString * const CASAPILatitudeKey;
extern NSString * const CASAPILongitudeKey;
extern NSString * const CASAPIRadiusKey;
extern NSString * const CASAPIPriceKey;
extern NSString * const CASAPIMinPriceKey;
extern NSString * const CASAPIMaxPriceKey;
extern NSString * const CASAPITagsKey;
extern NSString * const CASAPIAddressKey;
extern NSString * const CASAPIStartDateKey;
extern NSString * const CASAPIEndDateKey;
extern NSString * const CASAPIDescriptionKey;

extern NSString * const CASAPIUserKey;
extern NSString * const CASAPIUserIdKey;
extern NSString * const CASAPIEmailKey;
extern NSString * const CASAPINameKey;
extern NSString * const CASAPIPasswordKey;
extern NSString * const CASAPICurrentPasswordKey;

extern NSString * const CASAPITokenKey;
extern NSString * const CASAPIExpiresInKey;

extern NSString * const CASAPISubletIdKey;

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
