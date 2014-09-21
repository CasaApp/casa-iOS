//
//  UIView+JSPoppingOverlay.m
//  Popping Overlay
//
//  Created by Justin Sacbibit on 2014-08-23.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "UIView+JSPoppingOverlay.h"
#import "JSPoppingOverlay.h"

@implementation UIView (JSPoppingOverlay)

- (BOOL)hasOverlay
{
    for (UIView *subview in self.subviews)
        if ([subview isKindOfClass:[JSPoppingOverlay class]])
            return YES;
    return NO;
}

- (JSPoppingOverlay *)overlay
{
    if ([self hasOverlay])
        return nil;
    return [[JSPoppingOverlay alloc] init];
}

- (void)showSuccessPoppingOverlay
{
    [self showSuccessPoppingOverlayWithMessage:nil];
}

- (void)showSuccessPoppingOverlayWithMessage:(NSString *)message
{
    [[self overlay] showSuccessOnView:self message:message];
}

- (void)showErrorPoppingOverlay
{
    [self showErrorPoppingOverlayWithMessage:nil];
}

- (void)showErrorPoppingOverlayWithMessage:(NSString *)message
{
    [[self overlay] showErrorOnView:self message:message];
}

- (void)showPoppingOverlayWithImage:(UIImage *)image
{
    [self showPoppingOverlayWithImage:image withMessage:nil];
}

- (void)showPoppingOverlayWithMessage:(NSString *)message
{
    [self showPoppingOverlayWithImage:nil withMessage:message];
}

- (void)showPoppingOverlayWithImage:(UIImage *)image withMessage:(NSString *)message
{
    [[self overlay] showImage:image onView:self message:message];
}

@end
