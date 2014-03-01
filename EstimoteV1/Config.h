//
//  Config.h
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#ifndef EstimoteV1_Config_h
#define EstimoteV1_Config_h

// Local notifications for our app
#define NOTIF_KEY               @"WILLIAM_GIBSON_IS_AWESOME"

// General search criteria for beacons that are broadcasting
#define BEACON_SERVICE_NAME     @"estimote"
#define BEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

// Beacons are hardcoded into our app so we can easily filter for them in a noisy environment
// The Id below is major+minor
#define BEACON_0                @"1507110507"
#define BEACON_1                @"4556564072"
#define BEACON_2                @"6046356367"
#define BEACON_3                @"4967229621"
#define BEACON_4                @"54450962"
#define BEACON_5                @"236807349"

#endif