//
//  IMHNoteFeedTableViewCell.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHNoteFeedTableViewCell.h"

#import "UITableViewCell+DynamicCellHeight.h"

#import <PureLayout/PureLayout.h>

#import "IMHNote.h"

@interface IMHNoteFeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) UILabel *sender;
@property (strong, nonatomic) UITextView *messageText;
@property (strong, nonatomic) UILabel *location;

@property (nonatomic, assign) BOOL didUpdateConstraints;

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


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraints){
        
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        self.contentView.bounds = CGRectMake(0.0f, 0.0f, window.frame.size.width, 99999.0f);
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.sender autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            [self.messageText autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            [self.location autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [self.sender autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0f];
        [self.sender autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0f];
        [self.sender autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f];
        
        [self.sender autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.messageText withOffset:-8.0f];
        
        [self.messageText autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0f];
        [self.messageText autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0f];
        [self.messageText autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.location withOffset:-8.0f];
        
        [self.messageText autoSetDimension:ALDimensionWidth toSize:270.0f relation:NSLayoutRelationGreaterThanOrEqual];
        [self.messageText autoSetDimension:ALDimensionHeight toSize:80.0f relation:NSLayoutRelationGreaterThanOrEqual];
        
        [self.location autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0f];
        [self.location autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0f];
        [self.location autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f];
        
        self.didUpdateConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel *)sender
{
    if (!_sender){
        _sender = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_sender];
    }
    return _sender;
}

- (UITextView *)messageText
{
    if (!_messageText){
        _messageText = [UITextView newAutoLayoutView];
        [self.contentView addSubview:_messageText];
    }
    return _messageText;
}

- (UILabel *)location
{
    if (!_location){
        _location = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_location];
    }
    return _location;
}

- (void)setNote:(IMHNote *)note
{
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _note = note;
    
    
    self.sender.text = [NSString stringWithFormat:@"from: %@",note.from];
    
    self.messageText.text = note.message;
    [self.messageText sizeToFit];
    
    self.location.text = note.loc_name;
    
    [self.contentView updateConstraints];
}

@end
