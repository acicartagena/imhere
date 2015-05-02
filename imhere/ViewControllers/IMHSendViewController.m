//
//  IMHSendViewController.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHSendViewController.h"

#import "IMHLocationPickerViewController.h"

#import "IMHKeyboardToolbar.h"
#import "IMHTextView.h"

#import "IMHUserDefaultsManager.h"
#import "IMHConnectionManager.h"

#import "IMHLocation.h"
#import "IMHNote.h"

@interface IMHSendViewController ()<IMHLocationPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet IMHTextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) IMHNote *note;
@property (strong, nonatomic) IMHLocation *selectedLocation;

@property (strong, nonatomic) IMHKeyboardToolbar *keyboardToolbar;

@end

@implementation IMHSendViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.toTextField.layer.cornerRadius = 5.0f;
    self.toTextField.clipsToBounds = YES;
    self.toTextField.inputAccessoryView = self.keyboardToolbar;
    
    self.messageTextView.inputAccessoryView = self.keyboardToolbar;
    self.messageTextView.placeholder = @"Type your message here";
    
    self.locationButton.layer.cornerRadius = 5.0f;
    self.locationButton.clipsToBounds = YES;
}

#pragma mark - properties
- (IMHKeyboardToolbar *)keyboardToolbar
{
    if (!_keyboardToolbar){
        _keyboardToolbar = [[IMHKeyboardToolbar alloc] init];
        _keyboardToolbar.parentView = self.view;
        __weak typeof(self) weakSelf = self;
        _keyboardToolbar.clearKeyboard = ^{
            if ([weakSelf.toTextField isFirstResponder]){
                weakSelf.toTextField.text = @"";
            }else{
                weakSelf.messageTextView.text = @"";
            }
        };
        _keyboardToolbar.closeKeyboard = ^{
            [weakSelf.view endEditing:YES];
        };
    }
    return _keyboardToolbar;
}

- (IMHNote *)note
{
    if (!_note){
        _note = [[IMHNote alloc] init];
    }
    return _note;
}

#pragma mark - ibactions

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectLocation:(id)sender
{
    [self performSegueWithIdentifier:sendToLocationPickerSegueId sender:self];
}

- (IBAction)sendMessage:(id)sender
{
    if (self.selectedLocation == nil){
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"You need to specify a location mate. Thanks!" delegate:nil cancelButtonTitle:@"Yeah, Sure" otherButtonTitles:nil] show];
        return;
    }
    
#warning to textfield processing
    self.note.to = @[self.toTextField.text];
    self.note.from = [[IMHUserDefaultsManager sharedManager] userId];
    
    self.note.message = self.messageTextView.text;
    self.note.latitude =  self.selectedLocation == nil ? @"-33.8678500" : self.selectedLocation.latitude;
    self.note.longitude = self.selectedLocation == nil ?  @"151.2073200" : self.selectedLocation.longitude;
    self.note.send_timestamp = [NSDate date];
    self.note.radius = 5;
    self.note.loc_name = self.selectedLocation == nil ? @"Sydney": self.selectedLocation.locationName;
    
    [[IMHConnectionManager sharedManager] sendMessage:self.note completion:^(NSError *error) {
        NSLog(@"message sent?");
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - location picker delegate

- (void)locationSelected:(IMHLocation *)location
{
    self.selectedLocation = location;
    [self.locationButton setTitle:location.locationName forState:UIControlStateNormal];
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:sendToLocationPickerSegueId]){
        IMHLocationPickerViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


@end
