//
//  ViewController.m
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"
#import "CentralManager.h"
#import "BeaconManager.h"

@interface ViewController () <CentralManagerDelegate, BeaconManagerDelegate>

@property (nonatomic, strong) CentralManager *centralManager;
@property (nonatomic, strong) BeaconManager *beaconManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"started!");
    
//    self.centralManager = [CentralManager sharedInstance];
//    self.centralManager.delegate = self;
    self.beaconManager = [BeaconManager sharedInstance];
    self.beaconManager.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanButtonPressed:(UIButton *)sender
{
    [self.centralManager startDetecting];
}

-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral rssi:(NSNumber *)RSSI
{
    NSLog(@"View didDiscoverPeripheral: %@", [RSSI stringValue]);
    [self.rssiLabel setText:[RSSI stringValue]];
}

@end
