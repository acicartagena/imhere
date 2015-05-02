//
//  Reply.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHReply.h"

@implementation IMHReply

//@property (strong, nonatomic) NSString *id;
//@property (strong, nonatomic) NSString *parent_id;
//@property (strong, nonatomic) NSString *from;
//@property (strong, nonatomic) NSString *message;
//@property (strong, nonatomic) NSDate *timestamp;

#pragma mark - nscoding
- (id)initWithCoder:(NSCoder *)decoder // NSCoding deserialization
{
    if ((self = [super init])) {
        self.from = [decoder decodeObjectForKey:@"from"];
        self.send_timestamp = [decoder decodeObjectForKey:@"send_timestamp"];
        self.rcv_timestamp = [decoder decodeObjectForKey:@"rcv_timestamp"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.parent_id = [decoder decodeObjectForKey:@"parent_id"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder // NSCoding serialization
{
    [encoder encodeObject:self.from forKey:@"from"];
    [encoder encodeObject:self.send_timestamp forKey:@"send_timestamp"];
    [encoder encodeObject:self.rcv_timestamp forKey:@"rcv_timestamp"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.parent_id forKey:@"parent_id"];
}

#pragma mark - jsonmodel
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSString *)timestampString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:self.send_timestamp];
}

@end
