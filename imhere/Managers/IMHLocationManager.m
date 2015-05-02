//
//  IMHLocationManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHLocationManager.h"

static IMHLocationManager *_instance = nil;

@implementation IMHLocationManager

+ (IMHLocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHLocationManager alloc] init];
    });
    return _instance;
}

@end
