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
@class CASListingTableViewCell;

@protocol CASListingTableViewCellDelegate <NSObject>

- (void)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell didTapScrollView:(UIScrollView *)scrollView;
- (void)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell didTapStarForSublet:(CASSublet *)sublet;
- (BOOL)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell shouldToggleStarForSublet:(CASSublet *)sublet;

@end

@interface CASListingTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CASListingTableViewCellDelegate> delegate;

@property (nonatomic, strong) CASSublet *sublet;

@end
