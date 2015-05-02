//
//  IMHLocationManager.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMHLocation;

@interface IMHLocationManager : NSObject

+ (IMHLocationManager *)sharedManager;

- (void)forwardGeocodeLocationWithName:(NSString *)locationName withCompletionBlock:(void (^)(NSArray *locations))completionBlock;

@end
