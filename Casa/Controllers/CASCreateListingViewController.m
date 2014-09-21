//
//  CASCreateListingViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASCreateListingViewController.h"

@interface CASCreateListingViewController ()

@end

@implementation CASCreateListingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Create";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped:)];
}

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
