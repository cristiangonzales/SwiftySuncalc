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

import Foundation
import os.log
import XCTest
@testable import SwiftySuncalc

class SwiftySuncalcTests: XCTestCase
{
    // Class variables for SUT testing purposes
    var suncalcTest: SwiftySuncalc!,
        // Date to test the class (to be passed)
        customDate: Date!,
        // Test latitudes (lat) and longitudes (lng), to test the function calls
        testLat: Double!,
        testLng: Double!,
        // Test dates for assert statements
        solarNoon: Date!, nadir: Date!, sunrise: Date!, sunset: Date!, sunriseEnd: Date!,
        sunsetStart: Date!, dawn: Date!, dusk: Date!, nauticalDawn: Date!, nauticalDusk: Date!,
        nightEnd: Date!, night: Date!, goldenHourEnd: Date!, goldenHour: Date!,
        // Values for moon rising and setting
        moonRise: Date!, moonSet: Date!
    
    override func setUp()
    {
        super.setUp()
        suncalcTest = SwiftySuncalc()
        do
        {
            // Declare the test date to be customDate's date
            try customDate = newTestDate(year: 2013, month: 3, day: 4, zone: "PDT", hour: 16,
                                         minute: 0, second: 0)
            // Test times to be asserted against the results
            try solarNoon = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC", hour: 10,
                                        minute: 10, second: 57)
            try nadir = newTestDate(year: 2013, month: 3, day: 4, zone: "UTC", hour: 22,
                                    minute: 10, second: 57)
            try sunrise = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC", hour: 4,
                                      minute: 34, second: 56)
            try sunset = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC", hour: 15,
                                     minute: 46, second: 57)
            try sunriseEnd = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                         hour: 4, minute: 38, second: 19)
            try sunsetStart = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                          hour: 15, minute: 43, second: 34)
            try dawn = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 4, minute: 2, second: 17)
            try dusk = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 16, minute: 19, second: 36)
            try nauticalDawn = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                           hour: 3, minute: 24, second: 31)
            try nauticalDusk = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 16, minute: 57, second: 22)
            try nightEnd = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 2, minute: 46, second: 17)
            try night = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 17, minute: 35, second: 36)
            try goldenHourEnd = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 5, minute: 19, second: 1)
            try goldenHour = newTestDate(year: 2013, month: 3, day: 5, zone: "UTC",
                                   hour: 15, minute: 2, second: 52)
            // Moon test times
            try moonRise = newTestDate(year: 2013, month: 3, day: 4, zone: "GMT",
                                       hour: 23, minute: 54, second: 29)
            try moonSet = newTestDate(year: 2013, month: 3, day: 4, zone: "GMT",
                                      hour: 7, minute: 47, second: 58)
            // Latitude and longitude tests
            testLat = 50.5
            testLng = 30.5
        }
        catch
        {
            os_log("Custom date threw an exception: wrong usage!", log: OSLog.default, type: .error)
        }
    }
    
    override func tearDown()
    {
        suncalcTest = nil
        customDate = nil
        solarNoon = nil
        nadir = nil
        sunrise = nil
        sunset = nil
        sunriseEnd = nil
        sunsetStart = nil
        dawn = nil
        dusk = nil
        nauticalDawn = nil
        nauticalDusk = nil
        nightEnd = nil
        night = nil
        goldenHourEnd = nil
        goldenHour = nil
        testLat = nil
        testLng = nil
        super.tearDown()
    }
    
    /**
     Testing the times functionality
     */
    func testTimes()
    {
        var times = suncalcTest.getTimes(date: customDate, lat: testLat, lng: testLng)
        XCTAssertEqual(times["solarNoon"], solarNoon, "Solar noon times are not equal!")
        XCTAssertEqual(times["nadir"], nadir, "Nadir times are not equal!")
        XCTAssertEqual(times["sunrise"], sunrise, "Sunrise times are not equal!")
        XCTAssertEqual(times["sunset"], sunset, "Sunset times are not equal!")
        XCTAssertEqual(times["sunriseEnd"], sunriseEnd, "Sunrise end times are not equal!")
        XCTAssertEqual(times["sunsetStart"], sunsetStart, "Sunset start times are not equal!")
        XCTAssertEqual(times["dawn"], dawn, "Dawn times are not equal!")
        XCTAssertEqual(times["dusk"], dusk, "Dusk times are not equal!")
        XCTAssertEqual(times["nauticalDawn"], nauticalDawn, "Nautical dawn times are not equal!")
        XCTAssertEqual(times["nauticalDusk"], nauticalDusk, "Nautical dusk times are not equal!")
        XCTAssertEqual(times["nightEnd"], nightEnd, "Night end times are not equal!")
        XCTAssertEqual(times["night"], night, "Night times are not equal!")
        XCTAssertEqual(times["goldenHourEnd"], goldenHourEnd, "Golden hour end times are not equal!")
        XCTAssertEqual(times["goldenHour"], goldenHour, "Golden hour times are not equal!")
    }
    
    /**
     Testing for moon positioning
     */
    func testMoonPosition()
    {
        var moonPos = suncalcTest.getMoonPosition(date: customDate, lat: testLat, lng: testLng)
        XCTAssertEqual(moonPos["azimuth"], -0.9783999522438226, "Moon azimuth position values not equal!")
        XCTAssertEqual(moonPos["altitude"], 0.014551482243892251, "Moon altitude position values not equal!")
        XCTAssertEqual(moonPos["distance"], 364121.37256256194, "Moon distance position values not equal!")
    }
    
    /**
     Testing sun positioning
     */
    func testSunPosition()
    {
        var sunPos = suncalcTest.getPosition(date: customDate, lat: testLat, lng: testLng)
        XCTAssertEqual(sunPos["azimuth"], -2.5003175907168385, "Azimuth values are not equal for sun position!")
        XCTAssertEqual(sunPos["altitude"], -0.7000406838781611, "Altitude values are not equal for sun position!")
    }
    
    /**
     Testing for moon times
     */
    func testMoonTimes()
    {
        var moonTimes = suncalcTest.getMoonTimes(date: customDate, lat: testLat, lng: testLng)
        XCTAssertEqual(moonTimes["rise"], moonRise, "Moon rise times are not equal!")
        XCTAssertEqual(moonTimes["set"], moonSet, "Moon set times are not equal!")
    }
    
    /**
     Testing for moon illumination values
     */
    func testMoonIllumination()
    {
        var moonIllumination = suncalcTest.getMoonIllumination(date: customDate)
        XCTAssertEqual(moonIllumination["fraction"], 0.4848068202456373, "Moon illumination fraction values are not equal!")
        XCTAssertEqual(moonIllumination["phase"], 0.7548368838538762, "Moon illumination phase values are not equal!")
        XCTAssertEqual(moonIllumination["angle"], 1.6732942678578346, "Moon illumination angle values are not equal!")

    }
    
    /**
    Helper function aside from the regular function signatures part of the XCTest framework to
     construct a custom date object for testing. See: https://stackoverflow.com/a/33344575/4883617
     
     - parameters:
        - year: Specified year as an integer of length 4
        - month: Specified month as an integer of length 1 or 2
        - day: Specified day as an integer of length 1 or 2
        - zone: Specified time zone, as an string of length 1-3
        - hour: Specified hour as an integer of length 1 or 2
        - minute: Specified minute as an integer of length 1 or 2
        - second: Specified second as an integer of length 1 or 2
     
     - returns:
     Swift Date() object with the custom parameters specified by the caller.
     */
    func newTestDate(year: Int, month: Int, day: Int, zone: String,
                     hour: Int, minute: Int, second: Int) throws -> Date
    {
        // Error checking for parameters by caller
        if String(year).count != 4 || (String(month).count != 1 && String(month).count != 2)
             || (String(day).count != 1 && String(day).count != 2)  || (zone.count > 3 || zone.count < 1)
             || (String(hour).count != 1 && String(hour).count != 2) || (String(minute).count != 1
             && String(minute).count != 2) || (String(second).count != 1 && String(second).count != 2)
        {
            throw "Invalid length for parameters specified by the caller. See docstrings."
        }
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        // Time zone specified by caller
        dateComponents.timeZone = TimeZone(abbreviation: zone)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        // Create date from components
        return Calendar.current.date(from: dateComponents)!
    }
}

extension String: Error
{
    
}
