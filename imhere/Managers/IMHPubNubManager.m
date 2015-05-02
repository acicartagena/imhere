//
//  IMHPubNubManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHPubNubManager.h"

#import <PubNub/PubNub.h>

static IMHPubNubManager *_instance = nil;

@implementation IMHPubNubManager

+ (IMHPubNubManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHPubNubManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

@end
