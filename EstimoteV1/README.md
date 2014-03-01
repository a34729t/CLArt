# Getting to Know Estimote!

TODO:
1) Restrict to our beacons?

# Our Beacon Ids (major/minor)
2014-03-01 09:41:47.568 EstimoteV1[23729:60b] LM didRangeBeacons
2014-03-01 09:41:47.569 EstimoteV1[23729:60b] LM major:15071 minor:10507 distance:Far
2014-03-01 09:41:47.571 EstimoteV1[23729:60b] LM major:45565 minor:64072 distance:Far
2014-03-01 09:41:47.573 EstimoteV1[23729:60b] LM major:60463 minor:56367 distance:Far
2014-03-01 09:41:47.574 EstimoteV1[23729:60b] LM major:49672 minor:29621 distance:Far
2014-03-01 09:41:47.576 EstimoteV1[23729:60b] LM major:544 minor:50962 distance:Far
2014-03-01 09:41:47.578 EstimoteV1[23729:60b] LM major:23680 minor:7349 distance:Far


TODOS:
-Background notifications don't work
-We get some interference in noisy environment (ie beacon distance range isn't totally right)

CAVEATS:
-When testing, if you go into the background next to a beacon, in general when you wake up you won't notice it. You want to turn off the app manually and restart it to make it work.
-The location (via CoreLocation and RSSI) is highly unreliable due to the noisy RF environment. Your beacon will flip between 'Unknown Proximity' and 'Near' and others quite frequently.

For Art demo, we care about:
-AppDelegate local notification methods
-Config.h with constants for UUIDs
-BeaconManager for CoreLocation and beacon management methods
