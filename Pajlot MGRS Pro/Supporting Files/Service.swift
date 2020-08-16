

import UIKit

class Service {

    static let shared = Service()
    
    func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (()->Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        
        on.present(alert, animated: true, completion: completion)
    }
 
    // Number of digits to display for x,y coords
    //  One digit:    10 km precision      eg. "18S UJ 2 1"
    //  Two digits:   1 km precision       eg. "18S UJ 23 06"
    //  Three digits: 100 meters precision eg. "18S UJ 234 064"
    //  Four digits:  10 meters precision  eg. "18S UJ 2348 0647"
    //  Five digits:  1 meter precision    eg. "18S UJ 23480 06470"
    
    /************* retrieve zone number from latitude, longitude *************
     Zone number ranges from 1 - 60 over the range [-180 to +180]. Each
     range is 6 degrees wide. Special cases for points outside normal
     [-80 to +84] latitude zone.
     *************************************************************************/

    
    func getZoneNumber (lat: Float, long: Float) -> Int {
    
        if (long > 360 || long < -180 || lat > 84 || lat < -80) {
            print("getZoneNumber: invalid input. lat: \(lat.roundTo(places: 4)) long: \(long.roundTo(places: 4))")
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
        return zoneNumber
    }
    

    
    /***************** convert latitude, longitude to UTM  *******************
     East Longitudes are positive, West longitudes are negative.
     North latitudes are positive, South latitudes are negative
     lat and lon are in decimal degrees
     
     output is in the input array utmcoords
     utmcoords[0] = easting
     utmcoords[1] = northing (NEGATIVE value in southern hemisphere)
     utmcoords[2] = zone
     ***************************************************************************/
    
    //["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]

    //["C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "W", "X"]
    
    
    func GZDletterDesignator(lat: Float) -> Character{
        //          CDEFGHJKLM    |   NPQRSTUVWX
        
        //let GZDLettersArray = "CDEFGHJKLMNPQRSTUVWX"

        if (lat > 84 || lat < -80) {
            print("GZDletterDesignator: latitude out of range")
            return "Z"
        }else if lat >= 0{
            //lat N
            let index = Int((lat / 8).rounded(.awayFromZero) + 9)
            return Array(latBands)[index]
        }else {
            //lat S
            let index = 10 - Int((lat / 8).rounded(.awayFromZero))
            return Array(latBands)[index]
        }
    }
    
     /*
    func MGRStoUTM (zone: Int, band: Character, e100k: Character, n100k: Character, easting: Int, northing: Int) {
        
    
        let index = Array(latBands).firstIndex(of: band)
        let hemisphere = ( index! <= 9 ? "N" : "S" )
        
        // get easting specified by e100k
        let col = Array(e100kLetters[(zone - 1) % 3]).firstIndex(of: e100k)! + 1
        var e100kNum = col * 100000

        
        // get northing specified by n100k
        let row = Array(n100kLetters[(zone - 1) % 2]).firstIndex(of: n100k)!
        var n100kNum = row * 100000
        
        // get latitude of (bottom of) band
        var latBand = (Array(latBands).firstIndex(of: band)! - 10) * 8
        
        
       
        // northing of bottom of band, extended to include entirety of bottommost 100km square
        // (100km square boundaries are aligned with 100km UTM northing intervals)
        var nBand = Math.floor(new LatLon(latBand, 0).toUtm().northing/100e3)*100e3;
        // 100km grid square row letters repeat every 2,000km north; add enough 2,000km blocks to get
        // into required band
        var n2M = 0; // northing of 2,000km block
        while (n2M + n100kNum + northing < nBand) n2M += 2000e3;
        
        return new Utm(zone, hemisphere, e100kNum+easting, n2M+n100kNum+northing, this.datum);
 
    }
    */
    /*
    func LLtoUTM(lat: Float, long: Float) {
        
        if (lat > 84 || lat < -80) {
            print("LLtoUTN: latitude out of UTM range")
        }
        
        let falseEasting = 500000, falseNorthing = 10000000
        
        var zone = floor((long + 180) / 6) + 1 // longitudinal zone
        var λ0 = Double(((zone - 1) * 6 - 180 + 3).degreesToRadians) // longitude of central meridian
        
        // ---- handle Norway/Svalbard exceptions
        // grid zones are 8° tall; 0°N is offset 10 into latitude bands array
        //var mgrsLatBands = 'CDEFGHJKLMNPQRSTUVWXX'; // X is repeated for 80-84°N
        
        let latBand = Array(latBands)[Int(floor(lat / 8 + 10))]
        
        // adjust zone & central meridian for Norway
        if (zone == 31 && latBand == "V" && long >= 3) {
            zone += 1
            λ0 += (6.0).degreesToRadians
        }
        
        // adjust zone & central meridian for Svalbard
        if (zone == 32 && latBand == "X" && long < 9) {
            zone -= 1
            λ0 -= (6.0).degreesToRadians
        }
        
        if (zone == 32 && latBand == "X" && long >= 9) {
            zone += 1
            λ0 += (6.0).degreesToRadians
            
        }
        if (zone == 34 && latBand == "X" && long  < 21) {
            zone -= 1
            λ0 -= (6.0).degreesToRadians
        }
        if (zone == 34 && latBand == "X" && long  >= 21) {
            zone += 1
            λ0 += (6.0).degreesToRadians
        }
        if (zone == 36 && latBand == "X" && long  < 33) {
            zone -= 1
            λ0 -= (6.0).degreesToRadians
        }
        if (zone == 36 && latBand == "X" && long  >= 33) {
            zone += 1
            λ0 += (6.0).degreesToRadians
        }
        
        var φ = lat.degreesToRadians      // latitude ± from equator
        var λ = Double(long.degreesToRadians) - λ0 // longitude ± from central meridian
        
        //var a = this.datum.ellipsoid.a, f = this.datum.ellipsoid.f;
        let a = 6378137, b = 6356752.314245, f = 1/298.257223563
        
        var k0 = 0.9996 // UTM scale on the central meridian
        
        var e = (f * (2-f)).squareRoot() // eccentricity
        var n = f / (2 - f)             // 3rd flattening
        let n2 = n * n, n3 = n * n2, n4 = n * n3, n5 = n * n4, n6 = n * n5 // TODO: compare Horner-form accuracy?
        
        var cosλ = cos(λ), sinλ = sin(λ), tanλ = tan(λ)
        
        var τ = tan(φ) // τ ≡ tanφ, τʹ ≡ tanφʹ; prime (ʹ) indicates angles on the conformal sphere
        var σ = sinh(e * Double(atanh(e * Double(τ / (1 + τ * τ).squareRoot()))))
        
        
        
        let temp1 = (1 + σ * σ).squareRoot()
        let temp2 = (1 + τ * τ).squareRoot()
        
        var τʹ = τ * temp1 - σ * temp2
        
        var ξʹ = atan2(τʹ, cosλ)
        var ηʹ = asinh(sinλ / (τʹ * τʹ + cosλ * cosλ).squareRoot())
        
        var A = a/(1+n) * (1 + 1/4 * n2 + 1/64 * n4 + 1/256 * n6) // 2πA is the circumference of a meridian
        
        var α = [ nil, // note α is one-based array (6th order Krüger expressions)
                    1/2 * n - 2/3 * n2 + 5/16 * n3 + 41/180 * n4 - 127/288 * n5 + 7891/37800 * n6,
                    13/48 * n2 - 3/5 * n3 + 557/1440 * n4 + 281/630 * n5 - 1983433/1935360 * n6,
                                61/240 * n3 - 103/140 * n4 + 15061/26880 * n5 + 167603/181440 * n6,
                                            49561/161280 * n4 - 179/168 * n5 + 6601661/7257600 * n6,
                                                            34729/80640 * n5 - 3418889/1995840 * n6,
                                                                            212378941/319334400 * n6]
 
    }
    */
    
    /**
    * Mgrs grid reference object.
    *
    * @constructor
    * @param  {number} zone - 6° longitudinal zone (1..60 covering 180°W..180°E).
    * @param  {string} band - 8° latitudinal band (C..X covering 80°S..84°N).
    * @param  {string} e100k - First letter (E) of 100km grid square.
    * @param  {string} n100k - Second letter (N) of 100km grid square.
    * @param  {number} easting - Easting in metres within 100km grid square.
    * @param  {number} northing - Northing in metres within 100km grid square.
    * @param  {LatLon.datum} [datum=WGS84] - Datum UTM coordinate is based on.
    * @throws {Error}  Invalid MGRS grid reference.
    *
    * @example
    *   var mgrsRef = new Mgrs(31, 'U', 'D', 'Q', 48251, 11932); // 31U DQ 48251 11932
    */
    

}
