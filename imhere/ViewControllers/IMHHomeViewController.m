//
//  IMHHomeViewController.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHHomeViewController.h"
#import "IMHConnectionManager.h"

@implementation IMHHomeViewController

- (IBAction)heya:(id)sender
{
    [[IMHConnectionManager sharedManager] heya];
}

- (IBAction)newMessage:(id)sender
{
    [self performSegueWithIdentifier:homeToNewNoteSegueId sender:nil];
}

@end
