//
//  AppDelegate.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "AppDelegate.h"
#import "JSONModel.h"
#import "AFNetworkActivityLogger.h"
#import "IMHPubNubManager.h"

#import "IMHUserDefaultsManager.h"

#import "IMHLocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize dToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    [IMHLocationManager sharedManager];
    
    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"long":@"longitude",@"lat":@"latitude", @"id":@"identification"}]];
    
    
    // #2 Register client for push notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [PubNub setDelegate:self];
    
    return YES;
}

// #3 add delegate to get the deviceToken from the APNs callback didRegisterForRemoteNotificationsWithDeviceToken
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSLog(@"DELEGATE: Device Token is: %@", deviceToken);
    
    dToken = deviceToken;
    
    // I have remote notifs now, subscribe to this channel
#warning todo actual channel
    [[IMHPubNubManager sharedManager] joinChannel:@"61424448667" completion:nil];
}


// #4 add delegate to report any errors getting the deviceToken (optional)
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"DELEGATE: Failed to get token, error: %@", error);
}

// #5 Process received push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *message = nil;
    id alert = [userInfo objectForKey:@"aps"];
    if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"alert"];
    }
    
    // TODO Delete alert code and actually do something -- refresh?
    if (alert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                            message:message  delegate:self
                                                  cancelButtonTitle:@"Thanks PubNub!"
                                                  otherButtonTitles:@"Send Me More!", nil];
        [alertView show];
    }
}

// #6 Add PubNub delegate to catch when channel in enabled with APNs
- (void)pubnubClient:(PubNub *)client didEnablePushNotificationsOnChannels:(NSArray *)channels {
    
    // This delegate method is called if push notifications for all channels are successfully enabled.
    // “channels” will contain the array of channels which have push notifications enabled.
    
    NSLog(@"DELEGATE: Enabled push notifications on channels: %@", channels);
    
}

// #7 Add PubNub delegate to catch when apns receives a push notification for a channel
- (void)pubnubClient:(PubNub *)client didReceivePushNotificationEnabledChannels:(NSArray *)channels {
    
    // This delegate method is called when the client successfully receives push notifications for a channel.
    // “channels” will contain the array of channels which received push notifications.
    
    NSLog(@"DELEGATE: Received push notifications for these enabled channels: %@", channels);
    
    
}

// #8 Add PubNub delegate to catch when client fails to enable apns for channel
- (void)pubnubClient:(PubNub *)client pushNotificationEnableDidFailWithError:(PNError *)error {
    
    // This delegate method is called when an error occurs on enabling push notifications for all channels.
    // “error” will contain the details of the error.
    
    NSLog(@"DELEGATE: Failed push notification enable. error: %@", error);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[IMHUserDefaultsManager sharedManager] saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[IMHUserDefaultsManager sharedManager] saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[IMHUserDefaultsManager sharedManager] saveData];
}


@end
