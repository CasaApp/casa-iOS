//
//  CASSubletService.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASSubletService.h"
#import "CASAPIClient.h"
#import "CASSubletQuery.h"
#import "CASUserService.h"
#import "CASSublet.h"

@interface CASSubletService ()

@property (nonatomic, strong) id<CASAPIClient> apiClient;
@property (nonatomic, strong) CASUserService *userService;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CASSubletService

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient userService:(CASUserService *)userService
{
    if (self = [super init]) {
        _apiClient = apiClient;
        _userService = userService;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-d";
    }
    return self;
}

- (CASSublet *)subletWithJson:(NSDictionary *)subletJson
{
    NSString *startDateString = subletJson[CASAPIStartDateKey];
    NSString *endDateString = subletJson[CASAPIEndDateKey];
    
    CASSublet *sublet = [[CASSublet alloc] init];
    sublet.subletId = subletJson[CASAPISubletIdKey];
    sublet.price = subletJson[CASAPIPriceKey];
    sublet.address = subletJson[CASAPIAddressKey];
    sublet.city = subletJson[CASAPICityKey];
    sublet.roomsAvailable = subletJson[CASAPIRoomsAvailableKey];
    sublet.totalRooms = subletJson[CASAPITotalRoomsKey];
    sublet.startDate = [self.dateFormatter dateFromString:startDateString];
    sublet.endDate = [self.dateFormatter dateFromString:endDateString];
    sublet.description = subletJson[CASAPIDescriptionKey];
    sublet.tags = subletJson[CASAPITagsKey];
    
    return sublet;
}

- (BFTask *)parseSubletJsonFromTask:(BFTask *)task
{
    return [task continueWithSuccessBlock:^id(BFTask *task) {
        return [self subletWithJson:task.result];
    }];
}

- (BFTask *)getSubletsWithQuery:(CASSubletQuery *)query
{
    NSDictionary *params = @{ CASAPIOffsetKey: query.offset,
                              CASAPILimitKey: query.limit,
                              CASAPILatitudeKey: query.latitude,
                              CASAPILongitudeKey: query.longitude,
                              CASAPIRoomsAvailableKey: query.roomsAvailable,
                              CASAPITotalRoomsKey: query.totalRooms,
                              CASAPIMinPriceKey: query.minimumPrice,
                              CASAPIMaxPriceKey: query.maximumPrice,
                              CASAPITagsKey: query.tags };
    
    return [[self.apiClient getSubletsWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        return _.array(task.result)
          .map(^CASSublet *(NSDictionary *subletJson) {
              return [self subletWithJson:subletJson];
          })
          .unwrap;
    }];
}

- (BFTask *)createSubletWithLatitude:(NSNumber *)latitude
                           longitude:(NSNumber *)longitude
                             address:(NSString *)address
                                city:(NSString *)city
                               price:(NSNumber *)price
                      roomsAvailable:(NSNumber *)roomsAvailable
                          totalRooms:(NSNumber *)totalRooms
                           startDate:(NSDate *)startDate
                             endDate:(NSDate *)endDate
                                tags:(NSArray *)tags
{
    NSDictionary *params = @{ CASAPILatitudeKey: latitude,
                              CASAPILongitudeKey: longitude,
                              CASAPIAddressKey: address,
                              CASAPICityKey: city,
                              CASAPIPriceKey: price,
                              CASAPIRoomsAvailableKey: roomsAvailable,
                              CASAPITotalRoomsKey: totalRooms,
                              CASAPIStartDateKey: startDate,
                              CASAPIEndDateKey: endDate,
                              CASAPITagsKey: tags };
    
    return [self parseSubletJsonFromTask:[self.apiClient createSubletWithParams:params]];
}

- (BFTask *)getSubletWithId:(NSNumber *)subletId
{
    return [self parseSubletJsonFromTask:[self.apiClient getSubletWithId:subletId]];
}

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
                    tags:(NSArray *)tags
{
    NSDictionary *params = @{ CASAPILatitudeKey: latitude,
                              CASAPILongitudeKey: longitude,
                              CASAPIAddressKey: address,
                              CASAPICityKey: city,
                              CASAPIPriceKey: price,
                              CASAPIRoomsAvailableKey: roomsAvailable,
                              CASAPITotalRoomsKey: totalRooms,
                              CASAPIStartDateKey: startDate,
                              CASAPIEndDateKey: endDate,
                              CASAPITagsKey: tags };
    
    return [self parseSubletJsonFromTask:[self.apiClient updateSubletWithId:sublet.subletId withParams:params]];
}

- (BFTask *)deleteSubletWithId:(NSNumber *)subletId
{
    return [self.apiClient deleteSubletWithId:subletId];
}

@end
