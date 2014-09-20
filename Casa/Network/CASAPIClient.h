//
//  CASAPIClient.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const CASAPILimitKey = @"CASAPILimitKey";
NSString * const CASAPIOffsetKey = @"CASAPIOffsetKey";

NSString * const CASAPILatitudeKey = @"CASAPILatitudeKey";
NSString * const CASAPILongitudeKey = @"CASAPILongitudeKey";
NSString * const CASAPIRadiusKey = @"CASAPIRadiusKey";
NSString * const CASAPIMinPriceKey = @"CASAPIMinPriceKey";
NSString * const CASAPIMaxPriceKey = @"CASAPIMaxPriceKey";
NSString * const CASAPITagsKey = @"CASAPITagsKey";
NSString * const CASAPIAddressKey = @"CASAPIAddressKey";

NSString * const CASAPIEmailKey = @"CASAPIEmailKey";
NSString * const CASAPIPasswordKey = @"CASAPIPasswordKey";

NSString * const CASAPITokenKey = @"CASAPITokenKey";
NSString * const CASAPIExpiresInKey = @"CASAPIExpiresInKey";

@protocol CASAPIClient <NSObject>

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
- (BFTask *)logoutWithParams:(NSDictionary *)params;

/**
 * User
 */
- (BFTask *)signupUserWithParams:(NSDictionary *)params;
- (BFTask *)getUserWithId:(NSNumber *)userId;
- (BFTask *)updateUserWithId:(NSNumber *)userId withParams:(NSDictionary *)params;

/**
 * Bookmarks
 */
- (BFTask *)getBookmarksWithParams:(NSDictionary *)params;
- (BFTask *)createBookmarkWithParams:(NSDictionary *)params;
- (BFTask *)getBookmarkWithId:(NSNumber *)bookmarkId;
- (BFTask *)deleteBookmarkWithId:(NSNumber *)bookmarkId;

@end
