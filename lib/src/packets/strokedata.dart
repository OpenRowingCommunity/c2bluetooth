import 'dart:typed_data';

import './base.dart';

class StrokeData extends TimestampedData {
  StrokeData.fromBytes(Uint8List data) : super.fromBytes(data) {
    // _workTime.completeIfNotAlready(
    //     CsafeIntExtension.fromBytes(data.sublist(4, 7), endian: Endian.little) /
    //         100); //divide by 100 to convert to seconds
    // _workDistance.completeIfNotAlready(CsafeIntExtension.fromBytes(
    //         data.sublist(7, 10),
    //         endian: Endian.little) /
    //     10); //divide by 10 to convert to meters
    // _avgSPM.completeIfNotAlready(data.elementAt(10));
    // _endHeartRate.completeIfNotAlready(data.elementAt(11));
    // _avgHeartRate.completeIfNotAlready(data.elementAt(12));
    // _minHeartRate.completeIfNotAlready(data.elementAt(13));
    // _maxHeartRate.completeIfNotAlready(data.elementAt(14));
    // _avgDragFactor.completeIfNotAlready(data.elementAt(15));
    // //recovery heart rate here
    // int recHRVal = data.elementAt(16);
    // // 0 is not a valid value here according to the spec
    // if (recHRVal > 0) {
    //   _recoveryHeartRate.completeIfNotAlready(recHRVal);
    // }
    // _workoutType
    //     .completeIfNotAlready(WorkoutTypeExtension.fromInt(data.elementAt(17)));
    // _avgPace.completeIfNotAlready(CsafeIntExtension.fromBytes(
    //         data.sublist(18, 20),
    //         endian: Endian.little) /
    //     10); //{
  }
}

class StrokeData2 extends TimestampedData {
  StrokeData2.fromBytes(Uint8List data) : super.fromBytes(data);
}
