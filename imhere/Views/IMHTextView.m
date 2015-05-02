//
//  IMHTextView.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHTextView.h"

@interface IMHTextView ()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation IMHTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
        [self registerKeyboardObservers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
        [self registerKeyboardObservers];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterKeyboardObvserver];
}


- (void)setup
{
    self.placeholderColor = [UIColor colorWithRed:90.0f/255.0f green:101.0f/255.0f blue:109.0f/255.0f alpha:1.0f];;
    self.textColor = [UIColor colorWithRed:90.0f/255.0f green:101.0f/255.0f blue:109.0f/255.0f alpha:1.0f];
    self.font = [UIFont systemFontOfSize:14.0];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)registerKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)unregisterKeyboardObvserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - properties
- (UILabel *)placeholderLabel
{
    if (!_placeholder) {
        return nil;
    }
    
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:101.0f/255.0f blue:109.0f/255.0f alpha:1.0f];
        _placeholderLabel.hidden = YES;
        
//        CGRect frame = _placeholderLabel.frame;
//        frame.origin.y = self.frame.origin.y;
//        frame.size.height = 50.0f;
//        _placeholderLabel.frame = frame;
        
        [self addSubview:_placeholderLabel];
    }
    
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if ([placeholder isEqualToString:_placeholder]) {
        return;
    }
    
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

#pragma mark - super class methods
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self _textViewDidChange:nil];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = self.font;
}

#pragma mark - public methods
- (void)scrollToCaretPositonAnimated:(BOOL)animated
{
    if (animated) {
        [self scrollRangeToVisible:self.selectedRange];
    }
    else {
        [UIView performWithoutAnimation:^{
            [self scrollRangeToVisible:self.selectedRange];
        }];
    }
}

#pragma mark - Notifications

- (void)_textViewDidChange:(NSNotification *)notification
{
    if (self.placeholder.length == 0) {
        return;
    }
    
    _placeholderLabel.hidden = (self.text.length > 0) ? YES : NO;
}

- (BOOL)shouldRenderPlaceholder
{
    if (_placeholderLabel.hidden && self.placeholder.length > 0 && self.text.length == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UIViewRendering

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!_placeholder) {
        return;
    }
    
    if ([self shouldRenderPlaceholder]) {
        CGRect frame = self.bounds;
        frame.origin.x += 5.0;
        frame.origin.y += 10.0;
        frame.size.height = 16.0f;
        _placeholderLabel.frame = frame;
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.hidden = NO;
        
        [self sendSubviewToBack:_placeholderLabel];
    }
}

@end
