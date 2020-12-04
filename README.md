# LocalSplitTests

[![Build Status](https://travis-ci.com/someyura/LocalSplitTests.svg?branch=master)](https://travis-ci.com/someyura/LocalSplitTests) [![codecov](https://codecov.io/gh/someyura/LocalSplitTests/branch/master/graph/badge.svg?token=GPVT295OZX)](https://codecov.io/gh/someyura/LocalSplitTests) [![Twitter](https://img.shields.io/badge/twitter-%40yuryimashev-blue)](https://twitter.com/yuryimashev)

Making Split and A/B tests without using a server.

---
Split testing is a very useful tool that allows you understand your users, thier behavior and make a better app. But unfortunately, most of solutions on the market makes you implement a bulky frameworks, register on their website, implement additional setup and sometime aren't free.

But sometimes you don't need a complicated setup and just want to make a simple split test to see what is working and what is not.

This library is a take on cutting off everything non-essential. This micro-framework (less than 100 lines of code) will allow you make a

## Features

- [X] A/B Tests.
- [X] Split tests with custom amout of groups.
- [X] Elegible users filtering.
- [X] Customizable exposure.
- [X] AppGroups support.
- [X] Test group is can be picked on a launch-time.

## Usage


### Initializing 

Let's say we have to version of welcome screen and you want to test, which one works better. 

To start, let's create an A/B test with a single line of code:

```swift
let test = ABTest(name: ”welcome_test”)
```

* The `name` parameter is used for storing picked value so make sure you don't change it after test was started.

Now, on we need to check what screen should we show for our user. In order to do so, we just need to check the value of `userGroup`. Since we are using **A/B** test, the value of user group can be only `1` or `2`

```swift
if test.userGroup == 1 {
	self.present(FirstWelcomeViewController()
} else {
	self.present(SecondWelcomeViewController()
}
```

* Note that user group is picked when you request it for the first time.

By default, the value of the picked group is stored at `UserDefaults.standart`. 
If you need to store it in your app group's UserDefauls, you can pass it into the test:

```swift
let myDefaults = UserDefaults(suiteName: “MyAppGroup”)
let test = ABTest(name:”welcome_test”, storage: myDefaults)
```

### Filtering users

Let's take back to our example with a welcome screen. 

What if we don't have a translation yet since we want to find which one is working first?
For example, our welcome screens are only in English and we don't want to show anythin to people with other languages.

In this case all we nee to do is to pass a `Bool` value that will indicate whether or not user is eligible for this test:

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

### Split testing

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

### SPM

### Carthage

### CocoaPods
