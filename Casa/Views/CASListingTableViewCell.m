//
//  CASListingTableViewCell.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASListingTableViewCell.h"
#import "CASSublet.h"
#import "CASServiceLocator.h"
#import "CASSubletService.h"
#import <FBKVOController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+JSPoppingOverlay.h"

static const CGFloat kPriceBackgroundViewHeight = 30.0f;

@interface CASListingTableViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) NSMutableArray *subletImageViews;
@property (nonatomic, strong) UIScrollView *imagesScrollView;
@property (nonatomic, strong) UIView *priceBackgroundView;
@property (nonatomic, strong) UILabel *dollarLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *perMonthLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *numRoomsAvailableLabel;
@property (nonatomic, strong) UILabel *roomsAvailableLabel;
@property (nonatomic, strong) UIView *bottomSeparatorView;
@property (nonatomic, strong) FBKVOController *kvoController;

@end

@implementation CASListingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _kvoController = [[FBKVOController alloc] initWithObserver:self];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _imagesScrollView = [[UIScrollView alloc] init];
        _imagesScrollView.showsHorizontalScrollIndicator = NO;
        _imagesScrollView.pagingEnabled = YES;
        _imagesScrollView.bounces = NO;
        _imagesScrollView.delegate = self;
        [self addSubview:_imagesScrollView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_imagesScrollView addGestureRecognizer:tap];
        
//        UIImageView *subletImageView = [[UIImageView alloc] init];
//        subletImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imagesScrollView addSubview:subletImageView];
//        
//        UIImageView *subletImageView2 = [[UIImageView alloc] init];
//        subletImageView2.contentMode = UIViewContentModeScaleAspectFill;
//        [_imagesScrollView addSubview:subletImageView2];
        
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton addTarget:self action:@selector(starButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_starButton setImage:[UIImage imageNamed:@"star-hollow"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"star-filled"] forState:UIControlStateSelected];
        [self addSubview:_starButton];
        
//        _subletImageViews = [@[ subletImageView, subletImageView2 ] mutableCopy];
        _subletImageViews = [NSMutableArray array];
        _pageControl.numberOfPages = [_subletImageViews count];
        
        _priceBackgroundView = [[UIView alloc] init];
        _priceBackgroundView.backgroundColor = [UIColor grayColor];
        [self addSubview:_priceBackgroundView];
        
        _dollarLabel = [self priceStyledLabel];
        _dollarLabel.text = @"$";
        _dollarLabel.font = [UIFont fontWithName:_dollarLabel.font.familyName size:11.0f];
//        _dollarLabel.backgroundColor = [UIColor greenColor];
        [_priceBackgroundView addSubview:_dollarLabel];
        
        _priceLabel = [self priceStyledLabel];
        _priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0f];
//        _priceLabel.backgroundColor = [UIColor blueColor];
        [_priceBackgroundView addSubview:_priceLabel];
        
        _perMonthLabel = [self priceStyledLabel];
        _perMonthLabel.font = [UIFont fontWithName:_perMonthLabel.font.familyName size:7.0f];
        _perMonthLabel.adjustsFontSizeToFitWidth = YES;
        _perMonthLabel.numberOfLines = 1;
        _perMonthLabel.text = @"per month";
//        _perMonthLabel.backgroundColor = [UIColor blackColor];
        [_priceBackgroundView addSubview:_perMonthLabel];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
//        _addressLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_addressLabel];
        
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        _cityLabel.textColor = [UIColor grayColor];
//        _cityLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:_cityLabel];
        
        _numRoomsAvailableLabel = [[UILabel alloc] init];
        _numRoomsAvailableLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
//        _numRoomsAvailableLabel.backgroundColor = [UIColor redColor];
        _numRoomsAvailableLabel.textColor = UIColorFromRGB(0x017B8A);
        [self addSubview:_numRoomsAvailableLabel];
        
        _roomsAvailableLabel = [[UILabel alloc] init];
        _roomsAvailableLabel.font = _cityLabel.font;
        _roomsAvailableLabel.textColor = [UIColor grayColor];
        _roomsAvailableLabel.text = @"rooms available";
//        _roomsAvailableLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:_roomsAvailableLabel];
        
        [self addSubview:_pageControl];
        
        _bottomSeparatorView = [[UIView alloc] init];
        _bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomSeparatorView];
    }
    return self;
}

- (void)setSublet:(CASSublet *)sublet
{
    _sublet = sublet;
    
    [self.kvoController observe:sublet keyPath:@"bookmarked" options:NSKeyValueObservingOptionNew block:^(CASListingTableViewCell *observer, CASSublet *sublet, NSDictionary *change) {
        BOOL newVal = [change[NSKeyValueChangeNewKey] boolValue];
        if (newVal) {
            [self.imagesScrollView showSuccessPoppingOverlayWithMessage:@"Bookmarked!"];
        } else {
            
        }
        self.starButton.selected = newVal;
    }];
}

