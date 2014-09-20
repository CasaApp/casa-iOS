//
//  CASListingTableViewCell.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kCellHeight = 180.0f;

@class CASSublet;

@interface CASListingTableViewCell : UITableViewCell

@property (nonatomic, strong) CASSublet *sublet;

@end
