//
//  IMHPubNubManager.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNImports.h"


@interface IMHPubNubManager : NSObject

+ (IMHPubNubManager *)sharedManager;

- (void) joinChannel:(NSString *) channelName completion:(void (^)(NSError *error))completionBlock;

@end
