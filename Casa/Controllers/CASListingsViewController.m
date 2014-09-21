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
#import "CASDetailViewController.h"
#import "CASSearchViewController.h"
#import "CASAppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CASListingsViewController () <CASListingTableViewCellDelegate, CASSearchViewControllerDelegate>

@property (nonatomic, strong) CASSubletQuery *currentQuery;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UIView *emptyStateView;

@end

@implementation CASListingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
//    [self.refreshControl beginRefreshing];
    
    UIImage *titleLogo = [UIImage imageNamed:@"Logo - Clear"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleLogo];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = titleImageView;
    CGRect frame = titleImageView.frame;
    frame.size.width = roundf(titleLogo.size.width / 4.0f);
    frame.size.height = roundf(titleLogo.size.height / 4.0f);
    self.navigationItem.titleView.frame = frame;
    
    if (self.bookmarks) {
        frame = self.view.bounds;
        self.emptyStateView = [[UIView alloc] initWithFrame:frame];
        self.emptyStateView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        self.emptyStateView.backgroundColor = [UIColor greenColor];
        frame.origin.x = 15.0f;
        frame.origin.y = roundf(CGRectGetHeight(frame) / 2.0f) - 70.0f;
        frame.size.width = CGRectGetWidth(self.emptyStateView.bounds) - 2.0f * 15.0f;
        frame.size.height = 50.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        label.numberOfLines = 0;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
        label.textColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        label.text = @"Looks like you don't have any bookmarks. Go add some!";
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
//        label.backgroundColor = [UIColor blueColor];
        [self.emptyStateView addSubview:label];
        [self.view addSubview:self.emptyStateView];
        
        [[[CASServiceLocator sharedInstance].subletService getBookmarksWithOffset:@0 limit:@10] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error when getting bookmarks: %@", task.error);
                return nil;
            }
//            [self.refreshControl endRefreshing];
            self.tableData = task.result;
            [self.tableView reloadData];
            
            return nil;
        }];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search-hollow"] style:UIBarButtonItemStylePlain target:self action:@selector(searchTapped:)];
        
        self.currentQuery = [[CASSubletQuery alloc] init];
        self.currentQuery.address = @"200 University Ave, Waterloo, ON";
        self.currentQuery.radius = @5000000000;
        self.currentQuery.startDate = [NSDate date];
        self.currentQuery.endDate = [NSDate date];
        [[[CASServiceLocator sharedInstance].subletService getSubletsWithQuery:self.currentQuery] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error when getting sublets: %@", task.error);
                return nil;
            }
//            [self.refreshControl endRefreshing];
            self.tableData = task.result;
            [self.tableView reloadData];
            
            return nil;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.bookmarks) {
        [self refreshControlTriggered:self.refreshControl];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [self.tableData count];
    self.emptyStateView.hidden = count != 0;
    return count;
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
    
    CASDetailViewController *dvc = [[CASDetailViewController alloc] init];
    dvc.sublet = self.tableData[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
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
    
    sublet.bookmarked = !sublet.bookmarked;
    return YES;
}

- (void)listingTableViewCell:(CASListingTableViewCell *)listingTableViewCell didTapStarForSublet:(CASSublet *)sublet
{
    if (sublet.bookmarked) {
        [[[CASServiceLocator sharedInstance].subletService createBookmarkForSubletId:sublet.subletId] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error when creating bookmark for subletId %@: %@", sublet.subletId, task.error);
                sublet.bookmarked = !sublet.bookmarked;
                return nil;
            }
            
            return nil;
        }];
    } else {
        [[[CASServiceLocator sharedInstance].subletService deleteBookmarkForSubletId:sublet.subletId] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error when deleting bookmark for subletId %@: %@", sublet.subletId, task.error);
                sublet.bookmarked = !sublet.bookmarked;
                return nil;
            }
            
            if (self.bookmarks) {
                [self refreshControlTriggered:nil];
            }
            
            return nil;
        }];
    }
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

- (void)searchTapped:(id)sender
{
//    [[[CASServiceLocator sharedInstance].subletService uploadImage:[UIImage imageNamed:@"1375710079231"] forSublet:self.tableData[0]] continueWithBlock:^id(BFTask *task) {
//        
//        return nil;
//    }];
//    return;
    
    CASSearchViewController *search = [[CASSearchViewController alloc] init];
    search.delegate = self;
    UINavigationController *nav = [(CASAppDelegate *)[UIApplication sharedApplication].delegate navigationControllerWithVc:search];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refreshControlTriggered:(UIRefreshControl *)sender
{
    if (self.bookmarks) {
        [[[CASServiceLocator sharedInstance].subletService getBookmarksWithOffset:@0 limit:@10] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error getting bookmarks after pull to refresh: %@", task.error);
                return nil;
            }
            
            self.tableData = task.result;
            [self.tableView reloadData];
            [sender endRefreshing];
            
            return nil;
        }];
    } else {
        [[[CASServiceLocator sharedInstance].subletService getSubletsWithQuery:self.currentQuery] continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                NSLog(@"Error getting sublets after pull to refresh: %@", task.error);
                return nil;
            }
            self.tableData = task.result;
            [self.tableView reloadData];
            [sender endRefreshing];
            
            return nil;
        }];
    }
}

- (void)searchViewControllerDidStartSearchingWithTask:(BFTask *)task query:(CASSubletQuery *)query
{
    [task continueWithBlock:^id(BFTask *task) {
        if ([task.result count] < 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showErrorWithStatus:@"No sublets found!"];
            }];
            return nil;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        self.tableData = task.result;
        self.currentQuery = query;
        [self.tableView reloadData];
        return nil;
    }];
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
