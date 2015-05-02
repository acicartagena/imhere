//
//  IMHLocationManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHLocationManager.h"

#import <CoreLocation/CoreLocation.h>
#import "IMHLocation.h"

static IMHLocationManager *_instance = nil;

@interface IMHLocationManager ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation IMHLocationManager

+ (IMHLocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMHLocationManager alloc] init];
    });
    return _instance;
}

#pragma mark - properties
- (CLGeocoder *)geocoder
{
    if (!_geocoder){
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)forwardGeocodeLocationWithName:(NSString *)locationName withCompletionBlock:(void (^)(NSArray *locations))completionBlock
{
 
    [self.geocoder geocodeAddressString:locationName
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          
                          if (placemarks.count == 0){
                              return;
                          }
                                              
                          NSMutableArray *locations = [[NSMutableArray alloc] init];
                          
                          for (CLPlacemark *placemark in placemarks){
                              CLLocation *location = placemark.location;
                              CLLocationCoordinate2D coordinate = location.coordinate;
                              
                              IMHLocation *loc = [[IMHLocation alloc] init];
                              loc.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                              loc.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
                              loc.locationName = placemark.name;
                              
                              [locations addObject:loc];
                          }
                          if (completionBlock){
                              completionBlock(locations);
                          }
                      }];
    
}


@end
