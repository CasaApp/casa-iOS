//
//  CASScrollingImagesView.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASScrollingImagesView.h"
#import "CASSublet.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CASScrollingImagesView () <UIScrollViewDelegate>

@end

@implementation CASScrollingImagesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imagesScrollView = [[UIScrollView alloc] init];
        _imagesScrollView.showsHorizontalScrollIndicator = NO;
        _imagesScrollView.pagingEnabled = YES;
        _imagesScrollView.bounces = NO;
        _imagesScrollView.delegate = self;
        [self addSubview:_imagesScrollView];
        
        _imageViews = [NSMutableArray array];
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        
        _priceContainerView = [[UIView alloc] init];
        [self addSubview:_priceContainerView];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_priceContainerView addSubview:_priceLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGRect frame = self.bounds;
    self.imagesScrollView.frame = frame;
    
    __block CGFloat contentWidth = 0.0f;
    
    [self.sublet.imageIds enumerateObjectsUsingBlock:^(NSNumber *imageId, NSUInteger idx, BOOL *stop) {
        frame.origin.x = idx * CGRectGetWidth(self.bounds);
        contentWidth += CGRectGetWidth(self.bounds);
        
        if (idx >= [self.imageViews count]) {
            UIImageView *subletImageView = [[UIImageView alloc] init];
            subletImageView.frame = frame;
            subletImageView.contentMode = UIViewContentModeScaleAspectFill;
            [subletImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://casa.tpcstld.me/api/images/%@", self.sublet.imageIds[idx]]]];
            [self.imageViews addObject:subletImageView];
            [self.imagesScrollView addSubview:subletImageView];
        }
    }];
    
    self.pageControl.numberOfPages = [self.sublet.imageIds count];
    self.imagesScrollView.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.bounds));
    
    [_pageControl sizeToFit];
    frame = _pageControl.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetMaxY(self.imagesScrollView.frame) - CGRectGetHeight(self.pageControl.bounds);
    _pageControl.frame = frame;
    
    const CGFloat padding = 10.0f;
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%@/month", self.sublet.price];
    [self.priceLabel sizeToFit];
    frame = self.priceLabel.frame;
    frame.origin = CGPointZero;
    self.priceLabel.frame = frame;
    frame.size.width += padding * 1.2f;
    frame.size.height += padding;
    frame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(frame);
    frame.origin.y = CGRectGetHeight(self.bounds) - padding * 2.0f - CGRectGetHeight(frame);
    self.priceContainerView.frame = frame;
    self.priceContainerView.backgroundColor = [UIColor grayColor];
    
    frame = self.priceLabel.frame;
    frame.origin.x += roundf((CGRectGetWidth(self.priceContainerView.bounds) - CGRectGetWidth(self.priceLabel.bounds)) / 2.0f);
    frame.origin.y += roundf((CGRectGetHeight(self.priceContainerView.bounds) - CGRectGetHeight(self.priceLabel.bounds)) / 2.0f);
    self.priceLabel.frame = frame;
}

- (void)setSublet:(CASSublet *)sublet
{
    _sublet = sublet;
    
    [self setNeedsLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = MAX(floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)), 0U);
    self.pageControl.currentPage = page;
}

@end
