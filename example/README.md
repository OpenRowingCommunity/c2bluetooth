# fresh_example

This is a sample app created from a fresh flutter project it is useful as a playground for experimenting with/testing the c2bluetooth library as it is being built as well as providing an example for how this could be used in an app.

This demo app is designed in a similar way to the demo app of the `flutter_blue` library and adapts many of its ideas (like the "bluetooth is turned off" screen) to work with C2bluetooth.

## Sample App capabilities
### Get workout summary information

1. build and run app.
2. long press app on android(samsung) home screen. click the info button, go to permissions and enable location permissions
3. confirm bluetooth is on
4. turn on PM and go to the screen where you would connect something like the ergdata app (usually this is a connect button on the main menu or a "turn wireless on" under more options)
5. open/run the app and connect to the erg.
6. set up a piece on the erg and set up a piece. Recommended to set a 20 sec (minimum allowed) single time piece if you just want a short test.
7. start the piece and take some strokes. after the piece is over you should see some data for the piece you completed appear on screen. feel free to modify the app to show other data points.
