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
                completionBlock(error);
                break;
            case PNSubscriptionProcessSubscribedState:
                // PubNub client completed subscription on specified set of channels.
                completionBlock(nil);
                break;
            default:
                break;
        }
    }];
}

@end
