import UIKit

var str = "Hello, playground"

var lat = 79.3230
var long = 12.32137

if (long > 360 || long < -180 || lat > 84 || lat < -80) {
    print("getZoneNumber: invalid input. lat: \(lat)) long: \(long)")
}

// convert 0-360 to [-180 to 180] range
let longTemp = (long + 180) - ((long + 180) / 360).rounded(.down) * 360 - 180
var zoneNumber = Int(((longTemp + 180) / 6).rounded(.down) + 1)

// Handle special case of west coast of Norway
if (lat >= 56.0 && lat < 64.0 && longTemp >= 3.0 && longTemp < 12.0) {
    zoneNumber = 32
}

// Special zones for Svalbard
if (lat >= 72.0 && lat < 84.0) {
    if (longTemp >= 0.0 && longTemp < 9.0) {
        zoneNumber = 31
    }
    else if (longTemp >= 9.0 && longTemp < 21.0) {
        zoneNumber = 33
    }
    else if (longTemp >= 21.0 && longTemp < 33.0) {
        zoneNumber = 35
    }
    else if (longTemp >= 33.0 && longTemp < 42.0) {
        zoneNumber = 37
    }
}
print (zoneNumber)


if lat > 84.0 || lat < -80.0 {
    print("Latitude out of range")
}
//let val: Float = 9.623432
//val / 8
//var index1: Float = (val / 8).rounded(.awayFromZero)
//var index2: Float = (val / 8).rounded(.down)
//var index3: Float = (val / 8).rounded(.toNearestOrAwayFromZero)
//var index4: Float = (val / 8).rounded(.toNearestOrEven)
//var index5: Float = (val / 8).rounded(.towardZero)
//var index6: Float = (val / 8).rounded(.up)

let GZDLettersArray = "CDEFGHJKLMNPQRSTUVWX"

//let modulo8: Double = lat % 8.0

if (lat > 84 || lat < -80) {
    print("Z")
}else if lat >= 0{
    //lat N
    if lat >= 80 {
        print(Array(GZDLettersArray)[19])
    }else{
        let index = Int((lat / 8).rounded(.awayFromZero) + 9)
        print(Array(GZDLettersArray)[index])
    }
}else {
    //lat S
    let index = 10 + Int((lat / 8).rounded(.awayFromZero))
    print(Array(GZDLettersArray)[index])
}
