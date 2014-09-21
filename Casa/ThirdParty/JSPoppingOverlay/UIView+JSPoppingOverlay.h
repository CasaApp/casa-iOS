//
//  UIView+JSPoppingOverlay.h
//  Popping Overlay
//
//  Created by Justin Sacbibit on 2014-08-23.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Convenience category on UIView for display a JSPoppingOverlay.
 */

@interface UIView (JSPoppingOverlay)

#pragma mark - Success overlay

/**
 *  Show a popping overlay which indicates success.
 */
- (void)showSuccessPoppingOverlay;
/**
 *  Show a popping overlay which indicates success, along with a message.
 */
- (void)showSuccessPoppingOverlayWithMessage:(NSString *)message;

#pragma mark - Error overlay

/**
 *  Show a popping overlay which indicates an error.
 */
- (void)showErrorPoppingOverlay;
/**
 *  Show a popping overlay which indicates an error, along with a message.
 */
- (void)showErrorPoppingOverlayWithMessage:(NSString *)message;

#pragma mark - Custom overlay

/**
 *  Show a popping overlay with a custom image.
 */
- (void)showPoppingOverlayWithImage:(UIImage *)image;
/**
 *  Show a popping overlay with only a message.
 */
- (void)showPoppingOverlayWithMessage:(NSString *)message;
/**
 *  Show a popping overlay with a message and custom image.
 */
- (void)showPoppingOverlayWithImage:(UIImage *)image withMessage:(NSString *)message;

@end
