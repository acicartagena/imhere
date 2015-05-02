//
//  IMHUserDefaultsManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHUserDefaultsManager.h"

static IMHUserDefaultsManager *_instance = nil;

@implementation IMHUserDefaultsManager

@synthesize userId = _userId;
@synthesize notes = _notes;
@synthesize notesArray = _notesArray;
//@synthesize repliesId = _repliesId;
//@synthesize repliesParentId = _repliesParentId;

+ (IMHUserDefaultsManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHUserDefaultsManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        if (!self.notes){
            self.notes = [[NSMutableDictionary alloc] init];
        }
        
        if (!self.notesArray){
            self.notesArray = [[NSMutableArray alloc] init];
        }
        
//        if (!self.repliesId){
//            self.repliesId = [[NSMutableDictionary alloc] init];
//        }
//        
//        if (!self.repliesParentId){
//            self.repliesParentId = [[NSMutableDictionary alloc] init];
//        }
    }
    return self;
}

#pragma mark - properties
- (NSString *)userId
{
    if (!_userId){
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        _userId = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _userId;
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userId];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)notes
{
    if (!_notes){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notes"] isKindOfClass:[NSData class]]){
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
            _notes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _notes;
}

- (void)setNotes:(NSMutableDictionary *)notes
{
    _notes = notes;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notes];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)notesArray
{
    if (!_notesArray){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notesArray"] isKindOfClass:[NSData class]]){
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"notesArray"];
            _notesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _notesArray;
}

- (void)setNotesArray:(NSMutableArray *)notesArray
{
    _notesArray = notesArray;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notesArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notesArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - helper public methods
- (void)saveData
{
    self.notesArray = [_notesArray copy];
    self.notes = [_notes copy];
}

@end
