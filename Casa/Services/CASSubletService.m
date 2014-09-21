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
#import "CASUser.h"
#import "CASGeoPoint.h"

@interface CASSubletService ()

@property (nonatomic, strong) id<CASAPIClient> apiClient;
@property (nonatomic, strong) CASUserService *userService;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableDictionary *sublets;

@end

@implementation CASSubletService

- (instancetype)initWithApiClient:(id<CASAPIClient>)apiClient userService:(CASUserService *)userService
{
    if (self = [super init]) {
        _apiClient = apiClient;
        _userService = userService;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-d";
        
        _sublets = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BFTask *)geoPointWithAddress:(NSString *)address
{
    return [[self.apiClient getGeoPointWithParams:@{@"address":address}] continueWithBlock:^id(BFTask *task) {
        NSDictionary *geoPointDict = task.result[@"results"][0][@"geometry"][@"location"];
        CASGeoPoint *geoPoint = [[CASGeoPoint alloc] init];
        geoPoint.latitude = geoPointDict[@"lat"];
        geoPoint.longitude = geoPointDict[@"lng"];
        return geoPoint;
    }];
}

- (CASSublet *)subletWithJson:(NSDictionary *)subletJson
{
    NSString *startDateString = subletJson[CASAPIStartDateKey];
    NSString *endDateString = subletJson[CASAPIEndDateKey];
    
    NSNumber *subletId = subletJson[CASAPISubletIdKey];
    
    CASSublet *sublet = self.sublets[subletId] ? self.sublets[subletId] : [[CASSublet alloc] init];
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
    sublet.latitude = subletJson[CASAPILatitudeKey];
    sublet.longitude = subletJson[CASAPILongitudeKey];
    sublet.imageIds = subletJson[CASAPIImageIdsKey];
    
    self.sublets[sublet.subletId] = sublet;
    
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
    return [[self geoPointWithAddress:query.address] continueWithBlock:^id(BFTask *task) {
        CASGeoPoint *geoPoint = task.result;
        NSDictionary *dict = @{ CASAPILatitudeKey: geoPoint.latitude,
                                CASAPILongitudeKey: geoPoint.longitude,
                                CASAPIStartDateKey: [self.dateFormatter stringFromDate:query.startDate],
                                CASAPIEndDateKey: [self.dateFormatter stringFromDate:query.endDate],
                                CASAPIRadiusKey: query.radius };
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        if (query.offset) {
            params[CASAPIOffsetKey] = query.offset;
        }
        if (query.limit) {
            params[CASAPILimitKey] = query.limit;
        }
        if (query.roomsAvailable) {
            params[CASAPIRoomsAvailableKey] = query.roomsAvailable;
        }
        if (query.totalRooms) {
            params[CASAPITotalRoomsKey] = query.totalRooms;
        }
        if (query.minimumPrice) {
            params[CASAPIMinPriceKey] = query.minimumPrice;
        }
        if (query.maximumPrice) {
            params[CASAPIMaxPriceKey] = query.maximumPrice;
        }
        if (query.tags) {
            params[CASAPITagsKey] = query.tags;
        }
        
        return [[self.apiClient getSubletsWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
            return _.array(task.result[@"sublets"])
            .map(^CASSublet *(NSDictionary *subletJson) {
                return [self subletWithJson:subletJson];
            })
            .unwrap;
        }];
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

- (BFTask *)getBookmarksWithOffset:(NSNumber *)offset limit:(NSNumber *)limit
{
    NSDictionary *params = @{ CASAPIOffsetKey: offset,
                              CASAPILimitKey: limit };
    return [[self.apiClient getBookmarksForUserWithId:self.userService.loggedInUser.userId params:params] continueWithSuccessBlock:^id(BFTask *task) {
        return _.array(task.result[@"sublets"])
        .map(^CASSublet *(NSDictionary *subletJson) {
            CASSublet *sublet = [self subletWithJson:subletJson];
            sublet.bookmarked = YES;
            return sublet;
        })
        .unwrap;
    }];
}

- (BFTask *)createBookmarkForSubletId:(NSNumber *)subletId
{
    return [self.apiClient createBookmarkForUserWithId:self.userService.loggedInUser.userId subletId:subletId];
}

- (BFTask *)deleteBookmarkForSubletId:(NSNumber *)subletId
{
    return [self.apiClient deleteBookmarkForUserWithId:self.userService.loggedInUser.userId subletId:subletId];
}

- (BFTask *)uploadImage:(UIImage *)image forSublet:(CASSublet *)sublet
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDictionary *params = @{@"image":imageData};
    
    return [self.apiClient uploadImageForSubletWithId:sublet.subletId params:params];
}

- (BFTask *)deleteImageWithId:(NSNumber *)imageId forSubletWithId:(NSNumber *)subletId
{
    return [self.apiClient deleteImageForSubletWithId:subletId imageId:imageId];
}

- (BFTask *)getImageWithId:(NSNumber *)imageId
{
    return [[self.apiClient getImageWithId:imageId] continueWithSuccessBlock:^id(BFTask *task) {
        NSData *imageData = task.result;
        UIImage *image = [UIImage imageWithData:imageData];
        
        return image;
    }];
}

@end
