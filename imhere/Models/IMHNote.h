//
//  Note.h
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "JSONModel.h"

@interface IMHNote : JSONModel

@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSArray *to;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *loc_name;
@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic, assign) NSInteger radius;
@property (strong, nonatomic) NSString *message;

- (NSString *)timestampString;

@end
