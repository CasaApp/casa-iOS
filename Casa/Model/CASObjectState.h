//
//  CASObjectState.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CASObjectState <NSObject>

+ (instancetype)loadState;
+ (void)removeState;
- (void)saveState;

@end
