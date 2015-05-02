//
//  IMHThread.h
//  imhere
//
//  Created by Aci Cartagena on 5/3/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "JSONModel.h"

#import "IMHReply.h"
#import "IMHNote.h"

@interface IMHThread : JSONModel

@property (strong, nonatomic) IMHNote *note;
@property (strong, nonatomic) NSArray<IMHReply> *replies;

@end
