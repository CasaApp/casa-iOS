//
//  CASToken.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CASObjectState.h"

@interface CASToken : NSObject <CASObjectState>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDate *expiryDate;

@end
