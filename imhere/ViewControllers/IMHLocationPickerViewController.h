//
//  IMHLocationPickerViewController.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMHLocation;

@protocol IMHLocationPickerDelegate <NSObject>

- (void)locationSelected:(IMHLocation *)location;

@end

@interface IMHLocationPickerViewController : UIViewController

@property (nonatomic, weak) id<IMHLocationPickerDelegate> delegate;

@end
