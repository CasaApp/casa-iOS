//
//  CASSubletDetailsView.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CASSublet;
@class FKTextField;

@interface CASSubletDetailsView : UIView

@property (nonatomic, strong) CASSublet *sublet;

@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *roomsAvailableLabel;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *startDateValueLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *endDateValueLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) FKTextField *tagsTextField;
@property (nonatomic, strong) UIView *backgroundOwnerView;
@property (nonatomic, strong) UILabel *submitterLabel;
@property (nonatomic, strong) UILabel *submitterValueLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *emailValueLabel;

@end
