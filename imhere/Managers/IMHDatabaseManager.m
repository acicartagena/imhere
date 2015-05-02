//
//  IMHDatabaseManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHDatabaseManager.h"
#import "IMHConstants.h"

#import "IMHNote.h"
#import "IMHReply.h"

//#import <YapDatabase/YapDatabase.h>

#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YapDatabaseFullTextSearch.h"
#import "YapDatabaseSearchResultsView.h"

#define kVersionTag @"1" //increment every time there are changes to groups&sorts

static IMHDatabaseManager *_instance = nil;

@interface IMHDatabaseManager ()

@property (strong, nonatomic) YapDatabase *database;

@property (strong, nonatomic) YapDatabaseConnection *backgroundConnection;
@property (strong, nonatomic) YapDatabaseConnection *mainConnection;

@end

@implementation IMHDatabaseManager

+ (IMHDatabaseManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHDatabaseManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        
        NSString *databaseName = @"database.sqlite";
        
        NSString *databasePath = [baseDir stringByAppendingPathComponent:databaseName];
        
        [[NSFileManager defaultManager] removeItemAtPath:databasePath error:NULL];
        
        self.database = [[YapDatabase alloc] initWithPath:databasePath];
    }
    return self;
}

#pragma mark - properties
- (YapDatabaseConnection *)backgroundConnection
{
    if (!_backgroundConnection){
        _backgroundConnection = [self.database newConnection];
    }
    return _backgroundConnection;
}

- (YapDatabaseConnection *)mainConnection
{
    if (!_mainConnection){
        _mainConnection = [self.database newConnection];
    }
    return _mainConnection;
}

#pragma mark - private methods
- (void)setupAllNotes
{
    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection, NSString *key, id object) {
        return @"all";
    }];
    YapDatabaseViewSorting *sorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        
        __unsafe_unretained IMHNote *note1 = (IMHNote *)object1;
        __unsafe_unretained IMHNote *note2 = (IMHNote *)object2;
        
        return [note1.id compare:note2.id options:NSNumericSearch];
    }];
    
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:grouping sorting:sorting versionTag:kVersionTag];
    [self.database registerExtension:databaseView withName:@"allNotes"];
}

- (void)setupUnreadNotes
{
    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection, NSString *key, id object) {
        if ([object isKindOfClass:[IMHNote class]]){
            IMHNote *note = (IMHNote *)object;
            if (!note.rcv_timestamp){
                return @"notes";
            }
        }
        return nil;
    }];
    YapDatabaseViewSorting *sorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        
        __unsafe_unretained IMHNote *note1 = (IMHNote *)object1;
        __unsafe_unretained IMHNote *note2 = (IMHNote *)object2;
        
        return [note1.id compare:note2.id options:NSNumericSearch];
    }];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:grouping sorting:sorting versionTag:kVersionTag];
    [self.database registerExtension:databaseView withName:@"unreadNotes"];
}

#pragma mark - public methods
- (void)saveNotes:(NSArray *)notes completionBlock:(void (^)(void))completionBlock
{
    [self.backgroundConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (IMHNote *note in notes){
            [transaction setObject:note forKey:note.id inCollection:@"notes"];
        }
    } completionBlock:^{
        if (completionBlock){
            completionBlock();
        }
    }];
}

- (void)saveNote:(IMHNote *)note completionBlock:(void (^)(void))completionBlock
{
    [self.backgroundConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:note forKey:note.id inCollection:@"notes"];
    } completionBlock:^{
        if (completionBlock){
            completionBlock();
        }
    }];
}

- (void)saveReplies:(NSArray *)replies completionBlock:(void (^)(void))completionBlock
{
    [self.backgroundConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (IMHReply *reply in replies){
            [transaction setObject:replies forKey:reply.id inCollection:@"replies"];
        }
    } completionBlock:^{
        if (completionBlock){
            completionBlock();
        }
    }];
}

- (void)saveReply:(IMHReply *)reply completionBlock:(void (^)(void))completionBlock
{
    [self.backgroundConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:reply forKey:reply.id inCollection:@"replies"];
    } completionBlock:^{
        if (completionBlock){
            completionBlock();
        }
    }];
}



@end
