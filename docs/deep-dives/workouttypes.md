# The Workout Types deep dive

It has taken me quite a while to wrap my head around all the different types of workouts I think I have come up with a way to identify them using individual parameters that all combine to uniquely identify each one. These parameters are:
- a list of goals for the piece
- a list of rests for the piece
- a split length for the piece

By using the lengths and parameters of values in these lists it is possible to uniquely identify each different kind of workout on a Concept2 PM for the purpose of being able to set them. If you want to see a flowchart for this process, check out the [Workout Types Flow](../diagrams/Workout%20Types%20Flow.drawio) diagram file.

For example, a single distance piece has a single entry in the goal list whose value is a `Concept2IntegerWithUnits` value where the unit is `DISTANCE` (see concept2 CSAFE spec). The rest list is empty as there are no rests in a single distance piece.

On the more complicated side, a variable intervals workout has two or more entries in the goals list where each entry is for each interval. The types of these goals correspond to the type for that interval and the rest list has a matching number of entries worth of distance or time units for the respective rests for each interval. 

According to the spec, the VARIABLE_UNDEFINEDREST_INTERVAL case has multiple uses depending on whether the user is doing a biathalon workout or not and so there may be an extra flag/value that may be related to the penalty system as thats really the only difference in the two subtypes.

Undefined rest can be represented as having the rest list be empty


## the full table

| Concept2 type                   | Common Name        | # of goals | goal_value_type | # of rests | splitLength |
| ------------------------------- | ------------------ | ---------- | --------------- | ---------- | ----------- |
| JUSTROW_NOSPLITS                |                    | ?          | ?               | 0          | null        |
| JUSTROW_SPLITS                  |                    | ?          | ?               | 0          | not null    |
| FIXEDDIST_NOSPLITS              |                    | 1          | distance        | 0          | null        |
| FIXEDDIST_SPLITS                | Single Distance    | 1          | distance        | 0          | not null    |
| FIXEDTIME_NOSPLITS              |                    | 1          | time            | 0          | null        |
| FIXEDTIME_SPLITS                | Single Time        | 1          | time            | 0          | not null    |
| FIXEDTIME_INTERVAL              | Intervals Time     | 1          | time            | 1          | null        |
| FIXEDDIST_INTERVAL              | Intervals Distance | 1          | distance        | 1          | null        |
| VARIABLE_INTERVAL               | Intervals Variable | 2+         | multiple        | 2+         | null        |
| VARIABLE_UNDEFINEDREST_INTERVAL | Biathalon (ish)    | 2+         | multiple        | 0          | null        |
| FIXED_CALORIE                   |                    | 1          | calorie         | 0          | not null    |
| FIXED_WATTMINUTES               |                    | 1          | wattminutes     | 0          | not null    |
| FIXEDCALS_INTERVAL              |                    | 1          | calorie         | 1          | null        |


## Outstanding questions:
- how does just row fit into all this?
- what are watt-minutes? what does that kind of piece look like on an erg?
- What are the different subtypes of a VARIABLE_UNDEFINEDREST_INTERVAL?
  - concept2 seems to use this for both biathalon and a regular variable undefined rest using some penalty parameter
- what do pieces with no splits actually look like whn rowed on an erg?
  - are these possible?
  - will the machine determine the split for you?
    - how does the "just row" dynamic split length work?
  - will the split just not show up?