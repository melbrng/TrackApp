//
//  FirebaseHelperTests.swift
//  Track
//
//  Created by Melissa Boring on 8/1/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import XCTest
@testable import Track
@testable import Pods_Track

class FirebaseHelperTests: XCTestCase {

    let helper = FirebaseHelper.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInsertTrack() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let trackKey = helper.TRACK_REF.childByAutoId().key
        let track = ["uid": trackKey,
                 "name": "TestTrack",
                 "desc": "This is a test Track"]
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 6 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
           self.helper.createNewTrack(trackKey, track: track)
        }
        
        
        
        //helper.queryTracksByUid(trackKey)
        
        //print(helper.trackDict)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
