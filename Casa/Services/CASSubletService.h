//
//  CASSubletService.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CASAPIClient;
@class CASUserService;
@class CASSubletQuery;
@class CASSublet;

@interface CASSubletService : NSObject

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient userService:(CASUserService *)userService;

- (BFTask *)getSubletsWithQuery:(CASSubletQuery *)query;
- (BFTask *)createSubletWithLatitude:(NSNumber *)latitude
                           longitude:(NSNumber *)longitude
                             address:(NSString *)address
                                city:(NSString *)city
                               price:(NSNumber *)price
                      roomsAvailable:(NSNumber *)roomsAvailable
                          totalRooms:(NSNumber *)totalRooms
                           startDate:(NSDate *)startDate
                             endDate:(NSDate *)endDate
                                tags:(NSArray *)tags;
- (BFTask *)getSubletWithId:(NSNumber *)subletId;
- (BFTask *)updateSublet:(CASSublet *)sublet
            withLatitude:(NSNumber *)latitude
               longitude:(NSNumber *)longitude
                 address:(NSString *)address
                    city:(NSString *)city
                   price:(NSNumber *)price
          roomsAvailable:(NSNumber *)roomsAvailable
              totalRooms:(NSNumber *)totalRooms
               startDate:(NSDate *)startDate
                 endDate:(NSDate *)endDate
                    tags:(NSArray *)tags;
- (BFTask *)deleteSubletWithId:(NSNumber *)subletId;

- (BFTask *)getBookmarksWithOffset:(NSNumber *)offset limit:(NSNumber *)limit;
- (BFTask *)createBookmarkForSubletId:(NSNumber *)subletId;
- (BFTask *)deleteBookmarkForSubletId:(NSNumber *)subletId;

@end