- (UILabel *)priceStyledLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, kCellHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat imageViewHeight = 128.0f;
    
    [self.starButton sizeToFit];
    __block CGRect frame = self.starButton.frame;
    frame.origin.x = 10.0f;
    frame.origin.y = 10.0f;
    self.starButton.frame = frame;
    self.starButton.selected = self.sublet.bookmarked;
    
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    frame.size.width = CGRectGetWidth(self.bounds);
    frame.size.height = imageViewHeight;
    self.imagesScrollView.frame = frame;
    
    __block CGFloat contentWidth = 0.0f;
    
    [self.sublet.imageIds enumerateObjectsUsingBlock:^(NSNumber *imageId, NSUInteger idx, BOOL *stop) {
        frame.origin.x = idx * CGRectGetWidth(self.bounds);
        contentWidth += CGRectGetWidth(self.bounds);
        
        if (idx >= [self.subletImageViews count]) {
            UIImageView *subletImageView = [[UIImageView alloc] init];
            subletImageView.frame = frame;
            subletImageView.contentMode = UIViewContentModeScaleAspectFill;
            [subletImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://casa.tpcstld.me/api/images/%@", self.sublet.imageIds[idx]]]];
            [self.subletImageViews addObject:subletImageView];
            [self.imagesScrollView addSubview:subletImageView];
        }
    }];
    
    self.pageControl.numberOfPages = [self.sublet.imageIds count];
    self.imagesScrollView.contentSize = CGSizeMake(contentWidth, imageViewHeight);
    
    [_pageControl sizeToFit];
    frame = _pageControl.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetMaxY(self.imagesScrollView.frame) - CGRectGetHeight(self.pageControl.bounds);
    _pageControl.frame = frame;
    
    CGFloat horizontalPadding = 4.0f;
    CGFloat verticalPadding = 2.0f;
    
    [self.dollarLabel sizeToFit];
    frame = self.dollarLabel.frame;
    frame.origin.x = horizontalPadding;
    frame.origin.y = verticalPadding;
    self.dollarLabel.frame = frame;
    
    self.priceLabel.text = [self.sublet.price stringValue];
    [self.priceLabel sizeToFit];
    frame = self.priceLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.dollarLabel.frame) + 2.0f;
    frame.origin.y = -2.0f;
    self.priceLabel.frame = frame;
    
    [self.perMonthLabel sizeToFit];
    frame = self.perMonthLabel.frame;
    frame.origin.x = CGRectGetMinX(self.priceLabel.frame);
    frame.origin.y = CGRectGetMaxY(self.priceLabel.frame) - 3.5f;
    frame.size.width = CGRectGetWidth(self.priceLabel.bounds);
    self.perMonthLabel.frame = frame;
    
    frame.origin.x = CGRectGetWidth(self.bounds) - (CGRectGetWidth(self.dollarLabel.bounds) + 2.0f + CGRectGetWidth(self.priceLabel.bounds) + 2.0f * horizontalPadding);
    frame.origin.y = imageViewHeight - kPriceBackgroundViewHeight - 15.0f;
    frame.size.width = CGRectGetWidth(self.bounds) - frame.origin.x;
    frame.size.height = kPriceBackgroundViewHeight;
    self.priceBackgroundView.frame = frame;
    
    horizontalPadding = 12.0f;
    verticalPadding = 8.0f;
    
    self.addressLabel.text = self.sublet.address;
    [self.addressLabel sizeToFit];
    frame = self.addressLabel.frame;
    frame.origin.x = horizontalPadding;
    frame.origin.y = CGRectGetMaxY(self.imagesScrollView.bounds) + verticalPadding;
    self.addressLabel.frame = frame;
    
    self.cityLabel.text = self.sublet.city;
    [self.cityLabel sizeToFit];
    frame = self.cityLabel.frame;
    frame.origin.x = horizontalPadding;
    frame.origin.y = CGRectGetMaxY(self.addressLabel.frame) - 2.0f;
    self.cityLabel.frame = frame;
    
    self.numRoomsAvailableLabel.text = [NSString stringWithFormat:@"%@ / %@", self.sublet.roomsAvailable, self.sublet.totalRooms];
    [self.numRoomsAvailableLabel sizeToFit];
    frame = self.numRoomsAvailableLabel.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(self.numRoomsAvailableLabel.bounds);
    frame.origin.y = CGRectGetMinY(self.addressLabel.frame);
    self.numRoomsAvailableLabel.frame = frame;
    
    [self.roomsAvailableLabel sizeToFit];
    frame = self.roomsAvailableLabel.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(self.roomsAvailableLabel.bounds);
    frame.origin.y = CGRectGetMinY(self.cityLabel.frame);
    self.roomsAvailableLabel.frame = frame;
    
    const CGFloat separatorHeight = 0.2505f;
    
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetHeight(self.bounds) - separatorHeight;
    frame.size.width = CGRectGetWidth(self.bounds);
    frame.size.height = separatorHeight;
    self.bottomSeparatorView.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = MAX(floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)), 0U);
    self.pageControl.currentPage = page;
}

- (void)starButtonTapped:(UIButton *)sender
{
    if (![self.delegate listingTableViewCell:self shouldToggleStarForSublet:self.sublet]) {
        return;
    }
    
//    sender.selected = !sender.selected;
    [self.delegate listingTableViewCell:self didTapStarForSublet:self.sublet];
}

- (void)tapped:(id)sender
{
    [self.delegate listingTableViewCell:self didTapScrollView:self.imagesScrollView];
}

@end
