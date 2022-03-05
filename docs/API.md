# API

This document explains the c2bluetooth API at varying levels of detail:

- The broadest overview comes from sections like [Overall API Design](#overall-api-design) that explain some of the core concepts or goals that we wanted to achieve with the API.
- The "middle ground" overview comes from the [Core API Concepts](#core-api-concepts) section and explains the various groups or categories of classes that are used in the API and what their purpose is.
- The most detailed explaination comes from reading the code and inline comments or documentation generated from them. This will not be covered in this document as it should already be covered by the source code



## Overall API design
In order for this library to be a good fit within the community and provide a good user experience for developers, the goal is to design the interface for this library after other existing libraries interfacing with Concept2 rowing machines. The libraries looked at were [Py3Row](https://github.com/droogmic/Py3Row) (Python, BSD-2), [BoutFitness/Concept2-SDK](https://github.com/BoutFitness/Concept2-SDK) (Swift, MIT), [ErgometerJS](https://github.com/tijmenvangulik/ErgometerJS) (Javascript, Apache 2).

There are likely more libraries like these available, but these were just the first few that were looked at based on a GitHub search.

All of these three examples seem to use some kind of Class-based approach where a particular object/instance representin a particular machine and containing functions to allow interaction with the machine, like getting data. Both BoutFitness/Concept2-SDK and ErgometerJS also seemed to have a way to asynchronously "subscribe" to get a callback when particular values change so the screen can be updated. Since this asynchronous behavior is also how FlutterBleLib works as far as reading values, it seems like a good choice to follow this model of using a class to represent a particular PM5 machine and allowing end applications to easily subscribe to the read-only values made available by the PM5. 

### Data Access
#### Subscription API
[Flutter streams](https://apgapg.medium.com/using-streams-in-flutter-62fed41662e4) seem to be flutter's own way of handling the "subscribe to get a callback when data changes" feature, so it makes sense to use this for allowing apps to subscribe to datastreams from the erg for data that they care about, such as receiving live updates on time, distance, rate, and split throughout a workout.

#### Single Values
For getting single values from an erg, such as serial number, software and hardware version info, and other things that likely wont change that often, Streams may be unnecessary and it might be easier to have a simple synchronous interface for grabbing a value either from the erg or from somewhere in the memory allocated to the particular Erg object being used.

Whether or not this is actually a good solution is still TBD

### Modularity
Since a lot of the architecture is already provided by FlutterBleLib and will likely just pass through most of the aspects of the existing bluetooth APIs, it seems like it may be useful to make this passthrough more explicit. By duplicating any of the types and methods exposed by FlutterBleLib this package will be be more able to maintain a stable API, even in the event that there is a technical need (or desire from users) to be able to change the underlying bluetooth implementation, potentially even grouping the methods that handle the actual bluetooth access into a class/interface. This is something whtat would be helpful to keep in mind during initial development but shouldn't take too much energy until later versions.



