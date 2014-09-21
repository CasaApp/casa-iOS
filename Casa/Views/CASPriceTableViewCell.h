//
//  CASPriceTableViewCell.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CASPriceTableViewCell : UITableViewCell

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *dollarLabel;
@property (nonatomic, strong) UITextField *priceTextField;

@end
