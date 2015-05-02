//
//  IMHConnectionManager.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "IMHConstants.h"

@class IMHNote;

@interface IMHConnectionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)heya;
- (NSURLSessionDataTask *)sendMessage:(IMHNote *)note completion:(void (^)(NSError *error))completionBlock;
- (NSURLSessionDataTask *)fetchAll:(NSString *)userId completion:(void (^)(NSError *error))completionBlock;
- (NSURLSessionDataTask *)pingLocation:(IMHLocation *)location;

@end
