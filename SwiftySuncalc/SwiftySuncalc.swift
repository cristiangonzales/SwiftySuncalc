/**
 (c) 2011-2015, Vladimir Agafonkin
 SunCalc is a JavaScript library for calculating sun/moon position and light phases.
 
 - Important:
 This class is ported from https://github.com/mourner/suncalc
 All formulas used, as stated in @mourner's suncalc.js file, can be found here:
 http://aa.quae.nl/en/reken/zonpositie.html
 
 - Author:
 Cristian Gonzales
 
 - Version:
 0.1
 
 - License:
 MIT License
 
 Copyright (c) 2018 Cristian Gonzales
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

public class SwiftySuncalc
{
    // Simple conventions
    internal let PI: Double = Double.pi
    internal let rad: Double = Double.pi / 180.0
    
    // Date/time conversions (Julian time)
    internal let dayMs: Double = 1000.0 * 60.0 * 60.0 * 24.0
    internal let J0: Double = 0.0009
    internal let J1970: Double = 2440588.0
    internal let J2000: Double = 2451545.0
    
    // Obliquity of the Earth
    internal let e: Double = (Double.pi / 180.0) * 23.4397
    
    // Sun time configuration (angle, morning name, evening name)
    internal var times: [[Any]] = [
        [-0.833, "sunrise",       "sunset"      ],
        [  -0.3, "sunriseEnd",    "sunsetStart" ],
        [    -6.0, "dawn",          "dusk"        ],
        [   -12.0, "nauticalDawn",  "nauticalDusk"],
        [   -18.0, "nightEnd",      "night"       ],
        [     6.0, "goldenHourEnd", "goldenHour"  ]
    ]
    
    /**
     For this kind of astronomical calculations, it is convenient to express the date and time using
     an unending day numbering scheme. Such a scheme is provided by the Julian Day Number. The Julian
     Day Number Calculation Page explains how you can calculate the Julian Day Number for a date in
     the Gregorian calendar. For the calculations of the position of the Sun you should express time
     as Universal Time (UTC), and this includes the Julian Date.
     
     - parameters:
     - date: a Date() object passed by the callee
     
     - returns:
     A double calculating the date in Julian, in milliseconds
     */
    private func toJulian(date: Date) -> Double
    {
        return Double(date.millisecondsSince1970) / dayMs - 0.5 + J1970
    }
    
    /**
     Conversion of a given date from Julian date (double) to a date object (1970 and onward)
     
     - parameters:
     - j: an integer offset to calculate the date in milliseconds
     
     - returns:
     A date object for any specified Julian value
     */
    private func fromJulian(j: Double) -> Date
    {
        return Date(milliseconds: Int((j + 0.5 - J1970) * dayMs))
    }
    
    /**
     Conversion of a date object to a double number of the amount of days
     - parameters:
     - date: a Date() object passed by the callee
     - returns:
     A double value for the total amount of days.
     */
    private func toDays(date: Date) -> Double
    {
        return toJulian(date: date) - J2000
    }
    
    /**
     The right ascension is the coordinate from the equatorial coordinate system in the sky that has
     the same role as the longitude in other coordinate systems. The right ascension is measured from
     the vernal equinox. The right ascension is usually measured not in degrees as the other
     longitudes are, but rather in units of time, such that 360 degrees correspond to 24 hours of
     right ascension, and 15 degrees to 1 hour of right ascension. Just like for real time, an hour
     (symbol: h) of right ascension is divided into 60 minutes (symbol: m), and one minute into 60
     seconds (symbol: s). Here is an example of a right ascension: 5h23m12s, or 5 hours, 23 minutes,
     and 12 seconds.
     
     - parameters:
     - l: The ecliptic longitude of the Sun, as seen from Earth
     - b: Radians (?)
     
     - return:
     A double indicating the right acension given the appropriate function arguments
     */
    private func rightAscension(l: Double, b: Double) -> Double
    {
        return atan2(sin(l) * cos(e) - tan(b) * sin(e), cos(l))
    }
    
    /**
     The declination determines from which parts of the planet the object can be visible. The
     declination is the coordinate in the equatorial coordinate system in the sky that is similar
     to latitude on Earth. It ranges between −90 degrees at the southern celestial pole and +90
     degrees at the northern celestial pole and is zero at the celestial equator. The other
     equatorial coordinate is the right ascension.
     
     - parameters:
     - l: The ecliptic longitude of the Sun, as seen from Earth
     - b: Radians (?)
     
     - return:
     A double indicating the declination given the appropriate function arguments
     */
    private func declination(l: Double, b: Double) -> Double
    {
        return asin(sin(b) * cos(e) + cos(b) * sin(e) * sin(l))
    }
    
    /**
     The azimuth is the coordinate from the horizontal coordinate system that indicates the direction
     along the horizon. The azimuth is measured in degrees, but not everyone uses the same range of
     azimuth or the same zero point. Sometimes the azimuth is measured between −180 and +180°,
     sometimes between 0 and 360°, and sometimes with 0° in the south, and sometimes with 0° in the
     north. For astronomical application it is convenient to set 0° in the south and to measure
     azimuth between −180 and +180°: that provides the best fit to the hour angle.
     
     - parameters:
     - H: The hour angle, which indicates how long ago (measured in sidereal time) the celestial
     body passed through the celestial meridian.
     - phi: Latitude φ [phi] north
     - dec: Equatorial coordinates to express the position of the body between the stars
     
     - return:
     Azimuth value, expressed as a Double
     */
    private func azimuth(H: Double, phi: Double, dec: Double) -> Double
    {
        return atan2(sin(H), cos(H) * sin(phi) - tan(dec) * cos(phi))
    }
    
    /**
     In the horizontal coordinate system, altitude is the coordinate that measures the height above the
     horizon (in degrees). The other coordinate is the azimuth. Because the true horizon depends on
     the local landscape and the exact location of the observer, astronomers often use an "artificial"
     horizon that runs exactly midway between the zenith and nadir. If you read about astronomical
     altitudes, then you may assume they are measured relative to the artificial horizon, unless
     the accompanying text says otherwise.
     
     - parameters:
     - H: The hour angle, which indicates how long ago (measured in sidereal time) the celestial
     body passed through the celestial meridian.
     - phi: Latitude φ [phi] north
     - dec: Equatorial coordinates to express the position of the body between the stars
     
     - returns:
     Altitude, expressed as a Double
     */
    private func altitude(H: Double, phi: Double, dec: Double) -> Double
    {
        return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(H));
    }
    
    /**
     Where a celestial body is in your sky depends on your geographical coordinates (latitude φ
     [phi] north, longitude west), on the position of the body between the stars (its equatorial
     coordinates α and δ ), and on the rotation angle of the planet at your location, relative to
     the stars. That latter angle is expressed in the sidereal time θ (theta). The sidereal time is
     the right ascension that is on the celestial meridian at that moment.
     
     - parameters:
     - d: The rate of change of sidereal time, in degrees per day
     - lw: Longitude west, measured by degrees
     
     - returns:
     The sidereal time (a value between 0 and 24 hours)
     */
    private func siderealTime(d: Double, lw: Double) -> Double
    {
        return rad * (280.16 + 360.9856235 * d) - lw
    }
    
    /**
     Astronomical refraction deals with the angular position of celestial bodies, their appearance
     as a point source, and through differential refraction, the shape of extended bodies such as
     the Sun and Moon.
     
     - parameters:
     - h: Measure of degrees
     
     - returns:
     Measure of astronomical refraction in radians
     */
    private func astroRefraction(h: Double) -> Double
    {
        var h: Double = h
        // The following formula works for positive altitudes only. A div/0 will occur if less than 0
        // (hence the following conditional)
        if (h < 0.0)
        {
            h = 0.0
        }
        
        // See forumla 16.4 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell,
        // Richmond) 1998. 1.02 / tan(h + 10.26 / (h + 5.10)) h in degrees, result in
        // arc minutes -> converted to radians
        return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179))
    }
    
    /**
     Because we see the Sun from the planet, we see the motion of the planet around the Sun reflected
     in the apparent motion of the Sun along the ecliptic, relative to the stars. If the orbit of the
     planet were a perfect circle, then the planet as seen from the Sun would move along its orbit
     at a fixed speed, and then it would be simple to calculate its position (and also the position
     of the Sun as seen from the planet). The position that the planet would have relative to its
     perihelion if the orbit of the planet were a circle is called the mean anomaly, indicated in the
     formulas as M.
     
     - parameters:
     - d: The time since 00:00 UTC at the beginning of the most recent January 1st, measured in (whole and
     fractional) days.
     
     - returns:
     The mean anomaly
     */
    private func solarMeanAnomaly(d: Double) -> Double
    {
        return rad * (357.5291 + 0.98560028 * d)
    }
    
    /**
     The ecliptical longitude (lambda) is the position along the ecliptic, relative to the vernal
     equinox (so relative to the stars). The mean longitude L is the ecliptical longitude that the
     planet would have if the orbit were a perfect circle. That is, L = M + PI. The ecliptic longitude
     of the planet as seen from the Sun is equal to is (mean anomaly) + (center) + (perihelion) + PI
     
     - parameters:
     - m: The mean anomaly, as a Double
     
     - returns:
     The ecliptical longitude, as a Double
     */
    private func eclipticLongitude(m: Double) -> Double
    {
        // Equation of the center
        let c: Double = rad * (1.9148 * sin(m) + 0.02 * sin(2.0 * m) + 0.0003 * sin(3.0 * m))
        // Perihelion of the Earth
        let p: Double = rad * 102.9372
        return m + c + p + PI
    }
    
    /**
     The equatorial coordinate system in the sky is tied to the rotation axis of the planet. The
     equatorial coordinates are the right ascension α (alpha) and the declination δ (delta). The
     declination determines from which parts of the planet the object can be visible, and the right
     ascension determines (together with other things) when the object is visible.
     
     - parameters:
     - d: The time since 00:00 UTC at the beginning of the most recent January 1st, measured in
     (whole and fractional) days.
     
     - returns:
     The equatorial coordinates from the ecliptic coordinates (declination and right ascension)
     */
    private func sunCoords(d: Double) -> Dictionary<String, Double>
    {
        let mean: Double = solarMeanAnomaly(d: d)
        let long: Double = eclipticLongitude(m: mean)
        
        return [
            "dec": declination(l: long, b: 0.0),
            "ra": rightAscension(l: long, b: 0.0)
        ]
    }
    
    /**
     TODO
     
     - parameters:
     - d: The rate of change of sidereal time, in degrees per day
     - lw: Longitude west, measured by degrees
     
     - returns:
     TODO
     */
    private func julianCycle(d: Double, lw: Double) -> Double
    {
        return ((d - J0 - lw / (2.0 * PI)).rounded())
    }
    
    /**
     A celestial body culminates (is in culmination) when it is highest in the sky. At that moment,
     the body goes through the celestial meridian, which runs from the northern celestial pole via
     the zenith to the southern celestial pole. The culmination is also called the transit.
     
     - parameters:
     - Ht: TODO
     - lw: Longitude west, measured by degrees
     - n: TODO
     
     - returns:
     TODO
     */
    private func approxTransit(Ht: Double, lw: Double, n: Double) -> Double
    {
        return J0 + (Ht + lw) / (2.0 * PI) + n;
    }
    
    /**
     The transit of a celestial body is the moment at which the body passes through the celestial
     meridian. The transit of the Sun is noon, the middle of the day, at 12 hours solar time.
     
     - parameters:
     - ds: TODO
     - M: TODO
     - L: TODO
     
     - returns:
     TODO
     */
    private func solarTransitJ(ds: Double, M: Double, L: Double) -> Double
    {
        return J2000 + ds + 0.0053 * sin(M) - 0.0069 * sin(2.0 * L)
    }
    
    /**
     The hour angle of a celestial body is the difference in right ascension between that body and
     the meridian (of right ascension) that is due south at that time. The hour angle is usually
     measured not in degrees but in hours, minutes, and seconds, just like the right ascension.
     The hour angle indicates (in sidereal time) how long ago the body was due south.
     
     - parameters:
     - h: h0, expressed as type Double
     - phi: Latitude φ [phi] north
     - d: Equatorial coordinates to express the position of the body between the stars
     
     - returns:
     The hour angle (of type Double)
     */
    private func hourAngle(h: Double, phi: Double, d: Double) -> Double
    {
        return acos((sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d)))
    }
    
    /**
     Returns set time for the given sun altitude.
     
     - parameters:
     - h: h0, expressed as type Double
     - lw: Longitude west, measured by degrees
     - phi: Latitude φ [phi] north
     - dec: Equatorial coordinates to express the position of the body between the stars
     - n: TODO
     - M: TODO
     - L: TODO
     
     - returns:
     Set time for a given sun altitude (of type Double)
     */
    private func getSetJ(h: Double, lw: Double, phi: Double,
                         dec: Double, n: Double, M: Double, L: Double) -> Double
    {
        let w: Double = hourAngle(h: h, phi: phi, d: dec),
        a: Double = approxTransit(Ht: w, lw: lw, n: n)
        
        return solarTransitJ(ds: a, M: M, L: L)
    }
    
    /**
     Moon calculations, based off of formulas from http://aa.quae.nl/en/reken/hemelpositie.html
     
     - parameters:
     - d: is the number of days since 1 January 2000, 12:00 UTC, just like in the calculations
     for the planets
     
     - returns:
     Geocentric ecliptic coordinates of the moon
     */
    private func moonCoords(d: Double) -> Dictionary<String, Double>
    {
        // Ecliptic longitude
        let L: Double = rad * (218.316 + 13.176396 * d),
        // Mean anomaly
        M: Double = rad * (134.963 + 13.064993 * d),
        // Mean distance
        F: Double = rad * (93.272 + 13.229350 * d),
        // Longitude
        l: Double = L + rad * 6.289 * sin(M),
        // Latitude
        b: Double = rad * 5.128 * sin(F),
        // Distance to the moon in km
        dt: Double = 385001.0 - 20905.0 * cos(M)
        
        return [
            "ra": rightAscension(l: l, b: b),
            "dec": declination(l: l, b: b),
            "dist": dt
        ]
    }
    
    /**
     Helper function to obtain the date offset by a certain amount of hours
     
     - parameters:
     - date: The initial date to be offset
     - h: The amount of hours to offset `date` by
     
     - returns:
     The new date after the offset.
     */
    private func hoursLater(date: Date, h: Double) -> Date
    {
        return Date(milliseconds: Int(Double(date.millisecondsSince1970) + h * dayMs  / 24.0))
    }
    
    /**
     Suncalc constructor
     */
    public init()
    {
        
    }
    
    /**
     Helper function to get the sun's position for a given date and latitude/longitude.
     
     - parameters:
     - date: The current date, given as a Date() object
     - lat: The latitude given by the caller, expressed as a Double
     - lng: The longitude given by the caller, expressed as a Double
     
     - returns:
     Dictionary containing azimuth and altitude values, both expressed as type Double
     */
    public func getPosition(date: Date, lat: Double, lng: Double) -> Dictionary<String, Double>
    {
        var lw = rad * -lng,
        phi = rad * lat,
        d = toDays(date: date),
        
        c = sunCoords(d: d),
        H = siderealTime(d: d, lw: lw) - c["ra"]!
        
        return [
            "azimuth": azimuth(H: H, phi: phi, dec: c["dec"]!),
            "altitude": altitude(H: H, phi: phi, dec: c["dec"]!)
        ]
    }
    
    /**
     Helper function to add a custom time to the times configuration.
     
     - parameters:
     - angle: Approximate angle given by the caller (in degrees, e.g. -0.3 or 6)
     - riseName: Name of the rise (e.g 'sunrise' or 'sunriseEnd')
     - setName: Name of the set (e.g. 'sunset' or 'sunsetStart')
     
     - returns:
     Nil
     */
    public func addTime(angle: Double, riseName: String, setName: String)
    {
        times.append([angle, riseName, setName])
    }
    
    /**
     Calculates sun times for a given date and latitude/longitude.
     
     - parameters:
     - date: The current date, given as a Date() object
     - lat: The latitude given by the caller, expressed as a Double
     - lng: The longitude given by the caller, expressed as a Double
     
     - returns:
     A dictionary of strings indicating the time, and an associated date indicating the time at which
     these occurences occur
     */
    public func getTimes(date: Date, lat: Double, lng: Double) -> Dictionary<String, Date>
    {
        var lw: Double = rad * -lng,
        phi: Double = rad * lat,
        
        d: Double = toDays(date: date),
        n: Double = julianCycle(d: d, lw: lw),
        ds: Double = approxTransit(Ht: 0.0, lw: lw, n: n),
        
        M: Double = solarMeanAnomaly(d: ds),
        L: Double = eclipticLongitude(m: M),
        dec: Double = declination(l: L, b: 0.0),
        
        Jnoon: Double = solarTransitJ(ds: ds, M: M, L: L),
        
        time: [Any], Jset: Double, Jrise: Double
        
        var result: Dictionary<String, Date> = [
            "solarNoon": fromJulian(j: Jnoon),
            "nadir": fromJulian(j: (Jnoon - 0.5))
        ]
        
        for i in 0...(times.count - 1)
        {
            time = times[i]
            
            Jset = getSetJ(h: (time[0] as! Double) * rad, lw: lw, phi: phi, dec: dec, n: n, M: M, L: L)
            Jrise = Jnoon - (Jset - Jnoon)
            
            result[time[1] as! String] = fromJulian(j: Jrise)
            result[time[2] as! String] = fromJulian(j: Jset)
        }
        return result
    }
    
    /**
     Calculates the moon position for a given date and latitude/longitude.
     
     - parameters:
     - date: The current date, given as a Date() object
     - lat: The latitude given by the caller, expressed as a Double
     - lng: The longitude given by the caller, expressed as a Double
     
     - returns:
     A dictionary of strings indicating the azimuth, altitude, distance, and parallactic angle, and
     an associated date indicating the time at which these occurences occur.
     */
    public func getMoonPosition(date: Date, lat: Double, lng: Double) -> Dictionary<String, Double>
    {
        var lw: Double = rad * -lng,
        phi: Double = rad * lat,
        d: Double = toDays(date: date),
        
        c: Dictionary<String, Double> = moonCoords(d: d),
        H: Double = siderealTime(d: d, lw: lw) - c["ra"]!,
        alt: Double = altitude(H: H, phi: phi, dec: c["dec"]!),
        // Formula 14.1 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell,
        // Richmond) 1998.
        pa: Double = atan2(sin(H), tan(phi) * cos(c["dec"]!) - sin(c["dec"]!) * cos(H)),
        // Altitude correction for refraction
        h: Double = alt + astroRefraction(h: alt)
        
        return [
            "azimuth": azimuth(H: H, phi: phi, dec: c["dec"]!),
            "altitude": h,
            "distance": c["dist"]!,
            "parallacticAngle": pa
        ]
    }
    
    /**
     Calculations for illumination parameters of the moon,
     based on http://idlastro.gsfc.nasa.gov/ftp/pro/astro/mphase.pro formulas and
     Chapter 48 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
     
     - parameters:
     - date: Date for requested moon illumination metrics
     
     - returns:
     A dictionary with "fraction", "phase", and "angle" values
     */
    public func getMoonIllumination(date: Date) -> Dictionary<String, Double>
    {
        var d: Double;
        if date < Date()
        {
            d = toDays(date: date)
        }
        else
        {
            d = toDays(date: Date())
        }
        
        var s: Dictionary<String, Double> = sunCoords(d: d),
        m: Dictionary<String, Double> = moonCoords(d: d),
        // Distance from Earth to Sun in km
        sdist: Double = 149598000.0,
        
        phi: Double = acos(sin(s["dec"]!) * sin(m["dec"]!) + cos(s["dec"]!)
            * cos(m["dec"]!) * cos(s["ra"]! - m["ra"]!)),
        inc: Double = atan2(sdist * sin(phi), m["dist"]! - sdist * cos(phi)),
        angle: Double = atan2(cos(s["dec"]!) * sin(s["ra"]! - m["ra"]!),  sin(s["dec"]!) * cos(m["dec"]!) -
            cos(s["dec"]!) * sin(m["dec"]!) * cos(s["ra"]! - m["ra"]!))
        
        return [
            "fraction": (1.0 + cos(inc)) / 2.0,
            "phase": 0.5 + 0.5 * inc * (angle < 0.0 ? -1.0 : 1.0) / PI,
            "angle": angle
        ]
    }
    
    
    /**
     User helper method to determine calculations for moon rise/set times, as based on
     http://www.stargazing.net/kepler/moonrise.html article
     
     - important:
     The default for all iOS devices is local time, so the `inUTC` parameter boolean option
     was omitted from the function signature.
     
     - parameters:
     - date: The current date, given as a Date() object
     - lat: The latitude given by the caller, expressed as a Double
     - lng: The longitude given by the caller, expressed as a Double
     
     - returns:
     A dictionary with associated "rise" and "set" values to be indexed. In the function
     signature, the Date value is optional because there might not be a computable value
     for "rise" or "set". In the case that there is no value, `nil` will take it's place.
     */
    public func getMoonTimes(date: Date, lat: Double, lng: Double) -> Dictionary<String, Date?>
    {
        var t: Date =  Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!,
            hc: Double = 0.133 * rad,
            h0: Double = getMoonPosition(date: t, lat: lat, lng: lng)["altitude"]! - hc,
            h1: Double,
            h2: Double,
            rise: Double? = nil,
            set: Double? = nil,
            a: Double,
            b: Double,
            xe: Double,
            ye: Double,
            d: Double,
            roots: Int,
            x1: Double? = nil,
            x2: Double? = nil,
            dx: Double
        
        // Go in 2-hour chunks, each time seeing if a 3-point quadratic curve crosses zero
        // (which means rise or set)
        for i in stride(from: 1, to: 24, by: 2)
        {
            h1 = getMoonPosition(date: hoursLater(date: t,
                                                  h: Double(i)), lat: lat, lng: lng)["altitude"]! - hc
            h2 = getMoonPosition(date: hoursLater(date: t,
                                                  h: Double(i + 1)), lat: lat, lng: lng)["altitude"]! - hc
            a = (h0 + h2) / 2.0 - h1
            b = (h2 - h0) / 2.0
            xe = -b / (2.0 * a)
            ye = (a * xe + b) * xe + h1
            d = b * b - 4.0 * a * h1
            roots = 0
            
            if d >= 0.0
            {
                dx = Double(sqrt(d)) / Double(abs(a) * 2.0)
                x1 = xe - dx
                x2 = xe + dx
                if abs(x1!) <= 1.0
                {
                    roots = roots + 1
                }
                if abs(x2!) <= 1.0
                {
                    roots = roots + 1
                }
                if x1! < -1.0
                {
                    x1 = x2
                }
            }
            
            if roots == 1
            {
                if h0 < 0.0
                {
                    rise = Double(i) + x1!
                }
                else
                {
                    set = Double(i) + x1!
                }
            }
            else if roots == 2
            {
                rise = Double(i) + (ye < 0.0 ? x2! : x1!)
                set = Double(i) + (ye < 0.0 ? x1! : x2!)
            }
            
            if (rise != nil && set != nil)
            {
                break
            }
            
            h0 = h2
        }
        
        var result: Dictionary<String, Date?> = ["rise": nil, "set": nil]
        
        if (rise != nil)
        {
            result["rise"] = hoursLater(date: t, h: rise!)
        }
        if (set != nil)
        {
            result["set"] = hoursLater(date: t, h: set!)
        }
                
        return result
    }
}

/**
 Custom exception for the Suncalc library
 */
fileprivate enum SuncalcException: Error
{
    case message(msg: String)
}

/**
 Date extension to obtain the Date since 1970, and to get the time interval since 1970 in milli
 (the latter init() method call)
 (see https://stackoverflow.com/a/40135192)
 
 - usage:
 Date().millisecondsSince1970 // 1476889390939
 Date(milliseconds: 0) // "Dec 31, 1969, 4:00 PM" (PDT variant of 1970 UTC)
 */
fileprivate extension Date
{
    // Extended functionality to get milliseconds from 1970 to present time
    var millisecondsSince1970:Int
    {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    // Obtaining the time interval since 1970 for a given amount of milliseconds
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
