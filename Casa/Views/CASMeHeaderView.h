//
//  CASMeHeaderView.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CASUser;

@interface CASMeHeaderView : UIView

@property (nonatomic, strong) CASUser *user;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *myListingsLabel;
@property (nonatomic, strong) UIView *bottomSeparatorView;

@end
