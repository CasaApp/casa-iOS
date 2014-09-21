//
//  CASDetailsTableViewCell.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-21.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASDetailsTableViewCell.h"
#import "CASSubletDetailsView.h"

@implementation CASDetailsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _detailsView = [[CASSubletDetailsView alloc] init];
        [self addSubview:_detailsView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailsView.frame = self.bounds;
}

@end
