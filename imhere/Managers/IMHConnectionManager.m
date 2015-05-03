//
//  IMHConnectionManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//


#import "IMHConnectionManager.h"

#import "IMHUserDefaultsManager.h"

#import "IMHNote.h"
#import "IMHReply.h"
#import "IMHFeed.h"
#import "IMHLocation.h"

static IMHConnectionManager *_instance = nil;

@interface IMHConnectionManager ()


@end

@implementation IMHConnectionManager

+ (IMHConnectionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1204 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
        [config setURLCache:cache];
        
        _instance = [[IMHConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:config];
        _instance.responseSerializer = [AFJSONResponseSerializer serializer];
        _instance.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSMutableSet *set = [NSMutableSet setWithSet:_instance.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        _instance.responseSerializer.acceptableContentTypes = set;
        
    });
    return _instance;
}

#pragma mark - public methods

- (NSURLSessionDataTask *)heya
{
    return [self POST:@"heya/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"yey");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"aww");
    }];
}

- (NSURLSessionDataTask *) handlePost:(NSString *)pathName withParameters:(NSDictionary *) parameters completion:(void(^)(NSError *error)) completionBlock
{
    return [self POST:pathName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completionBlock){
            completionBlock(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock){
            completionBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)registerUID:(NSString *) uid channel:(NSString *) channel completion:(void(^)(NSError *error)) completionBlock
{
    NSString *pathName = @"register/";
    NSDictionary *parameters = @{@"uid": uid, @"channel": channel};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *)sendMessage:(IMHNote *)note completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"send/";
    NSDictionary *parameters = @{@"from":note.from,
                                 @"to":note.to,
                                 @"lat":note.latitude,
                                 @"long":note.longitude,
                                 @"send_timestamp":[note timestampString],
                                 @"radius":@(note.radius),
                                 @"loc_name":note.loc_name,
                                 @"message":note.message};
    
    
    return [self POST:pathName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        IMHNote *note2 = note;
//        note2.identification = [[responseObject objectForKey:@"id"] integerValue];
//        
//        [[IMHUserDefaultsManager sharedManager].notes setObject:note2 forKey:@(note2.identification)];
        if (completionBlock){
            completionBlock(nil);
        }
        
//        [[IMHDatabaseManager sharedManager] saveNote:note2 completionBlock:^{
//            if (completionBlock){
//                completionBlock(nil);
//            }
//        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock){
            completionBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *) replyMessage:(IMHReply *)note completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"reply/";
    NSDictionary *parameters = @{@"from":note.from,
                                 @"parent_id":note.parent_id,
                                 @"send_timestamp":[note timestampString],
                                 @"message":note.message};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *) fetchUnread:(NSString *)uid completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"fetch/";
    NSDictionary *parameters = @{@"uid": uid};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *) readReceipt:(NSString *)uid messageID:(NSString *)messageID completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"imread/";
    NSDictionary *parameters = @{@"uid": uid, @"msg_id": messageID};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *) getNoteReplies:(NSString *)uid messageID:(NSString *)messageID completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"note/";
    NSDictionary *parameters = @{@"uid": uid, @"note_id": messageID};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *) locationPing:(NSString *)uid lat:(NSString *)lat longt:(NSString *)longt completion:(void (^)(NSError *error)) completionBlock
{
    NSString *pathName = @"fetch/";
    NSDictionary *parameters = @{@"uid": uid, @"msg_id": lat, @"long": longt};
    
    return [self handlePost:pathName withParameters:parameters completion:completionBlock];
}

- (NSURLSessionDataTask *)fetchAll:(NSString *)userId completion:(void (^)(NSError *error))completionBlock
{
    NSString *pathName = @"fetchall/";
    NSDictionary *parameters = @{@"uid":userId};
    
    return [self POST:pathName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        IMHFeed *feed = [[IMHFeed alloc] initWithDictionary:dict error:&error];
        
        for (IMHNote *note in feed.notes){
            [[IMHUserDefaultsManager sharedManager].notes setObject:note forKey:@(note.identification)];
        }
        
        if (completionBlock){
            completionBlock(nil);
        }
        
//        [[IMHDatabaseManager sharedManager] saveNotes:feed.notes completionBlock:^{
//            NSLog(@"finished saving notes");
//            [[IMHDatabaseManager sharedManager] saveReplies:feed.replies completionBlock:^{
//                NSLog(@"finished saving replies");
//                if (completionBlock){
//                    completionBlock(nil);
//                }
//            }];
//        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock){
            completionBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)pingLocation:(IMHLocation *)location
{
    NSString *pathName = @"loc_ping/";
    NSDictionary *parameters = @{@"uid":[[IMHUserDefaultsManager sharedManager] userId],@"lat":location.latitude,@"long":location.longitude};
    return [self POST:pathName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ping yey");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ping aww");
    } ];
}

@end
