//
//  IMHSendViewController.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHSendViewController.h"

#import "IMHKeyboardToolbar.h"
#import "IMHTextView.h"

#import "IMHConnectionManager.h"
#import "IMHNote.h"

@interface IMHSendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet IMHTextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) IMHNote *note;

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
    self.toTextField.inputAccessoryView = self.keyboardToolbar;
    self.messageTextView.inputAccessoryView = self.keyboardToolbar;
    self.messageTextView.placeholder = @"Type your message here";
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
    self.note.message = self.messageTextView.text;
#warning to textfield processing
    self.note.to = @[@"aci"];//@[self.toTextField.text];
    self.note.from = @"aci";
    self.note.latitude = @"-33.8678500";
    self.note.longitude = @"151.2073200";
    self.note.timestamp = [NSDate date];
    self.note.radius = 5;
    self.note.loc_name = @"Sydney";
    
    
    [[IMHConnectionManager sharedManager] sendMessage:self.note completion:^(NSError *error) {
        NSLog(@"message sent?");
    }];
}



@end
