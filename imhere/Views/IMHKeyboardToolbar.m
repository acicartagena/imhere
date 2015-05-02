//
//  IMHKeyboardToolbar.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHKeyboardToolbar.h"

@implementation IMHKeyboardToolbar


- (instancetype)init
{
    self = [super init];
    if (self){
        self.barStyle = UIBarStyleDefault;
        
        self.frame = CGRectMake(0, self.parentView.frame.size.height - 44, self.parentView.frame.size.width, 44);
        
        UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(clearTextView)];
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self action:@selector(closeTextViewKeyboard)];
        
        NSArray *items = [NSArray arrayWithObjects:clearItem,flexItem,doneItem, nil];
        [self setItems:items animated:YES];
    }
    return self;
}

- (void)clearTextView
{
    if (self.clearKeyboard){
        self.clearKeyboard();
    }
}

- (void)closeTextViewKeyboard
{
    if (self.closeKeyboard){
        self.closeKeyboard();
    }
}

@end
