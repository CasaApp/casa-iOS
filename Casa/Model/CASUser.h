//
//  CASUser.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CASObjectState.h"

@interface CASUser : NSObject <CASObjectState>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;

@end
