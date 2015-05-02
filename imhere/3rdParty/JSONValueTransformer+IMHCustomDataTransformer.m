//
//  JSONValueTransformer+IMHCustomDataTransformer.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "JSONValueTransformer+IMHCustomDataTransformer.h"

@implementation JSONValueTransformer (IMHCustomDataTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    return [formatter dateFromString:string];
}


@end
