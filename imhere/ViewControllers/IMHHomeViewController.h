//
//  IMHHomeViewController.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const homeToNewNoteSegueId = @"homeToNewNote";
static NSString *const homeToMessageSegueId = @"homeToMessage";

@interface IMHHomeViewController : UIViewController


- (void) getData;

@end
