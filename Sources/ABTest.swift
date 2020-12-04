//
//  LocalABTest.swift
//  LocalTestsKit
//
//  Created by Yury Imashev on 28.11.2020.
//

import Foundation

/// Local A/B Test
/// 
/// This object allows to make a split-test between two options (A and B)
public class ABTest: SplitTest {

    /// Creates an A/B test that involves all users
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    public init(name: String, storage: UserDefaults = .standard) {
        super.init(name: name, groupsCount: 2, storage: storage)!
    }

    /// Creates an A/B test that involves only users for which flag is equal to `true`
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - isUserInvolved: Flag that equals `true` if user should be involved in this test and `false` otherwise.
    ///     If user is not involved in testing, `userGroup` will be `0`.
    public init(name: String, storage: UserDefaults = .standard, isUserInvolved: Bool) {
        super.init(name: name, groupsCount: 2, storage: storage, isUserInvolved: isUserInvolved)!
    }

    /// Creates an A/B test that involves only given portion of all users.
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - usersInvolved: `Double` number that should between `0.0` and `1.0`.
    ///     `0.0` is 0% of involved users and `1.0` is 100% of involved users.
    ///     If user is not involved in testing, `userGroup` will be `0`.
    public init?(name: String, storage: UserDefaults = .standard, usersInvolved: Double) {
        super.init(name: name, groupsCount: 2, storage: storage, usersInvolved: usersInvolved)
    }
}
