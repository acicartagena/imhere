//
//  IMHUserDefaultsManager.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMHNote.h"
#import "IMHReply.h"
#import "IMHThread.h"

@interface IMHUserDefaultsManager : NSObject

+ (IMHUserDefaultsManager *)sharedManager;

@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSMutableDictionary *notes;
@property (strong, nonatomic) NSMutableArray *notesArray;

- (void)saveData;

//@property (strong, nonatomic) NSMutableDictionary *repliesId; //id is the key
//@property (strong, nonatomic) NSMutableDictionary *repliesParentId; //dictionary of mutable arrays based on parent key

@end
