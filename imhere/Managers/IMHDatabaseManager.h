//
//  IMHDatabaseManager.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMHNote;
@class IMHReply;
@class IMHThread;

@interface IMHDatabaseManager : NSObject

+ (IMHDatabaseManager *)sharedManager;

- (void)saveNotes:(NSArray *)notes completionBlock:(void (^)(void))completionBlock;
- (void)saveNote:(IMHNote *)note completionBlock:(void (^)(void))completionBlock;

- (void)saveReplies:(NSArray *)replies completionBlock:(void (^)(void))completionBlock;
- (void)saveReply:(IMHReply *)reply completionBlock:(void (^)(void))completionBlock;

- (IMHThread *)getThreadForNoteId:(NSString *)noteId;

@end
