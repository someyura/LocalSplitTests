//
//  SplitTest.swift
//  LocalSplitTests
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

    /// Flag that equals `true` if user should be involved in this test and `false` otherwise.
    internal var isUserInvolved: Bool = true

    /// `UserDefaults` that is used for storing picked test group.
    internal var storage: UserDefaults

    /// Returns digit that represents test group for current user. Can be any integer from `1` up to `groupsCount`.
    /// If user is not involved in testing, returns `0`.
    public var userGroup: Int {
        /// If user group is already picked, return value from storage an pick a group otherwise
        return getUserTestingGroup(groupsCount: groupsCount)
    }

    /// Creates an multiple variant test.
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - groupsCount: Number of test groups. Should be more or eual to `2`.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - isEligible: Flag that equals `true` if user is eligible for this test and `false` otherwise.
    ///   - exposure: number that shows fraction on eligible users involved in testing.
    ///     This number that should between `0.0` and `1.0`.
    ///     `0.0` is 0% of involved users and `1.0` is 100% of involved users.
    ///     If user was opted out of testing, `userGroup` will be `0`.
    public init?(name: String, groupsCount: Int, isEligible: Bool = true, exposure: Double = 1, storage: UserDefaults = .standard) {
        guard groupsCount >= 2 else {
            assertionFailure("There should be at least two test groups!")
            return nil
        }
        guard (0.0...1.0 ~= exposure) else {
            assertionFailure("Fraction of involved users should be in interval [0; 1]!")
            return nil
        }
        self.name = name
        self.groupsCount = groupsCount
        self.storage = storage
        self.isUserInvolved = Double.random(in: 0...1) <= exposure && isEligible
    }
}
