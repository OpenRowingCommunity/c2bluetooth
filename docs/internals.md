# Internal API and Design Concepts
This document is meant to be similar to the [API](API.md) document, but specifically for providing an overview of the internal API organization. 

Only people interested in contributing to c2bluetooth should need to understand things at this level.

## Internal API Design

TODO

## Internal API Concepts
#### Commands
The command classes are based on the similarly named classes in the csafe-fitness library. There is a command superclass that is responsible for implementing general-purpose command structures from the relevant CSAFE/Concept2 specifications. These general command classes can then be subclassed to make clearly-named human readable shortcuts that pre-fill details like the identifier and command type while also performing validation of the command data.

Some commands which dont require addditional data are exposed as variables containing a specific instance of a command that has been pre-made.

All Commands and the data passed to them implements an interface that allows them all to be converted to and from bytes for eventual transmission via the CSAFE packet frames. This interface is called `ByteSerializable` and is implemented by 

##### Naming Conventions
Where possible, naming conventions for commands should be similar to the Concept2 specifications. Specifically:
- Commands from the Fitlinxx CSAFE spec are prefixed with CSAFE
- Commands that Concept2 has added to the CSAFE spec are prefixed with something like C2Csafe (concept2 uses `CSAFE_PM_` in their spec)

##### Validators
Validators are functions that perform the validation of the data that outlined above. While some validation for data passed to commands can be done by specifying specific types in individual command constructors, sometimes additional validation is required, such as enforcing a limit on the value of the data passed in. These validators are implemented as functions and follow an inheritence-like pattern that allows many validators to be made available to library consumers for convenience.

##### Command Data
The specific interperetation of data in a command depends on that commands identifier/what the command is for. To make things easy, many classes have already been created that represent different data types from the spec that various commands accept. A notable example of these is an "integer with units" type that stores an integer with a unit value, which is useful for specifying things like distances and times when sending data via CSAFE.

If you need to create your own datatype, you should look at the existing datatypes as well as the `ByteSerializable` interface. 


## Implementation Summaries

This section intends to give a broad overview of various components of how c2bluetooth solves certain problems and why they were solved that way

