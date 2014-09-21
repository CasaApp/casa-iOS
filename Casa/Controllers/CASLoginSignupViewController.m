//
//  CASLoginSignupViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASLoginSignupViewController.h"
#import "CASServiceLocator.h"
#import "CASUserService.h"

@interface CASLoginSignupViewController ()

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation CASLoginSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped:)];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.tintColor = [UIColor whiteColor];
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.backgroundColor = UIColorFromRGB(0xEA4831);
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    CGRect frame;
    frame.origin.x = 20.0f;
    frame.origin.y = 300.0f;
    frame.size.width = CGRectGetWidth(self.view.bounds) - 2.0f * 20.0f;
    frame.size.height = 50.0f;
    self.loginButton.frame = frame;
}

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneTapped:(id)sender
{
    [[[CASServiceLocator sharedInstance].userService loginWithEmail:@"j39jiang@uwaterloo.ca" password:@"swagswaglikecaillou"] continueWithBlock:^id(BFTask *task) {
        if (!task.isCancelled && !task.error) {
            NSLog(@"Successfully logged in.");
        } else if (task.error) {
            NSLog(@"Error when logging in: %@", task.error);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return nil;
    }];
}

@end
