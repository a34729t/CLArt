# Art App: Getting to Know Estimote!

TODOS:
-Background notifications don't work
-We get some interference in noisy environment (ie beacon distance range isn't totally right)

CAVEATS:
-When testing, if you go into the background next to a beacon, in general when you wake up you won't notice it. You want to turn off the app manually and restart it to make it work.
-The location (via CoreLocation and RSSI) is highly unreliable due to the noisy RF environment. Your beacon will flip between 'Unknown Proximity' and 'Near' and others quite frequently.
-I've restricted the app to use only our 6 estimote beacons (hardcoded into Config.h and BeaconManager.m)

For Art demo, we care about:
-AppDelegate local notification methods
-Config.h with constants for UUIDs
-BeaconManager for CoreLocation and beacon management methods
