//
//  CASMeViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASMeViewController.h"
#import "CASMeHeaderView.h"
#import "CASServiceLocator.h"
#import "CASUserService.h"
#import "CASAppDelegate.h"
#import "CASCreateListingViewController.h"

@interface CASMeViewController ()

@property (nonatomic, strong) CASMeHeaderView *headerView;

@end

@implementation CASMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 115.0f;
    
    self.headerView = [[CASMeHeaderView alloc] initWithFrame:frame];
    self.headerView.user = [CASServiceLocator sharedInstance].userService.loggedInUser;
    self.tableView.tableHeaderView = self.headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-hollow"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(createButtonTapped:)];
}

- (void)settingsTapped:(id)sender
{
    
}

- (void)createButtonTapped:(UIBarButtonItem *)sender
{
    if (![CASServiceLocator sharedInstance].userService.loggedInUser) {
        [(CASAppDelegate *)[UIApplication sharedApplication].delegate requestLoginOnVc:self];
        return;
    }
    
    CASCreateListingViewController *createListingViewController = [[CASCreateListingViewController alloc] init];
    UINavigationController *nav = [(CASAppDelegate *)[UIApplication sharedApplication].delegate navigationControllerWithVc:createListingViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
