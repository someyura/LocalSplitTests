//
//  ABTest-Tests.swift
//  LocalSplitTests-Tests
//
//  Created by Yury Imashev on 29.11.2020.
//

import XCTest
import LocalSplitTests

class ABTest_Tests: XCTestCase {

    private var userDefaults = UserDefaults(suiteName: #file)!
    private var testName = "test"

    override func setUp() {
        userDefaults.removeObject(forKey: testName)
    }

    func cleanStorage() {
        userDefaults.removeObject(forKey: testName)
    }

    // MARK: Failed initialization tests

    func testWrongExposureLow() {
        let abTest = ABTest(name: testName, exposure: -1, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    func testWrongExposureHigh() {
        let abTest = ABTest(name: testName, exposure: 2, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    // MARK: Successfull initialization tests

    func testRightExposure1() {
        let abTest = ABTest(name: testName, exposure: 0, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightExposure2() {
        let abTest = ABTest(name: testName, exposure: 0.5, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightExposure3() {
        let abTest = ABTest(name: testName, exposure: 1, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    // MARK: Persistency test

    func testGroupPersistency() {
        let abTest = ABTest(name: testName, storage: userDefaults)!
        let group = abTest.userGroup
        XCTAssert(group == userDefaults.integer(forKey: testName))
        XCTAssert(group == abTest.userGroup)
    }

    // MARK: Groups distribution tests

    func testUserGroupsValues() {
        for _ in 1...10 {
            self.cleanStorage()
            let abTest = ABTest(name: testName, exposure: 1, storage: userDefaults)
            XCTAssert(abTest?.userGroup == 1 || abTest?.userGroup == 2)
        }
    }

    func testAllUsersDistribution() {
        var values = [Int].init(repeating: 0, count: 3)
        let testsCount = 1000

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, exposure: 1, storage: userDefaults)
            values[abTest!.userGroup] += 1
        }

        XCTAssert(values[0] == 0)
        XCTAssert(values[1] + values[2] == testsCount)
        XCTAssert(abs(values[1] - values[2]) - testsCount / 2 < testsCount / 20)
    }

    func testPartialDistribution() {
        var values = [Int].init(repeating: 0, count: 3)
        let testsCount = 1000

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, exposure: 0.5, storage: userDefaults)
            values[abTest!.userGroup] += 1
        }

        XCTAssert(values[0] + values[1] + values[2] == testsCount)
        XCTAssert(abs(values[0] - values[1] - values[2]) < testsCount / 10)
    }

    func testNoInvolvedUsers() {
        let testsCount = 100

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, isEligible: false, storage: userDefaults)!
            XCTAssert(abTest.userGroup == 0)
        }
    }

    func testSkippedUsersCallback() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onTestStarted = { _ in started += 1 }

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, isEligible: false, storage: userDefaults)!
            _ = abTest.userGroup
        }

        XCTAssert(skipped == testsCount)
        XCTAssert(started == 0)
    }

    func testInvolvedUsersCallback() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onTestStarted = { _ in started += 1 }

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, exposure: 1, storage: userDefaults)
            _ = abTest?.userGroup
        }

        XCTAssert(skipped == 0)
        XCTAssert(started == testsCount)
    }

    func testUsersCallbackDistribution() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onTestStarted = { _ in started += 1 }

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = ABTest(name: testName, exposure: 0.5, storage: userDefaults)
            _ = abTest?.userGroup
        }

        XCTAssert(skipped + started == testsCount)
        XCTAssert(abs(skipped - started) - testsCount / 2 < testsCount / 20)
    }
}
