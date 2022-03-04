import 'package:c2bluetooth/csafe/datatypes.dart';

import '../helpers.dart';
import 'enums.dart';

enum WorkoutMode {
  JustRow,
  // Variable,
  /// limited workouts are limited by some [DurationType], i.e. time, distance, or calories
  Limited
}

enum WorkoutSplitType {
  Split,
  Interval,
  Single // can probably be interperated as "no splits"
}

class Workout {
  WorkoutMode mode;

  ///once variable intervals are supported, this might become a list.
  DurationType? get limitation => primaryGoal?.unit;

  WorkoutSplitType? splitType;

  /// The primary goal is the goal that is limited by the [limitation] and should conform to similar units (i.e. distance, time, calories)
  ///
  ///once variable intervals are supported, this might become a list.
  Concept2IntegerWithUnits? primaryGoal;

  Concept2IntegerWithUnits? restGoal;

  ///A subdivision goal is the split or interval distance/time.
  ///
  ///until variable intervals are supported, this should be units that match the [limitation] value. Whether this should be treated as split or interval should be determined by [splitType]
  ///
  ///once variable intervals are supported, this might become a list.
  Concept2IntegerWithUnits? subDivisionGoal;

  // WorkoutType get c2WorkoutType => WorkoutType.JUSTROW_NOSPLITS;

  Workout(this.mode,
      {this.primaryGoal,
      this.splitType = WorkoutSplitType.Single,
      this.restGoal,
      this.subDivisionGoal});

  ///Shortcut for a Just row workout.
  ///
  ///
  // Workout.justRow(Concept2IntegerWithUnits splitGoal = Concept2IntegerWithUnits)
  //     : this(WorkoutMode.JustRow,
  //           splitType: WorkoutSplitType.Split, subDivisionGoal: splitGoal);

  /// Shortcut for an intervals workout
  /// [primaryGoal] should be a distance or time value to use per interval
  Workout.intervals(Concept2IntegerWithUnits primaryGoal,
      {Concept2IntegerWithUnits? restGoal})
      : this(WorkoutMode.Limited,
            splitType: WorkoutSplitType.Interval,
            primaryGoal: primaryGoal,
            restGoal: restGoal);

  Workout.split(
      Concept2IntegerWithUnits primaryGoal, Concept2IntegerWithUnits? splitGoal)
      : this(WorkoutMode.Limited,
            splitType: WorkoutSplitType.Split,
            primaryGoal: primaryGoal,
            subDivisionGoal: splitGoal);

  // like split but intelligently makes something up
  Workout.single(Concept2IntegerWithUnits primaryGoal)
      : this.split(primaryGoal, guessReasonableSplit(primaryGoal));

  //shortcut for setting a particular number of splits over the course of a piece.
  // Workout.splitByNumber(
  //     Concept2IntegerWithUnits primaryGoal, int splitCount)
  //     : this(WorkoutMode.Limited,
  //           splitType: WorkoutSplitType.Split, primaryGoal: primaryGoal);
}
