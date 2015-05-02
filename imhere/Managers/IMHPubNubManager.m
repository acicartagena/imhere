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

@interface IMHPubNubManager ()<PNDelegate>

@end

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
        PNConfiguration *configuration = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com" publishKey:@"pub-c-a15144f1-ecc4-4d3c-87b8-ef4a92d79910"
            subscribeKey:@"sub-c-5ffc49e0-f098-11e4-be1f-0619f8945a4f"
                                                       secretKey:@"sec-c-YmFlZTc4MDQtNjM2Yy00MTZiLWFjMGYtYzkzMGFmODI5N2Q1"];
        [PubNub setConfiguration:configuration];
        [PubNub connect];
        
        [PubNub setDelegate:self];
    }
    return self;
}

- (void) joinChannel:(NSString *) channelName completion:(void (^)(NSError *error))completionBlock
{
    PNChannel *channel = [PNChannel channelWithName:channelName];
    
    [PubNub subscribeOn:@[channel]
withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error) {
        switch (state) {
            case PNSubscriptionProcessNotSubscribedState:
                NSLog(@"not subscribed");
                // There should be a reason because of which subscription failed and it can be found in 'error' instance
                if (completionBlock)
                    completionBlock(error);
                break;
            case PNSubscriptionProcessSubscribedState:
                NSLog(@"subscribed");
                // PubNub client completed subscription on specified set of channels.
                if (completionBlock)
                    completionBlock(nil);
                break;
            default:
                break;
        }
    }];
}

#pragma mark - delegate
- (void)pubnubClient:(PubNub *)client error:(PNError *)error
{
    NSLog(@"pubnub client error: %@",error);
}

- (void)pubnubClient:(PubNub *)client didDisconnectFromOrigin:(NSString *)origin withError:(PNError *)error
{
    NSLog(@"pubnub client disconnect from origin: %@",error);
}

- (void)pubnubClient:(PubNub *)client willSuspendWithBlock:(void(^)(void(^)(void(^)(void))))preSuspensionBlock
{
    NSLog(@"pubnub suspend");
}

- (void)pubnubClient:(PubNub *)client didSubscribeOn:(NSArray *)channelObjects
{
    NSLog(@"pubnub subscribe on: %@",channelObjects);
}

- (void)pubnubClient:(PubNub *)client didEnablePushNotificationsOnChannels:(NSArray *)channels
{
    NSLog(@"pubnub enable push: %@",channels);
}

- (void)pubnubClient:(PubNub *)client pushNotificationEnableDidFailWithError:(PNError *)error
{
    NSLog(@"push notif enable fail: %@",error);
}

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message
{
    NSLog(@"pubnub receive message: %@",message);
}

@end
