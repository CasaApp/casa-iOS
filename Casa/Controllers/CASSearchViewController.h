//
//  CASSearchViewController.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CASSubletQuery;

@protocol CASSearchViewControllerDelegate <NSObject>

- (void)searchViewControllerDidStartSearchingWithTask:(BFTask *)task query:(CASSubletQuery *)query;

@end

@interface CASSearchViewController : UIViewController

@property (nonatomic, weak) id<CASSearchViewControllerDelegate> delegate;

@end
