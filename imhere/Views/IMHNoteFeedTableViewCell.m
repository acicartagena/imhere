//
//  IMHNoteFeedTableViewCell.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHNoteFeedTableViewCell.h"

#import "UITableViewCell+DynamicCellHeight.h"

#import "IMHNote.h"

@interface IMHNoteFeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation IMHNoteFeedTableViewCell

- (CGFloat)getHeightForNote:(IMHNote *)note
{
    self.note = note;
    return [self getTableViewCellHeight];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNote:(IMHNote *)note
{
    _note = note;
    
    self.senderNameLabel.text = note.from;
    self.messageTextView.text = note.message;
    self.locationLabel.text = note.loc_name;
}

@end
