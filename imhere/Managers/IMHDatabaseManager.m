//
//  IMHDatabaseManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHDatabaseManager.h"
#import "IMHConstants.h"

#import "YapDatabase.h"
//#import "YapDatabaseView.h"
//#import "YapDatabaseFullTextSearch.h"
//#import "YapDatabaseSearchResultsView.h"

static IMHDatabaseManager *_instance = nil;

@interface IMHDatabaseManager ()

@property (strong, nonatomic) YapDatabase *database;

@property (strong, nonatomic) YapDatabaseConnection *readWriteConnection;
@property (strong, nonatomic) YapDatabaseConnection *mainReadConnection;

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
- (YapDatabaseConnection *)readWriteConnection
{
    if (!_readWriteConnection){
        _readWriteConnection = [self.database newConnection];
    }
    return _readWriteConnection;
}

- (YapDatabaseConnection *)mainReadConnection
{
    if (!_mainReadConnection){
        _mainReadConnection = [self.database newConnection];
    }
    return _mainReadConnection;
}

#pragma mark - public methods

@end
