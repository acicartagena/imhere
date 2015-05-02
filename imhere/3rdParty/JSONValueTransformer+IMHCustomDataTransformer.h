//
//  JSONValueTransformer+IMHCustomDataTransformer.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (IMHCustomDataTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string;

@end
