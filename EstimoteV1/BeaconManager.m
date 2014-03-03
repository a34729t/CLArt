//
//  BeaconManager.m
//  EstimoteV1
//
//  Created by Nicolas Flacco on 3/1/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "BeaconManager.h"

@interface BeaconManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableSet *registeredBeacons;

-(void)sendNotification:(NSString*)message;

@end

@implementation BeaconManager

+ (BeaconManager *)sharedInstance
{
    static dispatch_once_t once=0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(id)init{
    if (self=[super init]) {
        
        // Initialize location manager and set ourselves as the delegate
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // HACK ALERT: Hardcode our beacons into the app
        self.registeredBeacons = [[NSMutableSet alloc] initWithArray:@[BEACON_0, BEACON_1, BEACON_2, BEACON_3, BEACON_4, BEACON_5]];
        
        // Setup a new region with that UUID and same identifier as the broadcasting beacon
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:BEACON_PROXIMITY_UUID
                                                                 identifier:@"Estimote Region"];
        
        // Tell location manager to start monitoring for the beacon region
        [self.locationManager startMonitoringForRegion:self.region];
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate methods

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.region];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"Region inside:%@ ", region.identifier);
            [self.locationManager startRangingBeaconsInRegion:self.region];
            
            break;
        case CLRegionStateOutside:
             NSLog(@"Region outside:%@ ", region.identifier);
        case CLRegionStateUnknown:
            NSLog(@"Region unknown");
        default:
            // stop ranging beacons, etc
            NSLog(@"Region unknown (default case");
    }
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.region];
    NSLog(@"LM didEnterRegion");
    
    [self sendNotification:@"didEnterRegion"];
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
        [self.locationManager startRangingBeaconsInRegion:self.region];
    }
    
    
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.region];
    NSLog(@"LM didExitRegion");
    
    [self sendNotification:@"didExitRegion"];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    NSLog(@"LM didRangeBeacons");
    
    // print out all beacons
    for (CLBeacon *beacon in beacons)
    {
        NSString *uuid = beacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
        
        // HACK ALERT: We use major + minor as key
        if ([self.registeredBeacons containsObject:[NSString stringWithFormat:@"%@%@", major, minor]])
        {
            NSString *beaconKey = [NSString stringWithFormat:@"%@%@", major, minor];
            
            if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
            {
                
                NSString *distance;
                if(beacon.proximity == CLProximityUnknown) {
                    distance = @"Unknown Proximity";
                } else if (beacon.proximity == CLProximityImmediate) {
                    distance = @"Immediate";
                } else if (beacon.proximity == CLProximityNear) {
                    distance = @"Near";
                } else if (beacon.proximity == CLProximityFar) {
                    distance = @"Far";
                } else {
                    return;
                }
                
                // Fire delegate
                NSLog(@"LM major:%@ minor:%@ distance:%@", major, minor, distance);
                [self.delegate discoveredBeacon:beaconKey distance:distance];
            }
            else if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground)
            {
                [self sendNotification:beaconKey];
            }
        }
    }

}

#pragma mark local notifications

-(void)sendNotification:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
    notification.timeZone = timezone;
    notification.alertBody = message;
    notification.alertAction = @"Show";  //creates button that launches app
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber=[[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
    
    // to pass information with notification
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:message forKey:NOTIF_KEY];
    notification.userInfo = userDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
}
@end
