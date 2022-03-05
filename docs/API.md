# API

This document explains the c2bluetooth API at varying levels of detail:

- The broadest overview comes from sections like [Overall API Design](#overall-api-design) that explain some of the core concepts or goals that we wanted to achieve with the API.
- The "middle ground" overview comes from the [Core API Concepts](#core-api-concepts) section and explains the various groups or categories of classes that are used in the API and what their purpose is.
- The most detailed explaination comes from reading the code and inline comments or documentation generated from them. This will not be covered in this document as it should already be covered by the source code



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

Many of these concepts are shared with the csafe-fitness dart library that was developed alongside this one. 

### Machine
This category came out of the Object oriented design philosophy for the library as well as the FlutterBleLib bluetooth library which has a Peripheral object to represent a particular device in a bluetooth connection and provide a spot from which to expose streams and other methods for interacting with the device via bluetooth.

An examples of a clas in this category is the Ergometer class. In the future more superclasses or subclasses may be added to support additional types and models of fitness machines from Concept2.

### Bluetooth Manager
This concept was borrowed from the FlutterBleLib bluetooth library which had a concept of a BleManager that was responsible for managing the bluetooth connection. This was adapted into the ErgBleManager class that wraps BleManager and adds some additional erg-specific functionality.

In the future this may be replaced with a better, more flexible class system that represents a generic bluetooth interface and enables bluetooth backends implementing this interface to be easily swappd out.
### Commands
The command classes are based on the similarly names classes in the csafe-fitness library. The general-purpose command superclasses are responsible for implementing the general-purpose command structures from the relevant CSAFE/Concept2 specifications. These general command classes can then be subclassed to make clearly-named human readable shortcuts that pre-fill details like the identifier and command type while also performing validation of the command data.

Some commands which dont require addditional data are exposed as variables containing a specific instance of a command that has been pre-made.

All Commands and the data passed to them implements an interface that allows them all to be converted to and from bytes for eventual transmission via the CSAFE packet frames. This interface is called `ByteSerializable` and is implemented by 

#### Validators
Validators are functions that perform the validation of the data that outlined above. While some validation for data passed to commands can be done by specifying specific types in individual command constructors, sometimes additional validation is required, such as enforcing a limit on the value of the data passed in. These validators are implemented as functions and follow an inheritence-like pattern that allows many validators to be made available to library consumers for convenience.

#### Command Data
The specific interperetation of data in a command depends on that commands identifier/what the command is for. To make things easy, many classes have already been created that represent different data types from the spec that various commands accept. Most notable of these is an "integer with units" type that stores an integer with a unit value, which is useful for specifying things like distances and times.

If you need to create your own datatype, you should look at the existing datatypes as well as the `ByteSerializable` interface. 
