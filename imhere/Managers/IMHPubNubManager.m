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
        
        //[PubNub setDelegate:self];
    }
    return self;
}

- (void) joinChannel:(NSString *) channelName completion:(void (^)(NSError *error))completionBlock
{
    PNChannel *channel = [PNChannel channelWithName:channelName shouldObservePresence:YES];
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
            
            // Subscribe on connect
            [PubNub subscribeOnChannel:channel];
            
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
                
                // ...skip the apns enabled check
                // Enable APNS on this Channel with deviceToken
                [PubNub enablePushNotificationsOnChannel:channel
                 
                                     withDevicePushToken:deviceToken
                              andCompletionHandlingBlock:^(NSArray *channel, PNError *error){
                                  NSLog(@"BLOCK: enablePushNotificationsOnChannel: %@ , Error %@",channel,error);
                              }];
            }
        }
        else if (!connected || connectionError != nil )
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
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
