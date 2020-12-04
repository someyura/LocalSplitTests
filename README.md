# LocalSplitTests

[![Build Status](https://travis-ci.com/someyura/LocalSplitTests.svg?branch=master)](https://travis-ci.com/someyura/LocalSplitTests) [![codecov](https://codecov.io/gh/someyura/LocalSplitTests/branch/master/graph/badge.svg?token=GPVT295OZX)](https://codecov.io/gh/someyura/LocalSplitTests) [![Twitter](https://img.shields.io/badge/twitter-%40yuryimashev-blue)](https://twitter.com/yuryimashev)

Making Split and A/B tests that doesn't rely on a server.

---
Split testing is a powerful tool that allows you to understand your users, their behavior, and make a better app. 

Some services will allow you to implement very complex tests, but unfortunately, all of them rely on a server, that defines whether or not the user should be involved in the test and in which group he just be places. 

This approach won't work when you need to define a test group when the app launches. For example, if you want to test different kinds of onboardings.

Also, some of these solutions make you add bulky frameworks, register on their website, implement additional setup, and sometimes aren't free.

Sometimes you don't need a complicated setup because you just want to make a simple test to see what works better. 

This micro-framework (less than 50 lines of code) will allow you to run the Split Tests and A/B Tests locally on the user device. So you will need only an analytics service to see the results.

## Summary

* [Features](#features)
* [Usage](#usage)
  * [Initializing](#initializing)
  * [Testing](#testing)
  * [Storing](#storing)
  * [Filtering users](#filtering-users)
  * [Split tests](#split-tests)
  * [Logging](#logging)
* [Installation](#installation)
  * [Carthage](#carthage)
  * [CocoaPods](#cocoapods)
  * [Swift Package Manager](#swift-package-manager)

## Features

- [X] A/B Tests.
- [X] Split tests with custom amout of groups.
- [X] Elegible users filtering.
- [X] Customizable exposure.
- [X] AppGroups support.
- [X] Test group is can be picked on a launch-time.

## Usage

### Initializing 

Let's say we have to version of the welcome screen and you want to test, which one works better. 

To start, let's create an A/B test with a single line of code:

```swift
let test = ABTest(name: ”welcome_test”)
```

The `name` parameter is used as a key for storing the user test group, so make sure you don't change it after the test was started.

### Testing

Now, we need to check what screen should we show for our user. Since we're using an A/B test, there are only two test groups. User's test group is picked automatically so all you left to do is just request it.

```swift
// We are using A/B test, so the value of the userGroup can be only `1` or `2`
if test.userGroup == 1 {
	self.present(FirstWelcomeViewController()
} else {
	self.present(SecondWelcomeViewController()
}
```

Note that `userGroup` is picked when you request it for the first time. This is helpful because if the user won't trigger the test, you won't see him in your analytics.

### Storing

By default, the value of the picked test group is stored at `UserDefaults.standard`. 
If you need to store it in your app group's UserDefauls, you can pass it into the test:

```swift
let appGroupDefaults = UserDefaults(suiteName: “MyAppGroup”)
let test = ABTest(name:”welcome_test”, storage: appGroupDefaults)
```

### Filtering users

Let's take back to our example with a welcome screen. 

What if we don't have a translation yet since at first, we want to find which screen works best?
For example, our welcome screens are only in English and we don't want to show anything to people in other languages.

In this case, all we need to do is to pass a `Bool` value that will indicate whether or not the user is eligible for this test:

```swift
let isEnglishSpeaker = Locale.current.languageCode.hasPrefix("en")
let test = ABTest(name:”welcome_test”, isEligible: isEnglishSpeaker)
```

You can also specify for many of eligible users will be exposed to the test:

```swift
// only 50% of the eligible users will be involved in testing
let test = ABTest(name:”welcome_test”, exposure: 0.5)
```

And of course you can do both:

```swift
// only 50% of the english speaking users will be involved in testing
let test = ABTest(name:”welcome_test”, isEligible: isEnglishSpeaker, exposure: 0.5)
```

* Note that for users that are not involved in testing, `userGroup` will be equal to `0`.

Now we can check the value:

```swift
switch test.userGroup {
case 1:
	self.present(FirstWelcomeViewController()
case 2:
	self.present(SecondWelcomeViewController()
default:
	// For users not involved in testing, userGroup will be 0
	break
}
```

### Split tests

Sometime you might have more than 2 groups and in this case you need to use a `SplitTest`:

```swift
// In this case, userGroup will be 1, 2 or 3
let test = SplitTest(name: ”starting_points”, groupsCount: 3)

...

switch test.userGroup {
case 1:
	startingPoins = 100
case 2:
	startingPoins = 500
default:
	startingPoins = 1000
}
```

### Logging

The point of any test is to see the result to make a decision. Since everything is happening on user's device, we need to send the data to some server to analyze it later.

There are two kind of events:
1. User was involved into a new test
2. User was opted out of the test

To log the first one, just add the folowing lines: 

```swift
SplitTest.onTestStarted = { test in
	Analytics.log(event: test.name, parameters: [“group”: test.userGroup])
}
```

To log the second one, add this:

```swift
SplitTest.onTestSkipped = { test in
	Analytics.log(event: test.name)
}
```

## Installation

### Carthage
```
github "someyura/LocalSplitTests"
```

### CocoaPods

```
pod 'LocalSplitTests'
```

### Swift Package Manager

```
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "MyApp",
  dependencies: [
    .package(url: "https://github.com/someyura/LocalSplitTests.git")
  ],
  targets: [
    .target(name: "MyApp", dependencies: ["LocalSplitTests.git"])
  ]
)
```
