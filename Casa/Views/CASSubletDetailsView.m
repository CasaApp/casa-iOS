//
//  CASSubletDetailsView.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASSubletDetailsView.h"
#import "CASSublet.h"
#import <FieldKit/FieldKit.h>

@interface CASSubletDetailsView ()

@end

@implementation CASSubletDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star-black"]];
        [self addSubview:_starImageView];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:23.0f];
        [self addSubview:_addressLabel];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        _locationLabel.textColor = [UIColor grayColor];
        [self addSubview:_locationLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        [self addSubview:_distanceLabel];
        
        _roomsAvailableLabel = [[UILabel alloc] init];
        [self addSubview:_roomsAvailableLabel];
        
        _startDateLabel = [[UILabel alloc] init];
        [self addSubview:_startDateLabel];
        
        _startDateValueLabel = [[UILabel alloc] init];
        [self addSubview:_startDateValueLabel];
        
        _endDateLabel = [[UILabel alloc] init];
        [self addSubview:_endDateLabel];
        
        _endDateValueLabel = [[UILabel alloc] init];
        [self addSubview:_endDateValueLabel];
        
        _descriptionLabel = [[UILabel alloc] init];
        [self addSubview:_descriptionLabel];
        
        _tagsTextField = [[FKTextField alloc] init];
        [self addSubview:_tagsTextField];
        
        _backgroundOwnerView = [[UIView alloc] init];
        _backgroundOwnerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
        [self addSubview:_backgroundOwnerView];
        
        _submitterLabel = [[UILabel alloc] init];
        _submitterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        [_backgroundOwnerView addSubview:_submitterLabel];
        
        _submitterValueLabel = [[UILabel alloc] init];
        _submitterValueLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        [_backgroundOwnerView addSubview:_submitterValueLabel];
        
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.font = _submitterLabel.font;
        [_backgroundOwnerView addSubview:_emailLabel];
        
        _emailValueLabel = [[UILabel alloc] init];
        _emailValueLabel.font = _submitterValueLabel.font;
        _emailValueLabel.textAlignment = NSTextAlignmentRight;
        [_backgroundOwnerView addSubview:_emailValueLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat padding = 10.0f;
    
    CGRect frame = self.starImageView.frame;
    frame.origin.x = padding;
    frame.origin.y = padding;
    self.starImageView.frame = frame;
    
    self.addressLabel.text = self.sublet.address;
    [self.addressLabel sizeToFit];
    frame = self.addressLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.starImageView.frame) + padding;
    frame.origin.y = padding / 2.0f;
    frame.size.width = CGRectGetWidth(self.bounds) - 2.0f * padding;
    self.addressLabel.frame = frame;
    
    self.locationLabel.text = self.sublet.city;
    [self.locationLabel sizeToFit];
    frame = self.locationLabel.frame;
    frame.origin.x = CGRectGetMinX(self.addressLabel.frame);
    frame.origin.y = CGRectGetMaxY(self.addressLabel.frame);
    self.locationLabel.frame = frame;
    
    self.starImageView.center = CGPointMake(self.starImageView.center.x, [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMinY(self.addressLabel.frame), 3.0f, CGRectGetMaxY(self.locationLabel.frame) - CGRectGetMinY(self.addressLabel.frame))].center.y);
    
    frame = self.bounds;
    frame.origin.y = CGRectGetMaxY(self.locationLabel.frame) + padding;
    frame.size.height = 60.0f;
    self.backgroundOwnerView.frame = frame;
    
    self.submitterLabel.text = @"Submitter:";
    frame.origin.x = padding;
    frame.origin.y = 3.0f;
    frame.size.height = 20.0f;
    self.submitterLabel.frame = frame;
    
    self.submitterValueLabel.text = @"Karel Vuong";
    frame.origin.y = CGRectGetMaxY(self.submitterLabel.frame);
    frame.size.height = CGRectGetHeight(self.backgroundOwnerView.bounds) - CGRectGetHeight(self.submitterLabel.bounds) - padding * 1.2f;
//    self.submitterValueLabel.backgroundColor = [UIColor redColor];
    self.submitterValueLabel.frame = frame;
    
    self.emailValueLabel.text = @"karelvuong@me.com";
    frame.origin.y = CGRectGetMinY(self.submitterValueLabel.frame);
    frame.origin.x = CGRectGetWidth(self.bounds) - padding - CGRectGetWidth(frame);
//    self.emailValueLabel.backgroundColor = [UIColor blueColor];
    self.emailValueLabel.frame = frame;
}

- (void)setSublet:(CASSublet *)sublet
{
    _sublet = sublet;
    
    [self setNeedsLayout];
}

@end
