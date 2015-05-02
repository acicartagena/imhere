//
//  IMHTextView.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMHTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) UIColor *placeholderColor;

@property (nonatomic, readwrite) NSUInteger maxNumberOfLines;

- (void)scrollToCaretPositonAnimated:(BOOL)animated;

@end
