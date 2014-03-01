//
//  AppDelegate.m
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "AppDelegate.h"
@import CoreLocation;
#import "Config.h"

@implementation AppDelegate

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    // Override point for customization after application launch.
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - local notification stuff

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    if (![CLLocationManager significantLocationChangeMonitoringAvailable])
    {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your device won't support the significant location change." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    
    UILocalNotification *localNotification=[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self handleLaunchNotification:localNotification];
        application.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber-1;
    }else{
        application.applicationIconBadgeNumber = 0;
    }
    return YES;
}

// application not running
-(void)handleLaunchNotification:(UILocalNotification*)notifcation{
    NSString *notifText=[notifcation.userInfo objectForKey:NOTIF_KEY];
    NSLog(@"handleLaunchNotification passed text %@",notifText);
}

// application is in the background or active
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if (application.applicationState==UIApplicationStateActive){
        NSLog(@"application didReceiveLocalNotification (foreground)");
        NSString *body=notification.alertBody;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Elphi AD 2"
                                                          message:[NSString stringWithFormat:@"%@",body]
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else if (application.applicationState==UIApplicationStateBackground) {
        NSLog(@"application didReceiveLocalNotification (background)");
        application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
        
    }
}

@end
