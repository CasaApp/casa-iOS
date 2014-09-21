//
//  CASAppDelegate.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASAppDelegate.h"
#import "CASHTTPAPIClient.h"
#import "CASServiceLocator.h"
#import "CASSubletService.h"
#import "CASUserService.h"
#import "CASListingsViewController.h"
#import "CASLoginSignupViewController.h"
#import "CASSearchViewController.h"
#import "CASMeViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CASAppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) CASListingsViewController *listingsVc;
@property (nonatomic, strong) CASListingsViewController *bookmarksVc;
@property (nonatomic, strong) CASSearchViewController *searchVc;
@property (nonatomic, strong) CASMeViewController *meViewController;

@end

@implementation CASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyDNRVPlmhir0eeb_kxX0zX9FpZTVy7SijE"];
    
    [self setupServices];
    [self setupWindow];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    return YES;
}

- (void)setupServices
{
    id<CASAPIClient> apiClient = [[CASHTTPAPIClient alloc] init];
    
    CASUserService *userService = [[CASUserService alloc] initWithApiClient:apiClient];
    CASSubletService *subletService = [[CASSubletService alloc] initWithApiClient:apiClient userService:userService];
    
    [CASServiceLocator sharedInstance].userService = userService;
    [CASServiceLocator sharedInstance].subletService = subletService;
}

- (UINavigationController *)navigationControllerWithVc:(UIViewController *)vc
{
    UIColor *red = UIColorFromRGB(0xEA4831);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = red;
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.translucent = NO;
    return nav;
}

- (void)setupWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.listingsVc = [[CASListingsViewController alloc] init];
    UINavigationController *nav = [self navigationControllerWithVc:self.listingsVc];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listings" image:[UIImage imageNamed:@"home-hollow"] tag:0];
    
    self.bookmarksVc = [[CASListingsViewController alloc] init];
    self.bookmarksVc.bookmarks = YES;
    UINavigationController *nav2 = [self navigationControllerWithVc:self.bookmarksVc];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"bookmark-hollow"] tag:1];
    
    self.searchVc = [[CASSearchViewController alloc] init];
    UINavigationController *nav3 = [self navigationControllerWithVc:self.searchVc];
    [self putLogoInTitle:self.searchVc];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"search-hollow"] tag:2];
    
    self.meViewController = [[CASMeViewController alloc] init];
    UINavigationController *nav4 = [self navigationControllerWithVc:self.meViewController];
    [self putLogoInTitle:self.meViewController];
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"user-hollow"] tag:3];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = @[ nav, nav2,/* nav3,*/ nav4 ];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)putLogoInTitle:(UIViewController *)vc
{
    UIImage *titleLogo = [UIImage imageNamed:@"Logo - Clear"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleLogo];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    vc.navigationItem.titleView = titleImageView;
    CGRect frame = titleImageView.frame;
    frame.size.width = roundf(titleLogo.size.width / 4.0f);
    frame.size.height = roundf(titleLogo.size.height / 4.0f);
    vc.navigationItem.titleView.frame = frame;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![CASServiceLocator sharedInstance].userService.loggedInUser && (viewController == self.bookmarksVc.navigationController || viewController == self.meViewController.navigationController)) {
        [self requestLoginOnVc:[(UINavigationController *)tabBarController.selectedViewController topViewController]];
        return NO;
    }
    
    return YES;
}

- (void)requestLoginOnVc:(UIViewController *)vc
{
    CASLoginSignupViewController *loginvc = [[CASLoginSignupViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginvc];
    nav.navigationBar.barTintColor = vc.navigationController.navigationBar.barTintColor;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.translucent = NO;
    [vc presentViewController:nav animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
