//
//  LocalSplitTest.swift
//  LocalTestsKit
//
//  Created by Yury Imashev on 28.11.2020.
//

import Foundation

/// Local Multiple Variant Test
/// 
/// This object allows to make a split-test between provided number of options
public class SplitTest {

    /// String that surves as a key for storing user group so it should not be changed since test was started.
    public var name: String

    /// Amount of test group
    internal var groupsCount: Int

    /// `UserDefaults` that is used for storing picked test group.
    internal var storage: UserDefaults

    /// Flag that equals `true` if user should be involved in this test and `false` otherwise.
    internal var isUserInvolved: Bool = true

    /// Returns digit that represents test group for current user. Can be any integer from `1` up to `groupsCount`.
    /// If user is not involved in testing, returns `0`.
    public var userGroup: Int {
        /// If user group is already picked, return value from storage an pick a group otherwise
        return getUserTestingGroup(groupsCount: groupsCount)
    }

    /// Creates an multiple variant test that involves all users
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - groupsCount: Number of test groups. Should be more or eual to `2`.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    public init?(name: String, groupsCount: Int, storage: UserDefaults = .standard) {
        guard groupsCount >= 2 else {
            assertionFailure("There should be at least two test groups!")
            return nil
        }
        self.name = name
        self.groupsCount = groupsCount
        self.storage = storage
    }

    /// Creates an multiple variant test that involves only users for which flag is equal to `true`
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - groupsCount: Number of test groups. Should be more or eual to `2`.     
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - isUserInvolved: Flag that equals `true` if user should be involved in this test and `false` otherwise.
    ///     If user is not involved in testing, `userGroup` will be `0`.
    public init?(name: String, groupsCount: Int, storage: UserDefaults = .standard, isUserInvolved: Bool) {
        guard groupsCount >= 2 else {
            assertionFailure("There should be at least two test groups!")
            return nil
        }
        self.name = name
        self.groupsCount = groupsCount
        self.storage = storage
        self.isUserInvolved = isUserInvolved
    }

    /// Creates an multiple variant test that involves only given portion of all users.
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - groupsCount: Number of test groups. Should be more or eual to `2`.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - usersInvolved: `Double` number that should between `0.0` and `1.0`.
    ///     `0.0` is 0% of involved users and `1.0` is 100% of involved users.
    ///     If user is not involved in testing, `userGroup` will be `0`.
    public init?(name: String, groupsCount: Int, storage: UserDefaults = .standard, usersInvolved: Double) {
        guard groupsCount >= 2 else {
            assertionFailure("There should be at least two test groups!")
            return nil
        }
        guard (0.0...1.0 ~= usersInvolved) else {
            assertionFailure("Fraction of involved users should be in interval [0; 1]!")
            return nil
        }
        self.name = name
        self.groupsCount = groupsCount
        self.storage = storage
        self.isUserInvolved = Double.random(in: 0...1) <= usersInvolved
    }
}
