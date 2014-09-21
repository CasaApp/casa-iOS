//
//  CASSearchViewController.m
//  Casa
//
//  Created by Justin Sacbibit on 2014-09-20.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

#import "CASSearchViewController.h"
#import "CASPriceTableViewCell.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <FieldKit/FieldKit.h>
#import "CASServiceLocator.h"
#import "CASSubletService.h"
#import "CASSubletQuery.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CASSearchViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *distanceTextField;
@property (nonatomic, strong) UILabel *numRoomsAvailableLabel;
@property (nonatomic, strong) UITextField *startDateTextField;
@property (nonatomic, strong) UITextField *endDateTextField;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CASSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    self.title = @"Search";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search-hollow"] style:UIBarButtonItemStyleDone target:self action:@selector(search:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped:)];
    
    JVFloatLabeledTextField *addressTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(15.0f, 5.0f, CGRectGetWidth(self.view.bounds) - 2.0f * 15.0f, 50.0f)];
    addressTextField.placeholder = @"Address";
    addressTextField.placeholderYPadding = -7.0f;
    [self.view addSubview:addressTextField];
    
    const CGFloat separatorHeight = 1.0f;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(addressTextField.frame), CGRectGetWidth(addressTextField.bounds), separatorHeight)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5f];
    [self.view addSubview:separator];
    
    JVFloatLabeledTextField *priceTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(addressTextField.frame) + 5.0f, CGRectGetWidth(addressTextField.bounds) / 3.0f, CGRectGetHeight(addressTextField.bounds))];
    priceTextField.placeholder = @"Price";
    priceTextField.placeholderYPadding = -7.0f;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:priceTextField];
    
    separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceTextField.frame), CGRectGetMaxY(addressTextField.frame), separatorHeight, CGRectGetHeight(priceTextField.bounds) + 5.0f)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    [self.view addSubview:separator];
    
    JVFloatLabeledTextField *distanceTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(separator.frame) + 15.0f, CGRectGetMinY(priceTextField.frame), CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(separator.frame) - 15.0f, CGRectGetHeight(priceTextField.bounds))];
    distanceTextField.placeholder = @"Maximum distance (KM)";
    distanceTextField.placeholderYPadding = -7.0f;
    distanceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:distanceTextField];
    
    separator = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(separator.frame), CGRectGetWidth(self.view.bounds) - 2.0f * 15.0f, separatorHeight)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    [self.view addSubview:separator];
    
    UILabel *roomsAvailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(distanceTextField.frame), CGRectGetWidth(self.view.bounds) / 2.0f, CGRectGetHeight(distanceTextField.bounds))];
    roomsAvailableLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    roomsAvailableLabel.text = @"Rooms available:";
    [self.view addSubview:roomsAvailableLabel];
    
    self.numRoomsAvailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(roomsAvailableLabel.frame), CGRectGetMinY(roomsAvailableLabel.frame), 20.0f, CGRectGetHeight(roomsAvailableLabel.frame))];
    self.numRoomsAvailableLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
    self.numRoomsAvailableLabel.text = @"1";
    [self.view addSubview:self.numRoomsAvailableLabel];
    
    UIStepper *roomsAvailableStepper = [[UIStepper alloc] init];
    roomsAvailableStepper.minimumValue = 1;
    roomsAvailableStepper.maximumValue = 7;
    [roomsAvailableStepper addTarget:self action:@selector(stepper:) forControlEvents:UIControlEventValueChanged];
    CGRect frame = roomsAvailableLabel.frame;
    frame.origin.x = CGRectGetWidth(self.view.bounds) - 15.0f - CGRectGetWidth(roomsAvailableStepper.frame);
    frame.origin.y = roomsAvailableLabel.center.y - CGRectGetHeight(roomsAvailableStepper.bounds) / 2.0f;
    roomsAvailableStepper.frame = frame;
    roomsAvailableStepper.tintColor = UIColorFromRGB(0xEA4831);
    [self.view addSubview:roomsAvailableStepper];
    
    separator = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(roomsAvailableLabel.frame), CGRectGetWidth(addressTextField.frame), separatorHeight)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [self.view addSubview:separator];
    
    UITextField *startDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(separator.frame), CGRectGetWidth(separator.frame) / 2.0f, CGRectGetHeight(addressTextField.frame))];
    startDateTextField.tag = 1;
    startDateTextField.placeholder = @"Start date";
    startDateTextField.delegate = self;
    self.startDateTextField = startDateTextField;
    [self.view addSubview:startDateTextField];
    
    separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startDateTextField.frame), CGRectGetMaxY(separator.frame), separatorHeight, CGRectGetMaxY(addressTextField.frame))];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [self.view addSubview:separator];
    
    UITextField *endDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startDateTextField.frame) + 15.0f, CGRectGetMinY(startDateTextField.frame), CGRectGetWidth(startDateTextField.frame), CGRectGetHeight(startDateTextField.frame))];
    endDateTextField.tag = 2;
    endDateTextField.placeholder = @"End date";
    endDateTextField.delegate = self;
    self.endDateTextField = endDateTextField;
    [self.view addSubview:endDateTextField];
    
    separator = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(endDateTextField.frame), CGRectGetWidth(addressTextField.frame), separatorHeight)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [self.view addSubview:separator];
    
    UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(separator.frame), CGRectGetMaxX(addressTextField.frame), CGRectGetHeight(addressTextField.frame))];
    tagsLabel.text = @"Tags";
    [self.view addSubview:tagsLabel];
    
    FKTokenField *tokenField = [[FKTokenField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(startDateTextField.frame), CGRectGetWidth(addressTextField.frame), CGRectGetHeight(self.view.bounds)- CGRectGetMaxY(startDateTextField.frame))];
    [self.view addSubview:tokenField];
    
    self.addressTextField = addressTextField;
    self.distanceTextField = distanceTextField;
}

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stepper:(UIStepper *)sender
{
    self.numRoomsAvailableLabel.text = [NSString stringWithFormat:@"%d", [@(sender.value) integerValue]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [ActionSheetDatePicker showPickerWithTitle:@"Select a start date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(startDate:) origin:textField];
        [self hideKeyboards];
        return NO;
    } else if (textField.tag == 2) {
        [ActionSheetDatePicker showPickerWithTitle:@"Select an end date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(endDate:) origin:textField];
        [self hideKeyboards];
        return NO;
    }
    
    return YES;
}

- (void)startDate:(id)sender
{
    self.startDateTextField.text = [self.dateFormatter stringFromDate:sender];
}

- (void)endDate:(id)sender
{
    self.endDateTextField.text = [self.dateFormatter stringFromDate:sender];
}

- (void)hideKeyboards
{
    [self.addressTextField resignFirstResponder];
    [self.distanceTextField resignFirstResponder];
}

- (void)search:(id)sender
{
    CASSubletQuery *query = [[CASSubletQuery alloc] init];
    query.address = self.addressTextField.text;
    query.radius = @([self.distanceTextField.text integerValue]);
    query.startDate = [self.dateFormatter dateFromString:self.startDateTextField.text];
    query.endDate = [self.dateFormatter dateFromString:self.endDateTextField.text];
    [[[CASServiceLocator sharedInstance].subletService getSubletsWithQuery:query] continueWithSuccessBlock:^id(BFTask *task) {
        if ([task.result count] < 1) {
            [SVProgressHUD showErrorWithStatus:@"No sublets found!"];
            return nil;
        }
        
        [self.delegate searchViewControllerDidStartSearchingWithTask:task query:query];
        return nil;
    }];
}

@end
