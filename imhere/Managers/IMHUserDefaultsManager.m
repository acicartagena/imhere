//
//  IMHUserDefaultsManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHUserDefaultsManager.h"

static IMHUserDefaultsManager *_instance = nil;

@implementation IMHUserDefaultsManager

@synthesize userId = _userId;

+ (IMHUserDefaultsManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHUserDefaultsManager alloc] init];
    });
    return _instance;
}

#pragma mark - properties
- (NSString *)userId
{
    if (!_userId){
        _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    return _userId;
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
