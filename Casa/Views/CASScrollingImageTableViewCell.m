//
//  CASScrollingImageTableViewCell.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASScrollingImageTableViewCell.h"
#import "CASSublet.h"
#import "CASScrollingImagesView.h"

@interface CASScrollingImageTableViewCell () <UIScrollViewDelegate>

@end

@implementation CASScrollingImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scrollingImagesView = [[CASScrollingImagesView alloc] init];
        [self addSubview:_scrollingImagesView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollingImagesView.frame = self.bounds;
}

@end
