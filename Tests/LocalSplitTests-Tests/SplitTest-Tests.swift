//
//  SplitTest-Tests.swift
//  LocalSplitTests-Tests
//
//  Created by Yury Imashev on 02.12.2020.
//

import XCTest
import LocalSplitTests

class SplitTest_Tests: XCTestCase {

    private var userDefaults = UserDefaults(suiteName: #file)!
    private var testName = "test"

    override func setUp() {
        userDefaults.removeObject(forKey: testName)
    }

    func cleanStorage() {
        userDefaults.removeObject(forKey: testName)
    }

    // MARK: Failed initialization tests

    func testWrongFractionLow() {
        let abTest = SplitTest(name: testName, groupsCount: 2, exposure: -1, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    func testWrongFractionHigh() {
        let abTest = SplitTest(name: testName, groupsCount: 2, exposure: 2, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    func testWrongGroupsNumber() {
        let abTest = SplitTest(name: testName, groupsCount: 1, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    func testWrongGroupsNumberAndFraction() {
        let abTest = SplitTest(name: testName, groupsCount: 1, exposure: -1, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    func testWrongGroupsNumberFlagInitializer() {
        let abTest = SplitTest(name: testName, groupsCount: 1, isEligible: true, storage: userDefaults)
        XCTAssertNil(abTest)
    }

    // MARK: Successfull initialization tests

    func testRightGroupsNumber1() {
        let abTest = SplitTest(name: testName, groupsCount: 2, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightGroupsNumber2() {
        let abTest = SplitTest(name: testName, groupsCount: 10, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightGroupsNumberAndFraction1() {
        let abTest = SplitTest(name: testName, groupsCount: 10, exposure: 0.2, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightGroupsNumberAndFraction2() {
        let abTest = SplitTest(name: testName, groupsCount: 10, exposure: 1, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    func testRightGroupsNumberAndFlag() {
        let abTest = SplitTest(name: testName, groupsCount: 10, isEligible: true, storage: userDefaults)
        XCTAssertNotNil(abTest)
    }

    // MARK: Persistency test

    func testPersistency() {
        let test = SplitTest(name: testName, groupsCount: 10, storage: userDefaults)
        XCTAssertNotNil(test)

        let group = test!.userGroup
        XCTAssert(group == userDefaults.integer(forKey: testName))

        for _ in 1...100 {
            XCTAssert(group == test!.userGroup)
        }
    }

    // MARK: Groups distribution test

    func testDistribution() {
        let testsCount = 1000
        let groupsCount = 10
        var groups = [Int].init(repeating: 0, count: groupsCount)

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = SplitTest(name: testName, groupsCount: 4, exposure: 1, storage: userDefaults)
            groups[abTest!.userGroup - 1] += 1
        }
        let median = groups.sorted(by: <)[groups.count / 2]
        XCTAssert(groups.reduce(0, +) == testsCount)
        XCTAssert(median - testsCount / 2 < testsCount / 20)
    }

    func testNoInvolvedUsers1() {
        let abTest = SplitTest(name: testName, groupsCount: 4, exposure: 0, storage: userDefaults)
        XCTAssert(abTest?.userGroup == 0)
    }

    func testNoInvolvedUsers2() {
        let abTest = SplitTest(name: testName, groupsCount: 4, isEligible: false, storage: userDefaults)
        XCTAssert(abTest?.userGroup == 0)
    }

    func testUsersCallback1() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onNewTestStarted = { _ in started += 1}

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = SplitTest(name: testName, groupsCount: 4, isEligible: false, storage: userDefaults)
            _ = abTest?.userGroup
        }

        XCTAssert(skipped == testsCount)
        XCTAssert(started == 0)
    }

    func testUsersCallback2() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onNewTestStarted = { _ in started += 1}

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = SplitTest(name: testName, groupsCount: 4, exposure: 1, storage: userDefaults)
            _ = abTest?.userGroup
        }

        XCTAssert(skipped == 0)
        XCTAssert(started == testsCount)
    }

    func testPartialInvolvedUsersCallback() {
        let testsCount = 1000

        var skipped = 0
        var started = 0

        SplitTest.onTestSkipped = { _ in skipped += 1 }
        SplitTest.onNewTestStarted = { _ in started += 1}

        for _ in 1...testsCount {
            self.cleanStorage()
            let abTest = SplitTest(name: testName, groupsCount: 4, exposure: 0.5, storage: userDefaults)
            _ = abTest?.userGroup
        }

        XCTAssert(skipped + started == testsCount)
        XCTAssert(abs(skipped - started) - testsCount / 2 < testsCount / 20)
    }
}
