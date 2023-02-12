//
//  BlockTube_for_SafariUITestsLaunchTests.swift
//  BlockTube for SafariUITests
//
//  Created by 茅根啓介 on 2023/02/10.
//------------------------------------------
//  GNU General Public License v3.0
//  © 2023 Free Software Foundation, Inc.
//  For more information on the use of the code, please refer to the license

import XCTest

final class BlockTube_for_SafariUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
