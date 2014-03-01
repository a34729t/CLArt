//
//  CentralManager.m
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "CentralManager.h"
#import "Config.h"

// NOTE: Services are set to nil! This means I'm discovering all of them!

@interface CentralManager()

@property(nonatomic,strong) CBCentralManager *centralManager;
@property(nonatomic,strong) NSMutableSet *connectedPeripherals;

@end

@implementation CentralManager

+ (CentralManager *)sharedInstance
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
        // We create a queue and start the central manager
        dispatch_queue_t centralQueue=dispatch_queue_create("com.flaccoDev.centralqueue", 0);
        self.centralManager=[[CBCentralManager alloc]initWithDelegate:self
                                                                queue:centralQueue
                                                              options:@{CBCentralManagerOptionRestoreIdentifierKey: CM_RESTORE_KEY}];
        self.connectedPeripherals = [[NSMutableSet alloc] init];
    }
    return self;
}


#pragma mark - Bluetooth Control Methods

- (void)startDetecting
{
    NSLog(@"CM startDetecting");
    
    NSDictionary *scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO),CBCentralManagerOptionShowPowerAlertKey:@YES};
//    [self.centralManager scanForPeripheralsWithServices:@[self.tweetNetServiceUUID] options:scanOptions];
//    [self.centralManager retrieveConnectedPeripheralsWithServices:@[self.tweetNetServiceUUID]];
//    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BEACON_0_ID], [CBUUID UUIDWithString:BEACON_1_ID], [CBUUID UUIDWithString:BEACON_2_ID], [CBUUID UUIDWithString:BEACON_3_ID], [CBUUID UUIDWithString:BEACON_4_ID], [CBUUID UUIDWithString:BEACON_5_ID]] options:scanOptions];
    
    // This won't work in background mode
    [self.centralManager scanForPeripheralsWithServices:@[] options:scanOptions];
    
    // This doesn't at all. WTF?
//    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"F76C345E-C7B1-5581-66C7-EA6589B9C6E4"]]
//                                                options:scanOptions];
    [self.centralManager retrieveConnectedPeripheralsWithServices:@[]];
}

- (void)stopDetecting
{
    [self.centralManager stopScan];
    NSLog(@"CM Scanning stopped");
}

-(void)addPeripheral:(CBPeripheral *)peripheral
{
    if (![self.connectedPeripherals containsObject:peripheral])
    {
        [self.connectedPeripherals addObject:peripheral];
    }
}

-(void)removePeripheral:(CBPeripheral *)peripheral
{
    if ([self.connectedPeripherals containsObject:peripheral])
    {
        [self.connectedPeripherals removeObject:peripheral];
    }
}

#pragma mark - CBCentralManager Delegates
// NOTE: We do not do service discovery as Estimote beacons do not support this

//call on init of centralManager to check if BT is supportted and available
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn) {
        //        [self TNLog:@"CoreBluetooth BLE hardware is powered on and ready"];
        [self startDetecting];
        
    }else if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }else if ([central state] == CBCentralManagerStateResetting) {
        NSLog(@"CoreBluetooth BLE hardware is resetting");
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    for (CBPeripheral *peripheral in peripherals)
    {
        NSLog(@"CM willRestoreState peripheral:%@", peripheral.identifier);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //Reject any where the value is above reasonable range
    if (RSSI.integerValue > -15) return;
    
    // Note: Restrict to estimote
    if ([peripheral.name isEqualToString:@"estimote"])
    {
//        [self addPeripheral:peripheral];
//        [central connectPeripheral:peripheral options:nil];
        NSLog(@"CM Discovered name:%@ id:%@ rssi:%@", peripheral.name, [peripheral.identifier UUIDString] , RSSI);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"Main Thread Code");
            [self.delegate didDiscoverPeripheral:peripheral rssi:RSSI];
        });
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    for (CBPeripheral *peripheral in peripherals){
        [self addPeripheral:peripheral];
        [central connectPeripheral:peripheral options:nil];
        NSLog(@"CM didRetrievePeripheral %@ ->Connecting", peripheral.name);
    }
}

#pragma mark - state restoration (background)


@end
