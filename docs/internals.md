# Internal API and Design Concepts
This document is meant to be similar to the [API](API.md) document, but specifically for providing an overview of the internal API organization. 

Only people interested in modifying c2bluetooth should need to understand things at this level.

This also can be thought of as an outline of many of the (often low-level) things that c2bluetooth "takes care of" for impleenting applications in keeping with the [Silent Protector principle](API.md#the-silent-protector).


## Terms used

### Segment
One key difference you may notice between this library and the source documentation that this is based on (such as the Concept2 Bluetooth API specifications) is the appearance of the term "segment". This is useful because splits and intervals are fundamentally similar enough that concept2 uses the same API to convey both split and interval data (the two are mutually exclusive anyway). Concept2's documentation, however, refers to it as "Split/interval", so the term segment was introduced to make this a little easier to think about and help differentiate data points that are unique to either splits or intervals. 

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

### Subscription Data Multiplex

In order to provide c2bluetooth with the most flexibility and control over data coming from the PM5, it is useful to insert an additional layer between the incoming data from the bluetooth streams from the PM5 and the stream going out to the user so that c2bluetooth can take on and abstract as much of the complexity as possible.

This is similar to how a library might add a custom class of its own that wraps an existing API from one of its dependencies so that, even if the API being depended on by the library changes, users of the library are more insulated as the library has a locaton where it can perform changes to keep the API as consistent for the end user as possible.

Within the context of c2bluetooth, this additional layer is intended to also add functionality by managing both the data requested by implementors of the c2bluetooth library and the data available to it via the concept2's bluetooth interface so as to provide the implementors with the data that they requested for use in their own apps. 

This layer has a few general objectives:
- to keep track of what data the implementor wants ("requested data")
- to keep track of what data we are currently receiving ("subscriptions" to bluetooth notifications from the PM)
- to route data that comes in via bluetooth subscriptions to "outgoing streams" that the implementor is listening to while conserving bluetooth bandwidth as much as possible
