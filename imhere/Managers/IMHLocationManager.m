//
//  IMHLocationManager.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHLocationManager.h"
#import "IMHConnectionManager.h"

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>


#import "IMHLocation.h"

static IMHLocationManager *_instance = nil;

@interface IMHLocationManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;

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

- (instancetype)init
{
    self = [super init];
    if (self){
        [self locationManager];
    }
    return self;
}

#pragma mark - properties
- (CLGeocoder *)geocoder
{
    if (!_geocoder){
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        if ([CLLocationManager locationServicesEnabled]){
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            [_locationManager startUpdatingLocation];
        }
        
        
        
    }
    return _locationManager;
}

- (NSMutableArray *)locations
{
    if (!_locations){
        _locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}

#pragma mark - cllocationmanager delegate


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    IMHLocation *loc = [[IMHLocation alloc] init];
    loc.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    loc.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [[IMHConnectionManager sharedManager] pingLocation:loc];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - public methods
- (void)forwardGeocodeLocationWithName:(NSString *)locationName withCompletionBlock:(void (^)(NSArray *locations))completionBlock
{
 
    [self.geocoder geocodeAddressString:locationName
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          
                          if (placemarks.count == 0){
                              if (completionBlock){
                                  completionBlock(nil);
                              }
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
                              loc.address = ABCreateStringWithAddressDictionary (placemark.addressDictionary,NO);
                              loc.address = [loc.address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
                              
                              [locations addObject:loc];
                          }
                          if (completionBlock){
                              completionBlock(locations);
                          }
                      }];
    
}


@end
