//
//  TrackTests.swift
//  TrackTests
//
//  Created by Melissa Boring on 7/16/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import XCTest
@testable import Track
@testable import Pods_Track

class TrackTests: XCTestCase {
    
    var vc = LoginViewController()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        vc = storyboard.instantiateInitialViewController() as! LoginViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
