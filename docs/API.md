# API

This document is the starting point for learning more about the c2bluetooth API and inner workings at varying levels of detail:

- The broadest overview comes from using the API as documented in the README
- sections like [Overall API Design](#overall-api-design) explain some of the core concepts or goals that we wanted to achieve with the API.
- For people looking to get into the internals of c2bluetooth,  the [Core API Concepts](#core-api-concepts) section below is a good mid-level overview of the various groups or categories of classes that are used in the API and what their purpose is.
- For summaries of how c2bluetooth works internally and all the things it "takes care of" for end users, see the [internals](internals.md) document
- Obviously the most detailed explaination of how the code works comes from reading the code and inline comments themselves. It is helpful to understand the general goals first 



## Overall API design

### Inspiration
In order for this library to be a good fit within the community and provide a good user experience for developers, the goal is to design the interface for this library after other existing libraries interfacing with Concept2 rowing machines. The libraries looked at were [Py3Row](https://github.com/droogmic/Py3Row) (Python, BSD-2), [BoutFitness/Concept2-SDK](https://github.com/BoutFitness/Concept2-SDK) (Swift, MIT), [ErgometerJS](https://github.com/tijmenvangulik/ErgometerJS) (Javascript, Apache 2).

There are likely more libraries like these available, but these were just the first few that were looked at based on a GitHub search.

### Object Oriented
These three examples all seem to use some kind of Class-based approach where a particular instance of an object represents a particular rowing machine and contains functions to make interaction with the machine easier, like getting data. 

Designing the library in an object oriented way seemed to make the most sense given what other projects in the space seem to ave done. This should also should keep things relatively straightforward to program and maintain.

### Subscription-based data access
Both BoutFitness/Concept2-SDK and ErgometerJS also seemed to have a way to asynchronously "subscribe" to get a callback when particular values change so the screen can be updated. Since the FlutterBleLib bluetooth library also exposes [Flutter streams](https://apgapg.medium.com/using-streams-in-flutter-62fed41662e4) for reading values in this way, it seems like a good choice to follow this model when exposing data about a PM5.

#### Single Values
For getting single values from an erg, such as serial number, software and hardware version info, and other things that likely wont change that often, Streams may be unnecessary and it might be easier to have a simple synchronous interface for grabbing a value either from the erg or from somewhere in the memory allocated to the particular Erg object being used.

Whether or not this is actually a good solution is still TBD

<!-- ### Modularity
Since a lot of the architecture is already provided by FlutterBleLib and will likely just pass through most of the aspects of the existing bluetooth APIs, it seems like it may be useful to make this passthrough more explicit. By duplicating any of the types and methods exposed by FlutterBleLib this package will be be more able to maintain a stable API, even in the event that there is a technical need (or desire from users) to be able to change the underlying bluetooth implementation, potentially even grouping the methods that handle the actual bluetooth access into a class/interface. This is something whtat would be helpful to keep in mind during initial development but shouldn't take too much energy until later versions. -->



## Core API Concepts

This library is built from a few core concepts, some of which are shared with the `csafe-fitness` library. These core concepts represent general groupings of classes that serve a particular purpose or abstract certain aspects of communicating with an erg.

These concepts are roughly divided up into "external" (i.e. those that are part of the libraries public API) and "internal". If you are just using the library in your app, the external concepts should be all you need. Anyone looking to contribute to this library might find the "internal" concepts helpful 

### External Concepts
#### Data Objects
Data objects, like the WorkoutSummary class, are  essentially wrappers around data provided by the PM and allow the data to be accessed as an object by an application.

Data objects are primarily one-way communication from a PM to your application.

Data objects are located in the `data` directory and represent a large chunk of the public API for c2bluetooth


#### Model Objects
This is a gairly general group of classes that represent various indoor rowing conceptsas objects for ease of use by applications looking to interact with ergs. Some examples of classses in this category are the `Ergometer` and `Workout` classes. Unlike Data Objects, they are intended to be able to enable bidirectional data flow. For example, an `Ergometer` object may have properties for getting data (like Data Objects) but also may contain methods like `sendWorkout()` that allow you to provide a `Workout` object to set up on the erg. `Workout` objects could also be returned by other methods as a way to represent a workout if needed.  

Model objects are located in the `models` directory and represent a large chunk of the public API for c2bluetooth


### Internal Concepts
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
