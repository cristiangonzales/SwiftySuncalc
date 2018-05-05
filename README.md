# SwiftySuncalc

[![Travis CI](https://api.travis-ci.org/cristiangonzales/SwiftySuncalc.svg?branch=master)](https://travis-ci.org/cristiangonzales/SwiftySuncalc)
[![](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)]()
[![](https://img.shields.io/badge/Swift-4.0--4.1.x-blue.svg)]()
[![](https://img.shields.io/badge/License-MIT-red.svg)]()
[![Swift Version](https://img.shields.io/badge/Swift-4.x-F16D39.svg?style=flat)](https://developer.apple.com/swift)

<p align="center">
    <img src="https://vignette.wikia.nocookie.net/lakewood-plaza-turbo/images/b/b2/Cool_sun.png/revision/latest?cb=20180305223605" width="33%">
</p>

Per the original suncalc project [README](https://github.com/mourner/suncalc/blob/master/README.md),
```
SunCalc is a tiny BSD-licensed JavaScript library for calculating sun position, sunlight phases (times for sunrise, sunset, dusk, etc.), moon position and lunar phase for the given location and time, created by Vladimir Agafonkin (@mourner) as a part of the SunCalc.net project.

Most calculations are based on the formulas given in the excellent Astronomy Answers articles about position of the sun and the planets. You can read about different twilight phases calculated by SunCalc in the Twilight article on Wikipedia.
```
That Wikipedia article can be found [here](http://en.wikipedia.org/wiki/Twilight). This Swift library is a port of the original [suncalc.js library](https://github.com/mourner/suncalc), as created by [Vladimir Agafonkin](http://agafonkin.com/en) [@mourner](https://github.com/mourner).

Reference
---
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
