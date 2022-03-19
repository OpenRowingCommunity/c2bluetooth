# fresh_example

This is a sample app created from a fresh flutter project it is useful as a playground for experimenting with/testing the c2bluetooth library as it is being built as well as providing an example for how this could be used in an app

This app simply connects to the first erg that it sees.

## Sample App capabilities
### Get workout summary information


1. build and run app.
2. long press app on android(samsung) home screen. click the info button, go to permissions and enable location permissions
3. confirm bluetooth is on
4. turn on PM and go to the screen where you would connect something like the ergdata app (usually this is a connect button on the main menu)
5. open/run the app. it should do some discovery and show you a stroke rate: 0 message
6. hit back on the erg and set up a piece. Recommended to set a 20 sec (minimum allowed) single time piece.
7. start the piece and take some strokes. after the piece is over you should see some data for the piece you completed appear on screen. feel free to modify the app to show other data points.
