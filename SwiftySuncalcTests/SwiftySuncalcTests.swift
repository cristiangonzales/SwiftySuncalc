/**
 (c) 2011-2015, Vladimir Agafonkin
 SunCalc is a JavaScript library for calculating sun/moon position and light phases.
 
 - Author:
 Cristian Gonzales
 
 - Purpose:
 Unit tests for the SwiftySuncalc library. Created for SwiftySuncalc, 2018.
 
 - License:
 MIT License
 */

import XCTest
@testable import SwiftySuncalc

class SwiftySuncalcTests: XCTestCase
{
    // Class variables for SUT testing purposes
    var suncalcTest: SwiftySuncalc!,
        // Date to test the class (to be passed)
        testDate: Date!,
        // Test latitudes (lat) and longitudes (lng), to test the function calls
        testLat: Double!,
        testLng: Double!
    
    override func setUp()
    {
        super.setUp()
        suncalcTest = SwiftySuncalc()
        // Declare the test date to be today's date
        testDate = Date()
    }
    
    override func tearDown()
    {
        suncalcTest = nil
        testDate = nil
        testLat = nil
        testLng = nil
        super.tearDown()
    }
    
    func testExample()
    {
        
    }
    
}
