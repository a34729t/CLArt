//
//  CentralManager.h
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//
#import <Foundation/Foundation.h>
@import CoreBluetooth;

@class CentralManager;

@protocol CentralManagerDelegate <NSObject>

-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral rssi:(NSNumber *)RSSI;

@end

@interface CentralManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property(nonatomic) id <CentralManagerDelegate> delegate;

+(CentralManager*)sharedInstance;
- (void)startDetecting;

@end
