//
//  BeaconManager.h
//  EstimoteV1
//
//  Created by Nicolas Flacco on 3/1/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
@import CoreBluetooth;
@import CoreLocation;

@class BeaconManager;

@protocol BeaconManagerDelegate <NSObject>

-(void)discoveredBeacon:(NSString *)key distance:(NSString *)distanceStr;

@end

@interface BeaconManager : NSObject

@property(nonatomic) id <BeaconManagerDelegate> delegate;
+(BeaconManager*)sharedInstance;

@end
