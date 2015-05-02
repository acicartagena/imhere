//
//  UITableViewCell+DynamicCellHeight.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "UITableViewCell+DynamicCellHeight.h"

@implementation UITableViewCell (DynamicCellHeight)

- (CGFloat)getTableViewCellHeight
{
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    self.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(window.bounds), CGRectGetHeight(window.bounds));
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    NSLayoutConstraint *widthConstraint;
    for (NSLayoutConstraint *constraint in self.contentView.constraints){
        //find the existing width constraint of content view
        if ([constraint.firstItem isEqual:self.contentView] &&
            constraint.firstAttribute == NSLayoutAttributeWidth){
            widthConstraint = constraint;
            break;
        }
    }
    //add width constraint
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:CGRectGetWidth(window.frame)];
    
    widthConstraint.constant = tempWidthConstraint.constant;
    [self.contentView addConstraint:tempWidthConstraint];
    
    CGSize fittingSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = fittingSize.height +1;
    [self.contentView removeConstraint:tempWidthConstraint];
    
    return height;
}


@end
