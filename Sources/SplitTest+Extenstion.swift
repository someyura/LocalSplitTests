//
//  SplitTest+Extenstion.swift
//  LocalSplitTests
//
//  Created by Yury Imashev on 29.11.2020.
//

import Foundation

extension SplitTest {

    /// This method extracts existing value from storage or generates new value in there is none
    func getUserTestingGroup(groupsCount: Int) -> Int {
        if let savedValue = storage.value(forKey: name) as? Int {
            // If user group is already picked, return value from storage...
            return savedValue
        } else {
            // ...or pick a group otherwise
            return pickTestingGroup(groupsCount: groupsCount)
        }
    }

    /// Picks a testing group from user base on test settings
    func pickTestingGroup(groupsCount: Int) -> Int {
        // Check if user should be involved in testing
        guard isUserInvolved else {
            // If not, set test group to 0
            storage.set(0, forKey: name)
            // ...calling an optional handler
            SplitTest.onTestSkipped?(self)
            // ...return test group
            return 0
        }

        // Pick a random group
        let value = Int.random(in: 1...groupsCount)
        // ...save picked value to a provided storage
        storage.set(value, forKey: name)
        storage.synchronize()
        // ...calling an optional handler
        SplitTest.onTestStarted?(self)
        // ...return picked test group
        return value
    }
}

extension SplitTest {
    /// This closure will be called when new test will be picked for involved user
    /// You can use this clouse to send an event to your analytics service
    public static var onTestStarted: ((SplitTest) -> Void)? = nil

    /// This closure will be called when current user will skip the test
    /// You can use this clouse to send an event to your analytics service 
    public static var onTestSkipped: ((SplitTest) -> Void)? = nil
}
