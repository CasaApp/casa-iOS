//
//  CASListingsViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASListingsViewController.h"
#import "CASListingTableViewCell.h"
#import "CASServiceLocator.h"
#import "CASSubletService.h"
#import "CASUserService.h"
#import "CASSubletQuery.h"
#import "CASSublet.h"
#import "CASCreateListingViewController.h"
#import "CASLoginSignupViewController.h"

@interface CASListingsViewController () <CASListingTableViewCellDelegate>

@property (nonatomic, strong) CASSubletQuery *currentQuery;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation CASListingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UIImage *titleLogo = [UIImage imageNamed:@"Logo - Clear"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleLogo];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = titleImageView;
    CGRect frame = titleImageView.frame;
    frame.size.width = roundf(titleLogo.size.width / 4.0f);
    frame.size.height = roundf(titleLogo.size.height / 4.0f);
    self.navigationItem.titleView.frame = frame;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(createButtonTapped:)];
    
    self.currentQuery = [[CASSubletQuery alloc] init];
    self.currentQuery.latitude = @50;
    self.currentQuery.longitude = @50;
    self.currentQuery.radius = @500;
    self.currentQuery.startDate = [NSDate date];
    self.currentQuery.endDate = [NSDate date];
    [[[CASServiceLocator sharedInstance].subletService getSubletsWithQuery:self.currentQuery] continueWithBlock:^id(BFTask *task) {
        self.tableData = task.result;
        [self.tableView reloadData];
        
        return nil;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ListingCell";
    CASListingTableViewCell *cell = (CASListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CASListingTableViewCell alloc] init];
    }
    
    cell.delegate = self;
    cell.sublet = self.tableData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (![CASServiceLocator sharedInstance].userService.loggedInUser) {
        [self requestLogin];
        return;
    }
    
    
}

- (void)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell didTapScrollView:(UIScrollView *)scrollView
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForCell:listingTableViewCell]];
}

- (BOOL)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell shouldToggleStarForSublet:(CASSublet *)sublet
{
    if (![CASServiceLocator sharedInstance].userService.loggedInUser) {
        [self requestLogin];
        return NO;
    }
    
    return YES;
}

- (void)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell didTapStarForSublet:(CASSublet *)sublet
{
    [[[CASServiceLocator sharedInstance].subletService createBookmarkForSubletId:sublet.subletId] continueWithBlock:^id(BFTask *task) {
        
        
        return nil;
    }];
}

- (void)requestLogin
{
    CASLoginSignupViewController *loginvc = [[CASLoginSignupViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginvc];
    nav.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Actions

- (void)createButtonTapped:(UIBarButtonItem *)sender
{
    if (![CASServiceLocator sharedInstance].userService.loggedInUser) {
        [self requestLogin];
        return;
    }
    
    CASCreateListingViewController *createListingViewController = [[CASCreateListingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createListingViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refreshControlTriggered:(UIRefreshControl *)sender
{
    [[[CASServiceLocator sharedInstance].subletService getSubletsWithQuery:self.currentQuery] continueWithBlock:^id(BFTask *task) {
        self.tableData = task.result;
        [self.tableView reloadData];
        [sender endRefreshing];
        
        return nil;
    }];
}

@end
