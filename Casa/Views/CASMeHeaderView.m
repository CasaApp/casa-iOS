//
//  CASMeHeaderView.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASMeHeaderView.h"
#import "CASUser.h"

@implementation CASMeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        [self addSubview:_nameLabel];
        
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.textAlignment = NSTextAlignmentCenter;
        _emailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        [self addSubview:_emailLabel];
        
        _myListingsLabel = [[UILabel alloc] init];
        _myListingsLabel.textAlignment = NSTextAlignmentCenter;
        _myListingsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        _myListingsLabel.text = @"My listings";
        [self addSubview:_myListingsLabel];
        
        _bottomSeparatorView = [[UIView alloc] init];
        _bottomSeparatorView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
        [self addSubview:_bottomSeparatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat padding = 15.0f;
    
    CGRect frame;
    frame.origin.x = padding;
    frame.origin.y = padding * 0.7f;
    frame.size.width = CGRectGetWidth(self.bounds) - 2.0f * padding;
    frame.size.height = 25.0f;
    self.nameLabel.frame = frame;
    self.nameLabel.text = self.user.name;
    
    frame.origin.y = CGRectGetMaxY(self.nameLabel.frame);
    frame.size.height = 20.0f;
    self.emailLabel.frame = frame;
    self.emailLabel.text = self.user.email;
    
    frame.origin.y = CGRectGetMaxY(self.emailLabel.frame) + padding;
    frame.size.height = 25.0f;
    self.myListingsLabel.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(self.myListingsLabel.frame) + 5.0f;
    frame.size.width = 120.0f;
    frame.origin.x = self.myListingsLabel.center.x - roundf(CGRectGetWidth(frame) / 2.0f);
    frame.size.height = 0.8f;
    self.bottomSeparatorView.frame = frame;
}

- (void)setUser:(CASUser *)user
{
    _user = user;
    
    [self setNeedsLayout];
}

@end
