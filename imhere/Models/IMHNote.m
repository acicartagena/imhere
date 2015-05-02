//
//  Note.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHNote.h"

@implementation IMHNote

#pragma mark - nscoding
- (id)initWithCoder:(NSCoder *)decoder // NSCoding deserialization
{
    if ((self = [super init])) {
        self.from = [decoder decodeObjectForKey:@"from"];
        self.to = [decoder decodeObjectForKey:@"to"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.loc_name = [decoder decodeObjectForKey:@"loc_name"];
        self.send_timestamp = [decoder decodeObjectForKey:@"send_timestamp"];
        self.rcv_timestamp = [decoder decodeObjectForKey:@"rcv_timestamp"];
        self.radius = [decoder decodeIntegerForKey:@"radius"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.id = [decoder decodeObjectForKey:@"id"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder // NSCoding serialization
{
    [encoder encodeObject:self.from forKey:@"from"];
    [encoder encodeObject:self.to forKey:@"to"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.loc_name forKey:@"loc_name"];
    [encoder encodeObject:self.send_timestamp forKey:@"send_timestamp"];
    [encoder encodeObject:self.rcv_timestamp forKey:@"rcv_timestamp"];
    [encoder encodeInteger:self.radius forKey:@"radius"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.id forKey:@"id"];
}

#pragma mark - json model
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - public methods
- (NSString *)timestampString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:self.send_timestamp];
}

@end
