//
//  IMHNoteFeedTableViewCell.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMHNote;

static NSString *noteFeedTableViewCellIdentifier = @"noteFeedTableViewCell";

@interface IMHNoteFeedTableViewCell : UITableViewCell

@property (strong, nonatomic) IMHNote *note;

- (CGFloat)getHeightForNote:(IMHNote *)note; //to be used by prototype cell

@end
