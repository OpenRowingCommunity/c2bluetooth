# Design Decisions

## Bluetooth Library
This library ultimately depends on some bluetooth library to function. Originally the plan was to use [flutter_blue](https://github.com/pauldemarco/flutter_blue) because thats the first [tutorial](https://lupyuen.github.io/pinetime-rust-mynewt/articles/flutter#bluetooth-le-services) I came across at the time development was started on c2bluetooth. However, after seeing how many open issues and PR's they still have, the decline evident in their contributor graph, [comments online](https://www.reddit.com/r/FlutterDev/comments/hm63uk/why_bluetooth_in_flutter_is_so_problematic/), and [an analysis on cauldron.io](https://cauldron.io/project/5134),  [FlutterBleLib](https://github.com/dotintent/FlutterBleLib) was briefly used instead, before the project ultimately switched to using [flutter_reactive_ble](https://github.com/PhilipsHue/flutter_reactive_ble) mainteined by Philips Hue because it seems to be the most likely to continue to be maintained into the future.


During the transition from FlutterBleLib to flutter_reactive_ble creating an interface to represent any bluetooth library was considered because it would give implementors the ability to use a bluetooth library that may already exist in their app. This would halp maintainers reduce app dependencies, app size, and conflicting libraries, but was ultimately never implemented because it would make the process of debugging implementor-reported issues reported against the library more difficult.

## CSAFE API Usage

This library attempts to use the "public" CSAFE Concept2 API wherever possible. This API adheres the closest to the published CSAFE specification and uses the standardized commands for setting up a workout. This is in contrast to the Concept2 "proprietary" API which relies on custom, Concept2-specific commands added on top of CSAFE. Concept2 PM CSAFE Communication Definition.doc revision 0.13 also mentions that: 

> The proprietary CSAFE interface does not use the public CSAFE state machine functionality. Generally, the
proprietary and public operating modes should not be mixed as the resulting behavior will not be desirable.


