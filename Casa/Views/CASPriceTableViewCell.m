//
//  CASPriceTableViewCell.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASPriceTableViewCell.h"

@implementation CASPriceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
        
        _priceTextField = [[UITextField alloc] init];
        _priceTextField.textAlignment = NSTextAlignmentRight;
        _priceTextField.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.7f];
        _priceTextField.layer.cornerRadius = 4.0f;
        _priceTextField.layer.sublayerTransform = CATransform3DMakeTranslation(-10, 0, 0);
        [self addSubview:_priceTextField];
        
        _dollarLabel = [[UILabel alloc] init];
        _dollarLabel.text = @"$";
        [_priceTextField addSubview:_dollarLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat padding = 15.0f;
    
    self.priceLabel.text = @"Price";
    [self.priceLabel sizeToFit];
    CGRect frame = self.priceLabel.frame;
    frame.origin.x = padding;
    frame.origin.y = padding;
    frame.size.width = CGRectGetWidth(self.bounds) - 2.0f * padding;
    self.priceLabel.frame = frame;
    
    [self.priceTextField sizeToFit];
    frame.origin.y = CGRectGetMaxY(self.priceLabel.frame) + padding;
    frame.size.height += padding;
    self.priceTextField.frame = frame;
    
    [self.dollarLabel sizeToFit];
    frame = self.dollarLabel.frame;
    frame.origin.x = padding*2;
    frame.origin.y = padding/2;
    self.dollarLabel.frame = frame;
}

@end
