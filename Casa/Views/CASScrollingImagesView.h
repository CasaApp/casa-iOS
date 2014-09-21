//
//  CASScrollingImagesView.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CASSublet;

@interface CASScrollingImagesView : UIView

@property (nonatomic, strong) CASSublet *sublet;
@property (nonatomic, strong) UIScrollView *imagesScrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *priceContainerView;

@end
