# SwiftySuncalc

[![Travis CI](https://api.travis-ci.org/cristiangonzales/SwiftySuncalc.svg?branch=master)](https://travis-ci.org/cristiangonzales/SwiftySuncalc)
[![](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)]()
[![](https://img.shields.io/badge/Swift-4.0--4.1.x-blue.svg)]()
[![](https://img.shields.io/badge/License-MIT-red.svg)]()
[![](https://img.shields.io/cocoapods/v/SwiftySuncalc.svg)]()

<p align="center">
    <img src="https://vignette.wikia.nocookie.net/lakewood-plaza-turbo/images/b/b2/Cool_sun.png/revision/latest?cb=20180305223605" width="33%">
</p>

Per the original suncalc project [README](https://github.com/mourner/suncalc/blob/master/README.md),
```
SunCalc is a tiny BSD-licensed JavaScript library for calculating sun position, sunlight phases
(times for sunrise, sunset, dusk, etc.), moon position and lunar phase for the given location
and time, created by Vladimir Agafonkin (@mourner) as a part of the SunCalc.net project.

Most calculations are based on the formulas given in the excellent Astronomy Answers articles
about position of the sun and the planets. You can read about different twilight phases calculated
by SunCalc in the Twilight article on Wikipedia.
```
That Wikipedia article can be found [here](http://en.wikipedia.org/wiki/Twilight). This Swift library is a port of the original [suncalc.js library](https://github.com/mourner/suncalc), as created by [Vladimir Agafonkin](http://agafonkin.com/en) ([@mourner](https://github.com/mourner)). All information on this `README` is taken from the original suncalc.js library's [README](https://github.com/mourner/suncalc/blob/master/README.md).

Usage
---
```Swift
// Declare a new SwiftySuncalc object
var suncalc: SwiftySuncalc! = SwiftySuncalc()
// Get moon illumination times for today
var moonIllumination = suncalc.getMoonIllumination(date: Date())
// Get the angle of the moon from the dictionary, `moonIllumination`
var moonAngle = moonIllumination["angle"]
// Find out the times for today (e.g. sunset or sunrise)
var times = suncalc.getTimes(date: Date(), lat: 51.5, lng: -0.5);
// Find out the time for nadir today
var nadir: Double = times["nadir"]
```

Installation
---
Currently, SwiftySuncalc is only available through [CocoaPods](https://cocoapods.org/) for Swift 4.x. Add the following to your `Podfile`:
```Ruby
target 'YourTargetApp' do
  pod 'SwiftySuncalc', '~> 1.0'
end
```
Then run a `pod install` inside your terminal, or from CocoaPods.app. Alternatively to give it a test run, run the command:
```Ruby
pod try SwiftySuncalc
```

Reference
---

### Sunlight times
```Swift
func getTimes(date: Date, lat: Double, lng: Double) -> Dictionary<String, Date>
```
This method call returns an object with the following properties, returning a Date() object

| Property        | Description                                                              |
| --------------- | ------------------------------------------------------------------------ |
| `sunrise`       | sunrise (top edge of the sun appears on the horizon)                     |
| `sunriseEnd`    | sunrise ends (bottom edge of the sun touches the horizon)                |
| `goldenHourEnd` | morning golden hour (soft light, best time for photography) ends         |
| `solarNoon`     | solar noon (sun is in the highest position)                              |
| `goldenHour`    | evening golden hour starts                                               |
| `sunsetStart`   | sunset starts (bottom edge of the sun touches the horizon)               |
| `sunset`        | sunset (sun disappears below the horizon, evening civil twilight starts) |
| `dusk`          | dusk (evening nautical twilight starts)                                  |
| `nauticalDusk`  | nautical dusk (evening astronomical twilight starts)                     |
| `night`         | night starts (dark enough for astronomical observations)                 |
| `nadir`         | nadir (darkest moment of the night, sun is in the lowest position)       |
| `nightEnd`      | night ends (morning astronomical twilight starts)                        |
| `nauticalDawn`  | nautical dawn (morning nautical twilight starts)                         |
| `dawn`          | dawn (morning nautical twilight ends, morning civil twilight starts)     |

```Swift
func addTime(angle: Double, riseName: String, setName: String)
```
Adds a custom time with the angle of degrees, the rise name, and the set name.

### Sun position
```Swift
func getPosition(date: Date, lat: Double, lng: Double) -> Dictionary<String, Double>
```
Returns a dictionary with the following keys:
* `altitude`: moon altitude above the horizon in radians
* `azimuth`: moon azimuth in radians
* `distance`: distance to moon in kilometers
* `parallacticAngle`:  parallactic angle of the moon in radians

### Moon illumination
```Swift
func getMoonIllumination(date: Date) -> Dictionary<String, Double>
```
Returns a dictionary with the following keys:
* `fraction`: illuminated fraction of the moon; varies from `0.0` (new moon) to `1.0` (full moon)
* `phase`: moon phase; varies from `0.0` to `1.0`, described below
* `angle`: midpoint angle in radians of the illuminated limb of the moon reckoned eastward from the north point of the disk; the moon is waxing if the angle is negative, and waning if positive

Moon phase value should be interpreted like this:

| Phase | Name            |
| -----:| --------------- |
| 0     | New Moon        |
|       | Waxing Crescent |
| 0.25  | First Quarter   |
|       | Waxing Gibbous  |
| 0.5   | Full Moon       |
|       | Waning Gibbous  |
| 0.75  | Last Quarter    |
|       | Waning Crescent |

By subtracting the `parallacticAngle` from the `angle` one can get the zenith angle of the moons bright limb (anticlockwise).
The zenith angle can be used do draw the moon shape from the observers perspective (e.g. moon lying on its back).

### Moon rise and set times
```Swift
func getMoonTimes(date: Date, lat: Double, lng: Double) -> Dictionary<String, Date?>
```
Returns an object with the following properties:
* `rise`: moonrise time as `Date`
* `set`: moonset time as `Date`
* `alwaysUp`: `true` if the moon never rises/sets and is always _above_ the horizon during the day
* `alwaysDown`: `true` if the moon is always _below_ the horizon

By default, it will search for moon rise and set during local user's day (from 0 to 24 hours).
