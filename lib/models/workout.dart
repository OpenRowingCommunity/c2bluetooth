import '../src/datatypes.dart';
import 'package:csafe_fitness/csafe_fitness.dart';
import 'package:equatable/equatable.dart';

import '../helpers.dart';
import 'package:c2bluetooth/enums.dart';

/// Represents a Workout that can be performed on a Concept2 Rowing machine
class Workout {
  //TODO: add a fromConcept2Type factory to take a concept2 workoutType enum and make a workout using it

  bool get hasSplits => splitLength != null && !isInterval;

  bool get hasTargetPace => targetPacePer500 != null;

  /// Determine if this workout is an intervals workout or not.
  ///
  /// rests.length should be a mostly adequate test, but checking for goal length also helps fix the edge case of undefined rest intervals
  bool get isInterval => rests.length > 0 || goals.length > 1;

  List<DurationType> get goalTypes => goals.map((e) => e.type).toList();

  /// The goal(s) to be met for this workout.
  ///
  /// i.e. is this a 2k? 30 min piece? 5 min interval?
  /// if the piece is just a fixed length (time or distance) or if the piece could go on forever (like a 5 min intervals), then this should be a list of length 1 with that goal
  ///  this is the goal for each segment
  List<WorkoutGoal> goals;

  List<WorkoutGoal> rests = [];

  Duration? targetPacePer500;
  Concept2IntegerWithUnits? splitLength;

  // WorkoutType get c2WorkoutType => WorkoutType.JUSTROW_NOSPLITS;

  Workout(this.goals,
      {this.splitLength, List<WorkoutGoal>? rests, this.targetPacePer500})
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
  Workout.intervals(List<WorkoutGoal> goals, List<WorkoutGoal> rests)
      : this(goals, rests: rests);

  Workout.split(WorkoutGoal primaryGoal, Concept2IntegerWithUnits? splitGoal)
      : this([primaryGoal], splitLength: splitGoal);

  // like split but intelligently makes something up
  Workout.single(WorkoutGoal primaryGoal)
      : this.split(primaryGoal, guessReasonableSplit(primaryGoal)?.toC2());

  //shortcut for setting a particular number of splits over the course of a piece.
  // Workout.splitByNumber(
  //     Concept2IntegerWithUnits primaryGoal, int splitCount)
  //     : this(WorkoutType.Limited,
  //           splitType: WorkoutSplitType.Split, primaryGoal: primaryGoal);

  WorkoutType getC2WorkoutType() {
    // if (goals.any((e) => e == goals[0])) {}
    if (goals.length >= 2) {
      if (rests.length > 0) {
        return WorkoutType.VARIABLE_INTERVAL;
      } else {
        return WorkoutType.VARIABLE_UNDEFINEDREST_INTERVAL;
      }
    } else if (goals.length == 1 && goals[0].type == DurationType.DISTANCE) {
      if (hasSplits) {
        return WorkoutType.FIXEDDIST_SPLITS;
      } else if (isInterval) {
        return WorkoutType.FIXEDDIST_INTERVAL;
      } else {
        return WorkoutType.FIXEDDIST_NOSPLITS;
      }
    } else if (goals.length == 1 && goals[0].type == DurationType.TIME) {
      if (hasSplits) {
        return WorkoutType.FIXEDTIME_SPLITS;
      } else if (isInterval) {
        return WorkoutType.FIXEDTIME_INTERVAL;
      } else {
        return WorkoutType.FIXEDTIME_NOSPLITS;
      }
    } else if (goals.length == 1 && goals[0].type == DurationType.CALORIES) {
      if (isInterval) {
        return WorkoutType.FIXEDCALS_INTERVAL;
      } else {
        return WorkoutType.FIXED_CALORIE;
      }
    } else if (goals.length == 1 && goals[0].type == DurationType.WATTMIN) {
      return WorkoutType.FIXED_WATTMINUTES;
    } else {
      // this will run if goals.length == 0
      if (hasSplits) {
        return WorkoutType.JUSTROW_SPLITS;
      } else {
        return WorkoutType.JUSTROW_NOSPLITS;
      }
    }
  }
}

/// A type to generically represent a goal for a workout
///
/// This is very similar to [Concept2IntegerWithUnits] and [CsafeIntegerWithUnits]. It is meant to be a simplified version of those types that can be converted into either one depending on which API (CSAFE public or C2 Proprietary) is needed (since they both serialize differently and have different types)
class WorkoutGoal extends Equatable {
  final int length;
  final DurationType type;

  WorkoutGoal(this.length, this.type);

  WorkoutGoal.meters(this.length) : type = DurationType.DISTANCE;

  WorkoutGoal.minutes(this.length) : type = DurationType.TIME;

  WorkoutGoal.calories(this.length) : type = DurationType.CALORIES;

  WorkoutGoal.wattMin(this.length) : type = DurationType.WATTMIN;

  Concept2IntegerWithUnits toC2() => Concept2IntegerWithUnits(length, type);

  CsafeIntegerWithUnits asCsafeDistance() {
    return CsafeIntegerWithUnits(length, CsafeUnits.meter);
  }

  Duration asDuration() {
    return Duration(minutes: length);
  }

  @override
  List<Object?> get props => [length, type];
}
