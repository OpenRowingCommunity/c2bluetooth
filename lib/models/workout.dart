import 'package:c2bluetooth/csafe/datatypes.dart';

import '../helpers.dart';
import 'enums.dart';

enum SimpleWorkoutType {
  Fixed,
  Interval,
  // Variable,
  Preprogrammed,
  // JustRow,
  // Biathalon,
}

class Workout {
  SimpleWorkoutType type;

  //TODO: add a fromConcept2Type factory to take a concept2 workoutType enum and make a workout using it

  /// The primary metric that causes this workout's goal to be met
  ///
  /// i.e. is this a distance, time, or calorie piece?
  /// once variable intervals are supported, this might become a list.
  DurationType? get limitation => primaryGoal?.unit;

  bool get hasSplits => splitLength != null;

  bool get hasTargetPace => pace != null;

  /// The single main goal to be met for this workout.
  ///
  /// i.e. is this a 2k? 30 min piece? 5 min interval?
  /// if the piece could go on forever (like intervals) this is the goal for each segment
  /// once variable intervals are supported, this might become a list.
  Concept2IntegerWithUnits? primaryGoal;

  Concept2IntegerWithUnits? rest;

  Concept2IntegerWithUnits? pace;
  Concept2IntegerWithUnits? splitLength;

  // WorkoutType get c2WorkoutType => WorkoutType.JUSTROW_NOSPLITS;

  Workout(this.type,
      {this.primaryGoal, this.splitLength, this.rest, this.pace}) {
    // TODO: Validate that rest is an amount of time? (maybe it can be other things?)
  }

  ///Shortcut for a Just row workout.
  ///
  ///
  // Workout.justRow(Concept2IntegerWithUnits splitGoal = Concept2IntegerWithUnits)
  //     : this(WorkoutType.JustRow,
  //           splitType: WorkoutSplitType.Split, subDivisionGoal: splitGoal);

  /// Shortcut for an intervals workout
  /// [primaryGoal] should be a distance or time value to use per interval
  Workout.intervals(Concept2IntegerWithUnits goal,
      {Concept2IntegerWithUnits? rest, Concept2IntegerWithUnits? splitLength})
      : this(WorkoutType.Interval,
            splitLength: splitLength, primaryGoal: goal, rest: rest);

  Workout.split(
      Concept2IntegerWithUnits primaryGoal, Concept2IntegerWithUnits? splitGoal)
      : this(WorkoutType.Fixed,
            primaryGoal: primaryGoal, splitLength: splitGoal);

  // like split but intelligently makes something up
  Workout.single(Concept2IntegerWithUnits primaryGoal)
      : this.split(primaryGoal, guessReasonableSplit(primaryGoal));

  //shortcut for setting a particular number of splits over the course of a piece.
  // Workout.splitByNumber(
  //     Concept2IntegerWithUnits primaryGoal, int splitCount)
  //     : this(WorkoutType.Limited,
  //           splitType: WorkoutSplitType.Split, primaryGoal: primaryGoal);
}
