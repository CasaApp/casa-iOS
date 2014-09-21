//
//  CASDetailViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASDetailViewController.h"
#import "CASAppDelegate.h"
#import "CASSublet.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CASScrollingImageTableViewCell.h"
#import "CASScrollingImagesView.h"
#import <TGRImageViewController.h>
#import <TGRImageZoomAnimationController.h>
#import "CASDetailsTableViewCell.h"
#import "CASSubletDetailsView.h"

@interface CASDetailViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CASDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.sublet.address;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    /*
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.sublet.latitude doubleValue] longitude:[self.sublet.longitude doubleValue] zoom:15.0f];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = [NSString stringWithFormat:@"%@\n%@", self.sublet.address, self.sublet.city];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    
    self.view = mapView;
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            static NSString *cellIdentifier = @"ScrollingImagesCell";
            CASScrollingImageTableViewCell *cell = (CASScrollingImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[CASScrollingImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.scrollingImagesView.sublet = self.sublet;
            return cell;
            break;
        }
        case 1: {
            static NSString *cellIdentifier = @"DetailCell";
            CASDetailsTableViewCell *cell = (CASDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[CASDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.detailsView.sublet = self.sublet;
            return cell;
            break;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}

@end
