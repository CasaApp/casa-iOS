//
//  CASHTTPAPIClient.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "CASHTTPAPIClient.h"
#import "CASToken.h"

#define API_SUBLETS                     @"/api/sublets"
#define API_SUBLET(subletId)            [NSString stringWithFormat:@"%@/%@", API_SUBLETS, subletId]
#define API_AUTHENTICATE                @"/api/authenticate"
#define API_USERS                       @"/api/users"
#define API_USER(userId)                [NSString stringWithFormat:@"%@/%@", API_USERS, userId]
#define API_BOOKMARKS(userId)           [NSString stringWithFormat:@"%@/bookmarks", API_USER(userId)]
#define API_BOOKMARK(userId, subletId)  [NSString stringWithFormat:@"%@/%@", API_BOOKMARKS(userId), subletId]

typedef enum : NSUInteger {
    HTTPRequestMethodGet,
    HTTPRequestMethodPost,
    HTTPRequestMethodPut,
    HTTPRequestMethodDelete
} HTTPRequestMethod;

static NSString * const CASExpiryDateKey = @"CASExpiryDateKey";

@interface CASHTTPAPIClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpRequestOperationManager;
@property (nonatomic, strong) CASToken *token;

@end

@implementation CASHTTPAPIClient

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *baseUrl = [NSURL URLWithString:@"http://casa.tpcstld.me"];
        _httpRequestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        self.token = [CASToken loadState];
    }
    return self;
}

- (BFTask *)taskWithMethod:(HTTPRequestMethod)method path:(NSString *)path params:(NSDictionary *)params
{
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [task setResult:responseObject];
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [task setError:error];
    };
    
    switch (method) {
        case HTTPRequestMethodGet: {
            [self.httpRequestOperationManager GET:path parameters:params success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodPost: {
            [self.httpRequestOperationManager POST:path parameters:params success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodPut: {
            [self.httpRequestOperationManager PUT:path parameters:params success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodDelete: {
            [self.httpRequestOperationManager DELETE:path parameters:params success:successBlock failure:failureBlock];
            break;
        }
    }
    
    return task.task;
}

#pragma mark - Sublets

- (BFTask *)getSubletsWithParams:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodGet path:API_SUBLETS params:params];
}

- (BFTask *)createSubletWithParams:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodPost path:API_SUBLETS params:params];
}

- (BFTask *)getSubletWithId:(NSNumber *)subletId
{
    return [self taskWithMethod:HTTPRequestMethodGet path:API_SUBLET(subletId) params:nil];
}

- (BFTask *)updateSubletWithId:(NSNumber *)subletId withParams:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodPut path:API_SUBLET(subletId) params:params];
}

- (BFTask *)deleteSubletWithId:(NSNumber *)subletId
{
    return [self taskWithMethod:HTTPRequestMethodDelete path:API_SUBLET(subletId) params:nil];
}

#pragma mark - Authentication

- (BFTask *)loginWithParams:(NSDictionary *)params
{
    NSString *email = params[CASAPIEmailKey];
    NSString *password = params[CASAPIPasswordKey];
    
    [self.httpRequestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    return [[[self taskWithMethod:HTTPRequestMethodPost path:API_AUTHENTICATE params:params] continueWithBlock:^id(BFTask *task) {
        [self.httpRequestOperationManager.requestSerializer clearAuthorizationHeader];
        
        return task;
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSDictionary *responseJson = task.result;
        NSTimeInterval secondsUntilExpiry = [responseJson[CASAPIExpiresInKey] doubleValue];
        
        CASToken *token = [[CASToken alloc] init];
        token.token = responseJson[CASAPITokenKey];
        token.expiryDate = [[NSDate date] dateByAddingTimeInterval:secondsUntilExpiry];
        self.token = token;
        [token saveState];
        
        return task;
    }];
}

- (BFTask *)logout
{
    return [[self taskWithMethod:HTTPRequestMethodDelete path:API_AUTHENTICATE params:nil] continueWithSuccessBlock:^id(BFTask *task) {
        self.token = nil;
        [CASToken removeState];
        
        return task;
    }];
}

#pragma mark - User

- (BFTask *)signupUserWithParams:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodPost path:API_USERS params:params];
}

- (BFTask *)getUserWithId:(NSNumber *)userId
{
    return [self taskWithMethod:HTTPRequestMethodGet path:API_USER(userId) params:nil];
}

- (BFTask *)updateUserWithId:(NSNumber *)userId withParams:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodPut path:API_USER(userId) params:params];
}

#pragma mark - Bookmarks

- (BFTask *)getBookmarksForUserWithId:(NSNumber *)userId params:(NSDictionary *)params
{
    return [self taskWithMethod:HTTPRequestMethodGet path:API_BOOKMARKS(userId) params:params];
}

- (BFTask *)createBookmarkForUserWithId:(NSNumber *)userId subletId:(NSNumber *)subletId
{
    NSDictionary *params = @{ CASAPISubletIdKey: subletId };
    return [self taskWithMethod:HTTPRequestMethodPost path:API_BOOKMARKS(userId) params:params];
}

- (BFTask *)deleteBookmarkForUserWithId:(NSNumber *)userId subletId:(NSNumber *)subletId
{
    return [self taskWithMethod:HTTPRequestMethodDelete path:API_BOOKMARK(userId, subletId) params:nil];
}

@end
