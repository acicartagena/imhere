//
//  Reply.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "JSONModel.h"

@interface IMHReply : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *parent_id;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *timestamp;

@end
