# Design Decisions

## Bluetooth Library
This library ultimately depends on some bluetooth library to function. Originally the plan was to use [flutter_blue](https://github.com/pauldemarco/flutter_blue) because thats the first [tutorial](https://lupyuen.github.io/pinetime-rust-mynewt/articles/flutter#bluetooth-le-services) I came across. However, after seeing how many open issues and PR's they still have, the decline evident in their contributor graph, [comments online](https://www.reddit.com/r/FlutterDev/comments/hm63uk/why_bluetooth_in_flutter_is_so_problematic/), and [an analysis on cauldron.io](https://cauldron.io/project/5134), I've decided to use [FlutterBleLib](https://github.com/dotintent/FlutterBleLib) instead since, even though it seems similarly unmaintained, it has less open issues and seems to have reached a later stage of maturity based on its version number being in the 2.X range, rather than the 0.X range.

## CSAFE API Usage

This library attempts to use the "public" CSAFE Concept2 API wherever possible. This API adheres the closest to the published CSAFE specification and uses the standardized commands for setting up a workout. This is in contrast to the Concept2 "proprietary" API which relies on custom, Concept2-specific commands added on top of CSAFE. Concept2 PM CSAFE Communication Definition.doc revision 0.13 also mentions that: 

> The proprietary CSAFE interface does not use the public CSAFE state machine functionality. Generally, the
proprietary and public operating modes should not be mixed as the resulting behavior will not be desirable.


