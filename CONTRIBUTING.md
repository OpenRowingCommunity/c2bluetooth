

# Welcome to the C2Bluetooth Contributing Guide

This guide outlines some of the guidelines and conventions that C2Bluetooth uses for development

## Getting started
### Project Goal


## Installing the project for development

### From git

To install as a [git dependency](https://dart.dev/tools/pub/dependencies#git-packages), use the following snippet:

```yaml
  c2bluetooth:
    git:
      url: https://github.com/CrewLab/c2bluetooth
      ref: v0.1.1
```

This is useful if you dont plan to make many changes to the library or want to experiment with someone elses fork that you dont plan to modify.

In this example, the value of the `ref` setting determines what branch/tag/commit it will use. This is useful if you want to lock your install to a particular version. If you want to use the bleeding-edge version, set this to `main`.

*Note*: This snippet assumes you have git configured correctly to be able to access the repository over SSH and have the correct auth (i.e. ssh keys) to access it without typing in your credentials. See the [dart docs](https://dart.dev/tools/pub/dependencies#git-packages) for more information 

**Locally**
For the most bleeding-edge experience - or if you plan to make and test changes to this library in realtime, it is recommended that you clone the library and use a relative path dependency as shown:

```yaml
  c2bluetooth:
    path: ../c2bluetooth
```

If it seems like the library is not updating, you may need to run `flutter pub get` to pull in any new local changes made.

## Making contributions

Here are some guidelines for how to make a contribution to C2bluetooth

### Check for existing efforts

Take a look at the issues and pull requests tab of our repository or try searching for your issue to see if it has already been reported by someone else. The search feature can be useful for helping find things quickly, just make sure to try multiple different keywords in case someone else described your issue in a different way

#### File an issue

If your issue has not already been reported, or you want to discuss it first to make sure it fits within the scope of the project, feel free to file it as an an issue!


### Making your Contribution
If the contribution already has an issue or has already been identified as something that needs to be done (such as a "coming soon" feature in the README or a TODO comment) you dont have to submit an issue. If you are tackling a larger feature, you may still want to submit an issue or comment on an existing issue so others know you plan to work on it.

#### Forking and Branching

In order to make changes to the repository, you will likely need to fork it to your own account first using the button in the top right of the repositories page.

When making changes to your fork, make sure to create a new branch with a name that describes the change you are making, such as `fix-bluetooth-timeout` or `ski-erg-workouts`. This is known as a a [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow) brancging workflow and will make it easier to get your change added to the library.

#### Submitting your pull request

After submitting your pull request it will need to be reviewed and approved before it can be merged into the libraries main branch. This review process checks for things like:
- Code Quality: Are the changes designed in a way that makes sense? Do they fit in well with the rest of the codebase?
- Documentation:  Do new functions or classes have appropriate documentation comments? Are comments used to explain why the code works the way it does? Are things named in a way that makes sense?
- Testing: Are there new unit tests for any new functonality? Do all the unit tests pass? Does `flutter analyze` run without errors?
- Scope: Do the new changes further the project towards its goals? Do the changes provide more benefit to the library than the costs to maintain them long-term?
- Backwards compatibility: Do these changes affect or break parts of the publicly-exposed interface that others may be depending on? if so it may be delayed for a future major release.
- Licensing: Are you willing to assign your copyright in the work that you are contributing to CrewLAB? This may require signing a CLA.

While this is an incomplete list of mostly subjective points, these are the kinds of things that reviews will cover and whether or nor approval is given will be up to the reviewer(s) who are reviewing your change.

These are not designed to be hard-and-fast rules, but more like conversation starters. The person reviewing and approving your code is also a human, so feel free to ask for help if the feedback is unclear.


## Releases
Currently, there is no set release schedule. New releases are made on an as-needed basis once a maintainer decides that enough new features have been added to consist of a new release. 

Release version numbers are loosely based on [SemVer](https://semver.org/) where changes to MAJOR version numbers indicate breaking changes, MINOR version numbers indicate backward-compatible new features, and PATCH version changes indicate bug fixes. A list of changes made in each release should be maintained in the [CHANGELOG](CHANGELOG.md) or on the github releases tab.




<!-- TODO: set up issue and PR templates -->