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

@interface CASListingsViewController ()

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
    
    [[[CASServiceLocator sharedInstance].subletService getSubletWithId:@5629499534213120] continueWithBlock:^id(BFTask *task) {
        self.tableData = @[ task.result, task.result, task.result, task.result ];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)createButtonTapped:(UIBarButtonItem *)sender
{
    
}

- (void)refreshControlTriggered:(UIRefreshControl *)sender
{
    [sender endRefreshing];
}

@end
