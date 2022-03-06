import 'package:c2bluetooth/csafe/datatypes.dart';

import '../helpers.dart';
import 'enums.dart';


class Workout {

  //TODO: add a fromConcept2Type factory to take a concept2 workoutType enum and make a workout using it

  bool get hasSplits => splitLength != null && !isInterval;

  bool get hasTargetPace => pace != null;

  /// Determine if this workout is an intervals workout or not. 
  /// 
  /// rests.length should be a mostly adequate test, but checking for goal length also helps fix the edge case of undefined rest intervals
  bool get isInterval => rests.length > 0 || goals.length > 1;

  /// The goal(s) to be met for this workout.
  ///
  /// i.e. is this a 2k? 30 min piece? 5 min interval?
  /// if the piece is just a fixed length (time or distance) or if the piece could go on forever (like a 5 min intervals), then this should be a list of length 1 with that goal
  ///  this is the goal for each segment
  List<Concept2IntegerWithUnits> goals;

  List<Concept2IntegerWithUnits> rests = [];

  Concept2IntegerWithUnits? pace;
  Concept2IntegerWithUnits? splitLength;

  // WorkoutType get c2WorkoutType => WorkoutType.JUSTROW_NOSPLITS;

  Workout(this.goals,
      {this.splitLength, List<Concept2IntegerWithUnits>? rests, this.pace})
      : rests = rests ?? [] {
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
  Workout.intervals(List<Concept2IntegerWithUnits> goals,
      List<Concept2IntegerWithUnits> rests)
      : this(goals, rests: rests);

  Workout.split(
      Concept2IntegerWithUnits primaryGoal, Concept2IntegerWithUnits? splitGoal)
      : this([primaryGoal], splitLength: splitGoal);

  // like split but intelligently makes something up
  Workout.single(Concept2IntegerWithUnits primaryGoal)
      : this.split(primaryGoal, guessReasonableSplit(primaryGoal));

  //shortcut for setting a particular number of splits over the course of a piece.
  // Workout.splitByNumber(
  //     Concept2IntegerWithUnits primaryGoal, int splitCount)
  //     : this(WorkoutType.Limited,
  //           splitType: WorkoutSplitType.Split, primaryGoal: primaryGoal);
}
