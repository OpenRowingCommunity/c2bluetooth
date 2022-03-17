import 'package:c2bluetooth/enums.dart';
import 'package:c2bluetooth/models/workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:c2bluetooth/models/workout.dart';

void main() {
  group("Workout - ", () {
    test('can get the correct workout type', () {
      // something prime or not divisible in a reasonably high (like 4) number of splits wont be assigned a split
      expect(Workout.single(WorkoutGoal.minutes(2)).getC2WorkoutType(),
          WorkoutType.FIXEDTIME_NOSPLITS);
      expect(Workout.single(WorkoutGoal.minutes(6)).getC2WorkoutType(),
          WorkoutType.FIXEDTIME_SPLITS);
      expect(Workout.single(WorkoutGoal.meters(2000)).getC2WorkoutType(),
          WorkoutType.FIXEDDIST_SPLITS);
      // something prime or not divisible in a reasonably low number of splits wont be assigned a split
      expect(Workout.single(WorkoutGoal.meters(59)).getC2WorkoutType(),
          WorkoutType.FIXEDDIST_NOSPLITS);
      // 2k on 500 off
      expect(
          Workout.intervals(
                  [WorkoutGoal.meters(2000)], [WorkoutGoal.meters(500)])
              .getC2WorkoutType(),
          WorkoutType.FIXEDDIST_INTERVAL);

      expect(
          Workout.intervals([WorkoutGoal.minutes(5)], [WorkoutGoal.minutes(2)])
              .getC2WorkoutType(),
          WorkoutType.FIXEDTIME_INTERVAL);

      expect(Workout([]).getC2WorkoutType(), WorkoutType.JUSTROW_NOSPLITS);
    });
  });
}
