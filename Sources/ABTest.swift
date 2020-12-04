//
//  ABTest.swift
//  LocalSplitTests
//
//  Created by Yury Imashev on 28.11.2020.
//

import Foundation

/// Local A/B Test
/// 
/// This object allows to make a split-test between two options (A and B)
public class ABTest: SplitTest {

    /// Creates an A/B test.
    ///
    /// - Parameters:
    ///   - name: Name of the test. Surves also as a key for storing user group so you
    ///     should not change this value once test was started.
    ///   - storage: `UserDefaults` that is used for storing picked test group.
    ///     Default value for this parameters is `UserDefaults.standart` but if you need
    ///     to store value in a AppGroup's UserDefaults, you can set your on storage in order to
    ///     get an access from differents apps from your AppGroup.
    ///   - isEligible: Flag that equals `true` if user is eligible for this test and `false` otherwise.
    ///   - exposure: number that shows fraction on eligible users involved in testing.
    ///     This number that should between `0.0` and `1.0`.
    ///     `0.0` is 0% of involved users and `1.0` is 100% of involved users.
    public init?(name: String, isEligible: Bool = true, exposure: Double = 1, storage: UserDefaults = .standard) {
        super.init(name: name, groupsCount: 2, isEligible: isEligible, exposure: exposure, storage: storage)
    }
}
