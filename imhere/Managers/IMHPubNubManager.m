//
//  IMHPubNubManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHPubNubManager.h"
#import "AppDelegate.h"

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
        PNConfiguration *configuration = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com" publishKey:@"pub-c-a15144f1-ecc4-4d3c-87b8-ef4a92d79910"
            subscribeKey:@"sub-c-5ffc49e0-f098-11e4-be1f-0619f8945a4f"
                                                       secretKey:@"sec-c-YmFlZTc4MDQtNjM2Yy00MTZiLWFjMGYtYzkzMGFmODI5N2Q1"];
        [PubNub setConfiguration:configuration];
        [PubNub connect];
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
                // There should be a reason because of which subscription failed and it can be found in 'error' instance
                if (completionBlock)
                    completionBlock(error);
                break;
            case PNSubscriptionProcessSubscribedState:
                // PubNub client completed subscription on specified set of channels.
                if (completionBlock)
                    completionBlock(nil);
                break;
            default:
                break;
        }
    }];
    
    // #3 Define AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // #4 Pass the deviceToken from the Delegate
    NSData *deviceToken = appDelegate.dToken;
    
    // #5 Double check we've passed the token properly
    NSLog(@"Device token received: %@", deviceToken);
    
    // #6 If we have the device token, enable apns for our channel if it isn't already enabled.
    if (deviceToken) {
        
        // APNS enabled already?
        [PubNub requestPushNotificationEnabledChannelsForDevicePushToken:deviceToken
                                             withCompletionHandlingBlock:^(NSArray *channels, PNError *error){
                                                 if (channels.count == 0 )
                                                 {
                                                     NSLog(@"BLOCK: requestPushNotificationEnabledChannelsForDevicePushToken: Channel: %@ , Error %@",channels,error);
                                                     
                                                     // Enable APNS on this Channel with deviceToken
                                                     [PubNub enablePushNotificationsOnChannel:channel
                                                                          withDevicePushToken:deviceToken
                                                                   andCompletionHandlingBlock:^(NSArray *channel, PNError *error){
                                                                       NSLog(@"BLOCK: enablePushNotificationsOnChannel: %@ , Error %@",channel,error);
                                                                   }];
                                                 }
                                             }];
    }
}

@end
