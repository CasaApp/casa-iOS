//
//  CASAppDelegate.h
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CASAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)putLogoInTitle:(UIViewController *)vc;
- (UINavigationController *)navigationControllerWithVc:(UIViewController *)vc;
- (void)requestLoginOnVc:(UIViewController *)vc;

@end
